//
//  Brain.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

class Brain {
    var legalkey: Bool = false
    func shortDisplayData() -> DisplayData {
        displayData(digits: Configuration.shared.digitsInSmallDisplay)
    }
    
    var allDigitsDisplayData: DisplayData {
        displayData(digits: 10000) // TODO Bogus
    }
    
    var memory: Gmp = Gmp()
    
    private let debug = true
    private var displayString: String? = "0"
    
    internal var operatorStack = OperatorStack() // TODO private after testing
    internal var gmpStack = GmpStack()
        
    private func displayData(digits: Int) -> DisplayData {
        if let last = gmpStack.last {
            return DisplayData(gmp: last, digits: digits)
        } else {
            return DisplayData()
        }
    }
    var isValid: Bool { gmpStack.last!.isValid }
    func isAllowed() -> Bool {
        return true
    }

    func clearmemory() {
        memory = Gmp()
    }
    func addToMemory(_ plus: Gmp) {
        memory.add(other: plus)
        print("X memory=\(memory.toDouble())")
        displayString = nil
    }
    func substractFromMemory(_ minus: Gmp) {
        memory.sub(other: minus)
        print("X memory=\(memory.toDouble())")
        displayString = nil
    }
    func getMemory() {
        if displayString == nil {
            gmpStack.append(memory)
        } else {
            gmpStack.replaceLast(with: memory)
        }

        print("X memory=\(memory.toDouble())")
        print("X gmpStack.last?=\(gmpStack.last!.toDouble())")
    }

    var last: Gmp? {
        gmpStack.last
    }
    func addDigitToNumberString(_ digit: Character) {
        if digit == "," {
            if displayString == nil {
                displayString = "0,"
                gmpStack.replaceLast(with: Gmp(displayString!))
            } else {
                if !displayString!.contains(",") {
                    displayString!.append(",")
                    // do nothing with the gmpStack
                }
            }
        } else {
            // normal digit
            if displayString == nil {
                displayString = String(digit)
                gmpStack.append(Gmp(displayString!))
            } else if displayString == "0" {
                displayString = String(digit)
                gmpStack.replaceLast(with: Gmp(displayString!))
            } else {
                displayString!.append(digit)
                gmpStack.replaceLast(with: Gmp(displayString!))
            }
        }
        
        if gmpStack.count == 0 {
            print("X ### ERROR")
            return
        }
        if displayString == nil {
            print("X ### ERROR")
            return
        }
        print("X after add \"\(digit)\": " +
              "gmps: \(gmpStack.count), " +
              "ops: \(operatorStack.count) " +
              "displayString: \(displayString ?? "nil")")
    }
    
    func reset() {
        operatorStack.removeAll()
        gmpStack.removeAll()
        displayString = nil
        addDigitToNumberString("0")
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
                if gmpStack.count >= 2 {
                    let gmp2 = gmpStack.popLast()!
                    let gmp1 = gmpStack.last!
                    gmp1.execute(twoOperand.operation, with: gmp2)
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
        if operatorStack.count == 0 && gmpStack.count >= 1 {
            if let last = gmpStack.last {
                last.mul(other: Gmp("0.01"))
                gmpStack.replaceLast(with: last)
            }
            
        } else if operatorStack.count >= 1 && gmpStack.count >= 2 {
            if let last = gmpStack.last {
                if let secondLast = gmpStack.secondLast {
                    last.mul(other: Gmp("0.01"))
                    last.mul(other: secondLast)
                    gmpStack.replaceLast(with: last)
                }
            }
        }
    }
    
    func operation(_ symbol: String) {
        if symbol == "C" {
            reset()
        } else if symbol == "=" {
            execute(priority: Operator.equalPriority)
            displayString = nil
        } else if symbol == "(" {
            operatorStack.push(openParenthesis)
        } else if symbol == ")" {
            execute(priority: Operator.closedParenthesesPriority)
        } else if symbol == "%" {
            percentage()
        } else if let op = inplaceOperators[symbol] {
            gmpStack.modifyLast(withOp: op.operation)
            displayString = nil
        } else if let op = twoOperandOperators[symbol] {
//            if displayString == nil {
//                /// the user seems to have changed his mind
//                /// correct operation
//                operatorStack.removeLast()
//                operatorStack.push(op)
//            } else {
                execute(priority: op.priority)
                operatorStack.push(op)
//            }
            displayString = nil
        }
        print("X after op  \"\(symbol)\": " +
              "gmps: \(gmpStack.count), " +
              "ops: \(operatorStack.count) " +
              "displayString: \(displayString ?? "nil")")
        print("X "+operatorStack.debugDescription)
    }

}
