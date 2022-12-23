//
//  Brain.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

import Foundation

class Brain {
    private var n = NumberStack()
    private var operatorStack = OperatorStack()
    private (set) var precision: Int = 0
    var no: Int { operatorStack.count }
    var nn: Int { n.count }
    var haveResultCallback: () -> () = { }
    var pendingOperatorCallback: (String?) -> () = { _ in }
    var pendingOperator: String? {
        willSet {
            if pendingOperator != newValue {
                pendingOperatorCallback(newValue)
            }
        }
    }
    var memory: Number? = nil
    
    var isValidNumber: Bool { n.last.isValid }
    var debugLastAsDouble: Double { n.last.gmp!.toDouble() }
    var debugLastAsGmp: Gmp { n.last.gmp! }
    var last: Number { n.last }
    var nullNumber: Number {
        return Number("0", precision: precision)
    }
    
    let trigonometricOperators = ["sin", "sinD", "cos", "cosD", "tan", "tanD"]
    let constantOperators: Dictionary <String, Inplace> = [
        "π":    Inplace(Gmp.π, 0),
        "e":    Inplace(Gmp.e, 0),
        "Rand": Inplace(Gmp.rand, 0)
    ]
    let inplaceOperators: Dictionary <String, Inplace> = [
        "x^2":    Inplace(Gmp.pow_x_2, 1),
        "One_x":  Inplace(Gmp.rez, 1),
        "x!":     Inplace(Gmp.fac, 1),
        "Z":      Inplace(Gmp.Z, 1),
        "ln":     Inplace(Gmp.ln, 1),
        "log10":  Inplace(Gmp.log10, 1),
        "log2":   Inplace(Gmp.log2, 1),
        "√":      Inplace(Gmp.sqrt, 1),
        "3√":     Inplace(Gmp.sqrt3, 1),
        "sin":    Inplace(Gmp.sin, 1),
        "cos":    Inplace(Gmp.cos, 1),
        "tan":    Inplace(Gmp.tan, 1),
        "asin":   Inplace(Gmp.asin, 1),
        "acos":   Inplace(Gmp.acos, 1),
        "atan":   Inplace(Gmp.atan, 1),
        "sinh":   Inplace(Gmp.sinh, 1),
        "cosh":   Inplace(Gmp.cosh, 1),
        "tanh":   Inplace(Gmp.tanh, 1),
        "asinh":  Inplace(Gmp.asinh, 1),
        "acosh":  Inplace(Gmp.acosh, 1),
        "atanh":  Inplace(Gmp.atanh, 1),
        "sinD":   Inplace(Gmp.sinD, 1),
        "cosD":   Inplace(Gmp.cosD, 1),
        "tanD":   Inplace(Gmp.tanD, 1),
        "asinD":  Inplace(Gmp.asinD, 1),
        "acosD":  Inplace(Gmp.acosD, 1),
        "atanD":  Inplace(Gmp.atanD, 1),
        "2^x":    Inplace(Gmp.pow_2_x, 1),
        "x^3":    Inplace(Gmp.pow_x_3, 1),
        "e^x":    Inplace(Gmp.pow_e_x, 1),
        "10^x":   Inplace(Gmp.pow_10_x, 1)
    ]
    let twoOperandOperators: Dictionary <String, TwoOperand> = [
        "+":    TwoOperand(Gmp.add, 1),
        "-":    TwoOperand(Gmp.sub, 1),
        "x":    TwoOperand(Gmp.mul, 2),
        "/":    TwoOperand(Gmp.div, 2),
        "y√":   TwoOperand(Gmp.sqrty, 3),
        "x^y":  TwoOperand(Gmp.pow_x_y, 3),
        "y^x":  TwoOperand(Gmp.pow_y_x, 3),
        "logy": TwoOperand(Gmp.logy, 3),
        "x↑↑y": TwoOperand(Gmp.x_double_up_arrow_y, 3),
        "EE":   TwoOperand(Gmp.EE, 3)
    ]
    let openParenthesis = Operator(Operator.openParenthesesPriority)
    let closedParenthesis = Operator(Operator.openParenthesesPriority)
    let equalOperator = Operator(Operator.equalPriority)
    
    func replaceLast(with number: Number) {
        n.replaceLast(with: number)
    }
    
    func debugPress(_ digits: String) {
        for digit in digits {
            if let intValue = digit.wholeNumberValue {
                debugPress(intValue)
            } else {
                assert(false)
            }
        }
    }
    
    func debugPress(_ digit: Int) {
        if digit >= 0 && digit <= 9 {
            operation(String(digit))
        }
    }
    
    func execute(priority newPriority: Int) {
        while !operatorStack.isEmpty && operatorStack.last!.priority >= newPriority {
            let op = operatorStack.pop()
            if let twoOperand = op as? TwoOperand {
                if n.count >= 2 {
                    let other = n.popLast()
                    n.last.execute(twoOperand.operation, with: other)
                }
            }
        }
        if newPriority == Operator.closedParenthesesPriority &&
            !operatorStack.isEmpty &&
            operatorStack.last!.priority == Operator.openParenthesesPriority {
            operatorStack.removeLast()
        }
    }
    
    func percentage() {
        if operatorStack.count == 0 {
            n.last.execute(Gmp.mul, with: Number("0.01", precision: precision))
        } else if operatorStack.count >= 1 && n.count >= 2 {
            if let secondLast = n.secondLast {
                n.last.execute(Gmp.mul, with: Number("0.01", precision: precision))
                n.last.execute(Gmp.mul, with: secondLast)
            }
        }
    }
    
    func operation(_ symbol: String) {
        // debugging
        // if symbol != "C" && symbol != "AC" { print("nn \(nn) no \(no)") }
        
        switch symbol {
        case "C":
            if last.isNull {
                operatorStack.removeAll()
                n.removeAll()
                pendingOperator = nil
                n.append(nullNumber)
            } else {
                n.removeLast()
                n.append(nullNumber)
            }
        case "AC":
            operatorStack.removeAll()
            n.removeAll()
            pendingOperator = nil
            n.append(nullNumber)
        case "mc":
            memory = nil
        case "m+":
            n.last.toGmp()
            if memory == nil {
                memory = n.last.copy()
            } else {
                memory!.execute(Gmp.add, with: n.last)
            }
        case "m-":
            if memory == nil {
                memory = n.last.copy()
                memory!.execute(Gmp.changeSign)
            } else {
                memory!.execute(Gmp.sub, with: n.last.copy())
            }
        case "mr":
            if memory != nil {
                if pendingOperator != nil {
                    n.append(memory!)
                    pendingOperator = nil
                } else {
                    n.replaceLast(with: memory!)
                }
            }
        case "( ":
            self.operatorStack.push(self.openParenthesis)
        case " )":
            self.execute(priority: Operator.closedParenthesesPriority)
        case "%":
            self.percentage()
        case ",":
            if pendingOperator != nil {
                n.append(nullNumber)
                pendingOperator = nil
            }
            n.last.appendComma()
        case "0":
            if pendingOperator != nil {
                n.append(nullNumber)
                pendingOperator = nil
            }
            n.last.appendZero()
        case "±":
            n.last.changeSign()
        case "=":
            execute(priority: Operator.equalPriority)
        case C.keysForDigits:
            if pendingOperator != nil {
                n.append(nullNumber)
                pendingOperator = nil
            }
            n.last.appendDigit(symbol)
        case _ where constantOperators.keys.contains(symbol):
            if self.pendingOperator != nil {
                self.n.append(nullNumber)
                self.pendingOperator = nil
            }
            self.n.last.execute(constantOperators[symbol]!.operation)
        case _ where inplaceOperators.keys.contains(symbol):
            n.last.execute(inplaceOperators[symbol]!.operation)
        case _ where twoOperandOperators.keys.contains(symbol):
            pendingOperator = symbol
            execute(priority: twoOperandOperators[symbol]!.priority)
            operatorStack.push(twoOperandOperators[symbol]!)
        default:
            assert(false, "### non-existing operation \(symbol)")
        }
        if n.last.valueHasChanged {
            haveResultCallback()
            n.last.valueHasChanged = false
        }
    }
    
    func setPrecision(_ newPrecision: Int) {
        if newPrecision != precision {
            n.updatePrecision(from: precision, to: newPrecision)
            precision = newPrecision
            haveResultCallback()
        }
    }
    
    init() {
        operation("AC")
        //        operation("π")
        //        operation("8")
        //        operation("8")
        //        operation("8")
        //        operation("8")
        //        operation("8")
        //        operation("8")
        //        operation("8")
        //        operation("8")
        //        operation("8")
        //        operation("x^3")
        //        operation("x^3")
        //        operation("x^3")
        //        operation("x^3")
        //        operation("x^3")
        //        operation("x^3")
        
//        operation("1")
//        operation("2")
//        operation("3")
//        operation("4")
//        operation("5")
//        operation("6")
//        operation("7")
//        operation("8")
//        operation("9")
//        operation("0")
//        operation("1")
//        operation("2")
//        operation("3")
//        operation("4")
//        operation("5")
//        operation("6")
//        operation("7")
//        operation("8")
//        operation("9")
//        operation("0")
//        operation("1")
//        operation("2")
//        operation("3")
//        operation("4")
//        operation("5")
        //        operation("6")
        //        operation("7")
        //        operation("1")
        //        operation("1")
        //        operation("1")
        //        operation("1")
        //        operation("1")
        //        operation("1")
    }
    
    static func internalPrecision(for precision: Int) -> Int {
        // return precision
        if precision <= 500 {
            return 1000
        } else if precision <= 10000 {
            return 2 * precision
        } else if precision <= 100000 {
            return Int(round(1.5*Double(precision)))
        } else {
            return precision + 50000
        }
    }
    static func bits(for precision: Int) -> Int {
        Int(Double(internalPrecision(for: precision)) * 3.32192809489)
    }

}

