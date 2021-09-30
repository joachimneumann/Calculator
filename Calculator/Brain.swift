//
//  Brain.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

import Foundation

class Brain: ObservableObject {
    private var n = NumberStack()
    var operatorStack = OperatorStack() // TODO private after testing

    
    var display: String { n.display }
    @Published var secondKeys: Bool = false
    @Published var rad: Bool = false
    var longDisplayString: String { n.longDisplay }
    var hasMoreDigits: Bool { n.hasMoreDigits }
    var pendingOperator: String?
    var memory: Gmp? = nil

    var constantOperators:   Dictionary <String, Inplace> = [:]
    var inplaceOperators:    Dictionary <String, Inplace> = [:]
    var twoOperandOperators: Dictionary <String, TwoOperand> = [:]
    var openParenthesis:   Operator = Operator(0)
    var closedParenthesis: Operator = Operator(0)
    var equalOperator:     Operator = Operator(0)

    func isPending(_ symbol: String) -> Bool {
        if pendingOperator != nil {
            return pendingOperator == symbol
        }
        return false
    }

    func digit(_ digit: Int) {
        if pendingOperator != nil {
            n.append(Gmp())
            pendingOperator = nil
        }
        n.last.digit(digit)
        objectWillChange.send()
    }
    
    var digitsAllowed: Bool { true }
    var inPlaceAllowed: Bool { n.isValid }
    
    func zero() {
        if pendingOperator != nil {
            n.append(Gmp())
            pendingOperator = nil
        }
        n.last.zero()
        objectWillChange.send()
    }
    func comma() {
        if pendingOperator != nil {
            n.append(Gmp())
            pendingOperator = nil
        }
        n.last.comma()
        objectWillChange.send()
    }
    
    func execute(priority newPriority: Int) {
        while !operatorStack.isEmpty && operatorStack.last!.priority >= newPriority {
            let op = operatorStack.pop()
            if let twoOperand = op as? TwoOperand {
                if n.count >= 2 {
                    let gmp2 = n.popLast()!.gmp
                    n.last.gmp.execute(twoOperand.operation, with: gmp2)
                }
            }
        }
        if
            newPriority == Operator.closedParenthesesPriority &&
                !operatorStack.isEmpty &&
                operatorStack.last!.priority == Operator.openParenthesesPriority {
            operatorStack.removeLast()
        }
    }

    func percentage() {
        if operatorStack.count == 0 {
            n.last.gmp.mul(other: Gmp("0.01"))
        } else if operatorStack.count >= 1 && n.count >= 2 {
            if let secondLast = n.secondLast {
                n.last.gmp.mul(other: Gmp("0.01"))
                n.last.gmp.mul(other: secondLast.gmp)
            }
        }
    }
    
    func operation(_ symbol: String, withPending: Bool = true) {
        if symbol == "C" {
            reset()
        } else if symbol == "=" {
            execute(priority: Operator.equalPriority)
        } else if symbol == "(" {
            operatorStack.push(openParenthesis)
        } else if symbol == ")" {
            execute(priority: Operator.closedParenthesesPriority)
        } else if symbol == "%" {
            percentage()
        } else if let op = constantOperators[symbol] {
            if pendingOperator != nil {
                n.append(Gmp())
                pendingOperator = nil
            }
            n.modifyLast(withOp: op.operation)
        } else if let op = inplaceOperators[symbol] {
            n.modifyLast(withOp: op.operation)
        } else if let op = twoOperandOperators[symbol] {
            if withPending { pendingOperator = symbol }
            execute(priority: op.priority)
            operatorStack.push(op)
        } else {
            assert(false)
        }
        print("X after op   (\"\(symbol)\": " +
              "numbers: \(n.count), " +
              "ops: \(operatorStack.count), " +
              "display: \(display)")
        objectWillChange.send()
    }
    func reset() {
        operatorStack.removeAll()
        n.removeAll()
        pendingOperator = nil
        n.append(Gmp())
        objectWillChange.send()
    }
    func clearMemory() {
        memory = nil
        objectWillChange.send()
    }
    func addToMemory() {
        if memory == nil {
            memory = n.last.gmp.copy()
        } else {
            memory!.add(other: n.last.gmp)
        }
        objectWillChange.send()
    }
    func subtractFromMemory() {
        if memory == nil {
            memory = n.last.gmp.copy()
            memory!.changeSign()
        } else {
            memory!.sub(other: n.last.gmp)
        }
        objectWillChange.send()
    }
    func getMemory() {
        if memory != nil {
            let temp = memory!.copy()
            let num = Number(temp)
            n.replaceLast(with: num)
        }
        objectWillChange.send()
    }

    func isAllowed() -> Bool { return true } /// TODO: needed?
    var nn: Int { n.count }
    var last: Number { n.last }

    init() {
        constantOperators = [
            "π":    Inplace(Gmp.π,    0),
            "e":    Inplace(Gmp.e,    0),
            "rand": Inplace(Gmp.rand, 0)
        ]
        twoOperandOperators = [
            "+":    TwoOperand(Gmp.add,     1),
            "-":    TwoOperand(Gmp.sub,     1),
            "x":    TwoOperand(Gmp.mul,     2),
            "/":    TwoOperand(Gmp.div,     2),
            "y√":   TwoOperand(Gmp.sqrty,   3),
            "x^y":  TwoOperand(Gmp.pow_x_y, 3),
            "y^x":  TwoOperand(Gmp.pow_y_x, 3),
            "logy": TwoOperand(Gmp.logy,    3),
            "x↑↑y": TwoOperand(Gmp.x_double_up_arrow_y, 3),
            "EE":   TwoOperand(Gmp.EE,      3)
        ]
        inplaceOperators = [
            "+/-":    Inplace(Gmp.changeSign,     1),
            "x^2":    Inplace(Gmp.pow_x_2,     1),
            "One_x":  Inplace(Gmp.rez,     1),
            "x!":     Inplace(Gmp.fac,     1),
            "Z":      Inplace(Gmp.Z,     1),
            "ln":     Inplace(Gmp.ln,     1),
            "log10":  Inplace(Gmp.log10,     1),
            "log2":   Inplace(Gmp.log2,     1),
            "√":      Inplace(Gmp.sqrt,     1),
            "3√":     Inplace(Gmp.sqrt3,     1),
            "sin":    Inplace(Gmp.sin,     1),
            "cos":    Inplace(Gmp.cos,     1),
            "tan":    Inplace(Gmp.tan,     1),
            "asin":   Inplace(Gmp.asin,     1),
            "acos":   Inplace(Gmp.acos,     1),
            "atan":   Inplace(Gmp.atan,     1),
            "sinh":   Inplace(Gmp.sinh,     1),
            "cosh":   Inplace(Gmp.cosh,     1),
            "tanh":   Inplace(Gmp.tanh,     1),
            "asinh":  Inplace(Gmp.asinh,     1),
            "acosh":  Inplace(Gmp.acosh,     1),
            "atanh":  Inplace(Gmp.atanh,     1),
            "sinD":   Inplace(Gmp.sinD,     1),
            "cosD":   Inplace(Gmp.cosD,     1),
            "tanD":   Inplace(Gmp.tanD,     1),
            "asinD":  Inplace(Gmp.asinD,     1),
            "acosD":  Inplace(Gmp.acosD,     1),
            "atanD":  Inplace(Gmp.atanD,     1),
            "sinhD":  Inplace(Gmp.sinhD,     1),
            "coshD":  Inplace(Gmp.coshD,     1),
            "tanhD":  Inplace(Gmp.tanhD,     1),
            "asinhD": Inplace(Gmp.asinhD,     1),
            "acoshD": Inplace(Gmp.acoshD,     1),
            "atanhD": Inplace(Gmp.atanhD,     1),
            "2^x":    Inplace(Gmp.pow_2_x,     1),
            "x^3":    Inplace(Gmp.pow_x_3,     1),
            "e^x":    Inplace(Gmp.pow_e_x,     1),
            "10^x":   Inplace(Gmp.pow_10_x,     1)
        ]
        openParenthesis   = Operator(Operator.openParenthesesPriority)
        closedParenthesis = Operator(Operator.openParenthesesPriority)
        equalOperator     = Operator(Operator.equalPriority)
        reset()
    }
}
