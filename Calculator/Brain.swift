//
//  Brain.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

enum DisplayIsBasedOn {
    case typing
    case Gmp
}

class Brain {
    private var n = NumberStack()
    var display: String {
        n.display
    }
    var longDisplay: String { n.longDisplay }
    var hasMoreDigits: Bool { n.hasMoreDigits }

    var pendingOperator: String?

    func reset() {
        operatorStack.removeAll()
        n.removeAll()
        typedString = "0"
        pendingOperator = nil
        n.append(Gmp())
    }
    
    func digit(_ digit: Int) {
        if pendingOperator != nil {
            n.append(Gmp())
            pendingOperator = nil
        }
        n.last.digit(digit)
    }
    
    private var typedString: String = "0"

    func typed(_ new: String) {
        typedString += new
        print("X after typed(\"\(new)\": " +
              "numbers: \(n.count), " +
              "ops: \(operatorStack.count), " +
              "typedString: \(typedString), " +
              "display: \(display)")
        //print("X "+operatorStack.debugDescription)
    }
    func comma() {
        if pendingOperator != nil {
            n.append(Gmp())
            pendingOperator = nil
        }
        n.last.comma()
    }
    
    func zero() {
        if pendingOperator != nil {
            n.append(Gmp())
            pendingOperator = nil
        }
        n.last.zero()
    }
    
    var memory: Gmp? = nil
        
    var operatorStack = OperatorStack() // TODO private after testing
    
    var isValid: Bool {
        n.isValid
    }
    var last: Number {
        n.last
    }
    var nn: Int { n.count }
    func isAllowed() -> Bool {
        return true
    }
    func clearmemory() {
        memory = nil
    }
    func addToMemory(_ plus: Gmp) {
        if memory == nil {
            memory = plus
        } else {
            memory!.add(other: plus)
        }
        print("X memory=\(memory!.toDouble())")
    }
    func substractFromMemory(_ minus: Gmp) {
        if memory == nil {
            memory = minus
        } else {
            memory!.sub(other: minus)
        }
        print("X memory=\(memory!.toDouble())")
    }
    func getMemory() {
        n.replaceLast(with: Number(memory!))
    }
    
    var constantOperators:   Dictionary <String, Inplace> = [:]
    var inplaceOperators:    Dictionary <String, Inplace> = [:]
    var twoOperandOperators: Dictionary <String, TwoOperand> = [:]
    var openParenthesis:   Operator = Operator(0, {true})
    var closedParenthesis: Operator = Operator(0, {true})
    var equalOperator:     Operator = Operator(0, {true})
    
    init() {
        constantOperators = [
            "π":    Inplace(Gmp.π,    0, isAllowed),
            "e":    Inplace(Gmp.e,    0, isAllowed),
            "rand": Inplace(Gmp.rand, 0, isAllowed)
        ]
        twoOperandOperators = [
            "+":    TwoOperand(Gmp.add,     1, isAllowed),
            "-":    TwoOperand(Gmp.sub,     1, isAllowed),
            "x":    TwoOperand(Gmp.mul,     2, isAllowed),
            "/":    TwoOperand(Gmp.div,     2, isAllowed),
            "y√":   TwoOperand(Gmp.sqrty,   3, isAllowed),
            "x^y":  TwoOperand(Gmp.pow_x_y, 3, isAllowed),
            "y^x":  TwoOperand(Gmp.pow_y_x, 3, isAllowed),
            "logy": TwoOperand(Gmp.logy,    3, isAllowed),
            "x↑↑y": TwoOperand(Gmp.x_double_up_arrow_y, 3, isAllowed),
            "EE":   TwoOperand(Gmp.EE,      3, isAllowed),
        ]
        inplaceOperators = [
            "+/-":    Inplace(Gmp.changeSign,     1, isAllowed),
            "x^2":    Inplace(Gmp.pow_x_2,     1, isAllowed),
            "One_x":  Inplace(Gmp.rez,     1, isAllowed),
            "x!":     Inplace(Gmp.fac,     1, isAllowed),
            "Z":      Inplace(Gmp.Z,     1, isAllowed),
            "ln":     Inplace(Gmp.ln,     1, isAllowed),
            "log10":  Inplace(Gmp.log10,     1, isAllowed),
            "log2":   Inplace(Gmp.log2,     1, isAllowed),
            "√":      Inplace(Gmp.sqrt,     1, isAllowed),
            "3√":     Inplace(Gmp.sqrt3,     1, isAllowed),
            "sin":    Inplace(Gmp.sin,     1, isAllowed),
            "cos":    Inplace(Gmp.cos,     1, isAllowed),
            "tan":    Inplace(Gmp.tan,     1, isAllowed),
            "asin":   Inplace(Gmp.asin,     1, isAllowed),
            "acos":   Inplace(Gmp.acos,     1, isAllowed),
            "atan":   Inplace(Gmp.atan,     1, isAllowed),
            "sinh":   Inplace(Gmp.sinh,     1, isAllowed),
            "cosh":   Inplace(Gmp.cosh,     1, isAllowed),
            "tanh":   Inplace(Gmp.tanh,     1, isAllowed),
            "asinh":  Inplace(Gmp.asinh,     1, isAllowed),
            "acosh":  Inplace(Gmp.acosh,     1, isAllowed),
            "atanh":  Inplace(Gmp.atanh,     1, isAllowed),
            "sinD":   Inplace(Gmp.sinD,     1, isAllowed),
            "cosD":   Inplace(Gmp.cosD,     1, isAllowed),
            "tanD":   Inplace(Gmp.tanD,     1, isAllowed),
            "asinD":  Inplace(Gmp.asinD,     1, isAllowed),
            "acosD":  Inplace(Gmp.acosD,     1, isAllowed),
            "atanD":  Inplace(Gmp.atanD,     1, isAllowed),
            "sinhD":  Inplace(Gmp.sinhD,     1, isAllowed),
            "coshD":  Inplace(Gmp.coshD,     1, isAllowed),
            "tanhD":  Inplace(Gmp.tanhD,     1, isAllowed),
            "asinhD": Inplace(Gmp.asinhD,     1, isAllowed),
            "acoshD": Inplace(Gmp.acoshD,     1, isAllowed),
            "atanhD": Inplace(Gmp.atanhD,     1, isAllowed),
            "2^x":    Inplace(Gmp.pow_2_x,     1, isAllowed),
            "x^3":    Inplace(Gmp.pow_x_3,     1, isAllowed),
            "e^x":    Inplace(Gmp.pow_e_x,     1, isAllowed),
            "10^x":   Inplace(Gmp.pow_10_x,     1, isAllowed)
        ]
        openParenthesis   = Operator(Operator.openParenthesesPriority, isAllowed)
        closedParenthesis = Operator(Operator.openParenthesesPriority, isAllowed)
        equalOperator     = Operator(Operator.equalPriority, isAllowed)
        reset()
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
        }
        print("X after op   (\"\(symbol)\": " +
              "numbers: \(n.count), " +
              "ops: \(operatorStack.count), " +
              "typedString: \(typedString), " +
              "display: \(display)")
    }
    
}
