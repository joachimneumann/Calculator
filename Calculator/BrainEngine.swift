//
//  Brain.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

import Foundation


class BrainEngine {
    fileprivate var n = NumberStack()
    fileprivate var operatorStack = OperatorStack()
    private (set) var precision: Int = 0
    private var anOperationIsPending: Bool
    private var memory: Number? = nil
    private var nullNumber: Number { Number("0", precision: precision) }
    private let constantOperators: Dictionary <String, Inplace> = [
        "π":    Inplace(Gmp.π, 0),
        "e":    Inplace(Gmp.e, 0),
        "Rand": Inplace(Gmp.rand, 0)
    ]
    private let inplaceOperators: Dictionary <String, Inplace> = [
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
    private let twoOperandOperators: Dictionary <String, TwoOperand> = [
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
    private let openParenthesis = Operator(Operator.openParenthesesPriority)
    private let closedParenthesis = Operator(Operator.openParenthesesPriority)
    private let equalOperator = Operator(Operator.equalPriority)
    
    private func setMemory(_ memory: Number?) {
        self.memory = memory
    }
    private func percentage() {
        if operatorStack.count == 0 {
            n.last.execute(Gmp.mul, with: Number("0.01", precision: precision))
        } else if operatorStack.count >= 1 && n.count >= 2 {
            if let secondLast = n.secondLast {
                n.last.execute(Gmp.mul, with: Number("0.01", precision: precision))
                n.last.execute(Gmp.mul, with: secondLast)
            }
        }
    }
    
    private func execute(priority newPriority: Int) {
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

    /// used in the model for mr and paste
    func replaceLast(with number: Number) {
        n.replaceLast(with: number)
    }
    
    func operation(_ symbol: String) -> CalculationResult {
        // debugging
        // if symbol != "C" && symbol != "AC" { print("nn \(nn) no \(no)") }
        
        switch symbol {
        case "C":
            if n.last.isNull {
                operatorStack.removeAll()
                n.removeAll()
                anOperationIsPending = false
                n.append(nullNumber)
            } else {
                n.removeLast()
                n.append(nullNumber)
            }
        case "AC":
            operatorStack.removeAll()
            n.removeAll()
            anOperationIsPending = false
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
                if anOperationIsPending {
                    n.append(memory!)
                    anOperationIsPending = false
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
            if anOperationIsPending {
                n.append(nullNumber)
                anOperationIsPending = false
            }
            n.last.appendComma()
        case "0":
            if anOperationIsPending {
                n.append(nullNumber)
                anOperationIsPending = false
            }
            n.last.appendZero()
        case "±":
            n.last.changeSign()
        case "=":
            execute(priority: Operator.equalPriority)
        case C.keysForDigits:
            if anOperationIsPending {
                n.append(nullNumber)
                anOperationIsPending = false
            }
            n.last.appendDigit(symbol)
        case _ where constantOperators.keys.contains(symbol):
            if anOperationIsPending {
                self.n.append(nullNumber)
                anOperationIsPending = false
            }
            self.n.last.execute(constantOperators[symbol]!.operation)
        case _ where inplaceOperators.keys.contains(symbol):
            n.last.execute(inplaceOperators[symbol]!.operation)
        case _ where twoOperandOperators.keys.contains(symbol):
            anOperationIsPending = true
            execute(priority: twoOperandOperators[symbol]!.priority)
            operatorStack.push(twoOperandOperators[symbol]!)
        default:
            assert(false, "### non-existing operation \(symbol)")
        }
        let hasChanged = n.last.valueHasChanged
        n.last.valueHasChanged = false
        return CalculationResult(number: n.last, hasChanged: hasChanged)
    }
    
    /// used on Settings
    func setPrecision(_ newPrecision: Int) -> CalculationResult {
        if newPrecision != precision {
            n.updatePrecision(from: precision, to: newPrecision)
            precision = newPrecision
        }
        return CalculationResult(number: n.last, hasChanged: true)
    }
    
    init(precision: Int) {
        self.precision = precision
        operatorStack.removeAll()
        n.removeAll()
        anOperationIsPending = false
        n.append(Number("0", precision: precision))
        // fullDisplay()
    }
    
    func fullDisplay() {
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
}

// DebugBrain implemented in the same file, because BrainEngine has fileprivate properties
class DebugBrain: BrainEngine {
    let lengths: Lengths
    init(precision: Int, lengths: Lengths) {
        self.lengths = lengths
        super.init(precision: precision)
    }

    func push(_ numberOrOperator: String) {
        if C.keysAll.contains(numberOrOperator) {
            _ = operation(numberOrOperator)
        } else {
            var isNegative = false
            for digit in numberOrOperator {
                if let intValue = digit.wholeNumberValue {
                    if intValue >= 0 && intValue <= 9 {
                        let _  = operation(String(digit))
                    }
                } else if digit == "." || digit == "," {
                    let _  = operation(",")
                } else if digit == "-" {
                    isNegative = true
                } else {
                    assert(false)
                }
            }
            if isNegative {
                let _  = operation("±")
            }
        }
    }
    func push(_ integer: Int) { push(String(integer)) }
    func push(_ double: Double) { push(String(double)) }
    func pushnew(_ something: String) {
        push("AC")
        push(something)
    }
    func pushnew(_ integer: Int) {
        push("AC")
        push(integer)
    }
    func pushnew(_ double: Double) {
        push("AC")
        push(double)
    }

    var no: Int { operatorStack.count }
    var nn: Int { n.count }
    var data: DisplayData {
        let d = n.last.getDisplayData(multipleLines: false, lengths: lengths, forceScientific: false, showAsInteger: false, showAsFloat: false)
        return d
    }
    var left: String { data.left }
    var right: String? { data.right }
    var oneLine: String { data.left + (data.right ?? "") }
    var double: Double { n.last.gmp != nil ? n.last.gmp!.toDouble() : -1.0 }
}
