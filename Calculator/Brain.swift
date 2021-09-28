//
//  Brain.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

class Brain {
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
    
    init() {
        reset()
    }
    
    
    func execute(priority newPriority: Int) {
        while !operatorStack.isEmpty && operatorStack.last!.priority >= newPriority {
            let op = operatorStack.pop()
            if let twoOperand = op as? TwoOperands {
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
            if let openParentheses = Brain.operators[symbol] {
                operatorStack.push(openParentheses)
            }
        } else if symbol == ")" {
            if operatorStack.hasOpenParentheses {
                execute(priority: Operator.closedParenthesesPriority)
            }
        } else if symbol == "%" {
            percentage()
        } else if let op = Brain.inplaceOperations[symbol] {
            gmpStack.modifyLast(withOp: op)
            displayString = nil
        } else if let op = Brain.constDict[symbol] {
            if displayString == nil {
                gmpStack.append(Gmp())
                gmpStack.modifyLast(withOp: op)
            } else {
                gmpStack.modifyLast(withOp: op)
            }
            displayString = nil
        } else if let op = Brain.operators[symbol] {
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

    static let inplaceOperations: Dictionary <String, inplaceType> = [
        "+/-":    Gmp.changeSign,
        "x^2":    Gmp.pow_x_2,
        "oneOverX": Gmp.rez,
        "x!":     Gmp.fac,
        "Z":      Gmp.Z,
        "ln":     Gmp.ln,
        "log10":  Gmp.log10,
        "log2":   Gmp.log2,
        "√":      Gmp.sqrt,
        "3√":     Gmp.sqrt3,
        "sin":    Gmp.sin,
        "cos":    Gmp.cos,
        "tan":    Gmp.tan,
        "asin":   Gmp.asin,
        "acos":   Gmp.acos,
        "atan":   Gmp.atan,
        "sinh":   Gmp.sinh,
        "cosh":   Gmp.cosh,
        "tanh":   Gmp.tanh,
        "asinh":  Gmp.asinh,
        "acosh":  Gmp.acosh,
        "atanh":  Gmp.atanh,
        "sinD":   Gmp.sinD,
        "cosD":   Gmp.cosD,
        "tanD":   Gmp.tanD,
        "asinD":  Gmp.asinD,
        "acosD":  Gmp.acosD,
        "atanD":  Gmp.atanD,
        "sinhD":  Gmp.sinhD,
        "coshD":  Gmp.coshD,
        "tanhD":  Gmp.tanhD,
        "asinhD": Gmp.asinhD,
        "acoshD": Gmp.acoshD,
        "atanhD": Gmp.atanhD,
        "2^x":    Gmp.pow_2_x,
        "x^3":    Gmp.pow_x_3,
        "e^x":    Gmp.pow_e_x,
        "10^x":   Gmp.pow_10_x,
    ]
    
    static let constDict: Dictionary <String, inplaceType> = [
        // same Gmp function as inplaceOperations, but handled differently
        "π":    Gmp.π,
        "e":    Gmp.e,
        "rand": Gmp.rand
    ]
    
    static let operators: Dictionary <String, Operator> = [
        "+":    TwoOperands(Gmp.add, 1),
        "-":    TwoOperands(Gmp.sub, 1),
        "x":    TwoOperands(Gmp.mul, 2),
        "/":    TwoOperands(Gmp.div, 2),
        "y√":   TwoOperands(Gmp.sqrty, 3),
        "x^y":  TwoOperands(Gmp.pow_x_y, 3),
        "y^x":  TwoOperands(Gmp.pow_y_x, 3),
        "logy": TwoOperands(Gmp.logy, 3),
        "x↑↑y": TwoOperands(Gmp.x_double_up_arrow_y, 3),
        "(":    Operator(Operator.openParenthesesPriority),
    ]

}
