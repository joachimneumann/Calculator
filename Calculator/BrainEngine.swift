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
    private(set) var precision: Int = 0
    private var pending: Bool
    fileprivate var memory: Number? = nil
    private var nullNumber: Number { number("0") }
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
            n.last.execute(Gmp.mul, with: number("0.01"))
        } else if operatorStack.count >= 1 && n.count >= 2 {
            if let secondLast = n.secondLast {
                n.last.execute(Gmp.mul, with: number("0.01"))
                n.last.execute(Gmp.mul, with: secondLast)
            }
        }
    }
    
    private func execute(priority newPriority: Int) {
        while !operatorStack.isEmpty && operatorStack.last!.priority >= newPriority {
            let op = operatorStack.pop()
            if let twoOperand = op as? TwoOperand {
                
                var oddRootOfNegativeNumber = false
                if twoOperand == twoOperandOperators["y√"] {
                    if let radicand = n.secondLast { /// this is the number under the root
                        if radicand.isNegative {
                            if let radicalAsString = n.last.str { /// the radical is describes which nth root shall be calculated
                                if let radicalAsInt = Int(radicalAsString) {
                                    if radicalAsInt % 2 != 0 {
                                        // we have an odd radical
                                        let radical = n.popLast()
                                        n.last.changeSign()
                                        n.last.execute(twoOperand.operation, with: radical)
                                        n.last.changeSign()
                                        oddRootOfNegativeNumber = true
                                    }
                                }
                            }
                        }
                    }
                }
                if !oddRootOfNegativeNumber {
                    if n.count >= 2 {
                        let other = n.popLast()
                        n.last.execute(twoOperand.operation, with: other)
                    } else {
                        /// this can happen when the users changes the operand
                    }
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
        if pending {
            n.append(number)
            pending = false
        } else {
            n.replaceLast(with: number)
        }
    }
    
    /// central function, used in the model
    func operation(_ symbol: String) -> Number {
        // debugging
        // if symbol != "C" && symbol != "AC" { print("nn \(nn) no \(no)") }
        
        switch symbol {
        case "C":
            n.removeLast()
            n.append(nullNumber)
        case "AC":
            operatorStack.removeAll()
            n.removeAll()
            pending = false
            n.append(nullNumber)
        case "mc":
            memory = nil
        case "m+":
            n.last.toGmp()
            guard let memory = memory else {
                memory = Number(n.last.gmp!)
                break
            }
            memory.execute(Gmp.add, with: n.last)
        case "m-":
            n.last.toGmp()
            guard let memory = memory else {
                memory = Number(n.last.gmp!)
                memory!.execute(Gmp.changeSign)
                break
            }
            memory.execute(Gmp.sub, with: n.last)
        case "mr":
            guard let memory = memory else { break }
            replaceLast(with: Number(memory.gmp!))
        case "( ":
            self.operatorStack.push(self.openParenthesis)
        case " )":
            self.execute(priority: Operator.closedParenthesesPriority)
        case "%":
            self.percentage()
        case ",", ".":
            if pending {
                n.append(nullNumber)
                pending = false
            }
            n.last.appendDot()
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            if pending {
                n.append(nullNumber)
                pending = false
            }
            n.last.append(symbol)
        case "±":
            n.last.changeSign()
        case "=":
            execute(priority: Operator.equalPriority)
        case _ where constantOperators.keys.contains(symbol):
            if pending {
                self.n.append(nullNumber)
                pending = false
            }
            self.n.last.execute(constantOperators[symbol]!.operation)
        case _ where inplaceOperators.keys.contains(symbol):
            n.last.execute(inplaceOperators[symbol]!.operation)
        case _ where twoOperandOperators.keys.contains(symbol):
            pending = true
            execute(priority: twoOperandOperators[symbol]!.priority)
            operatorStack.push(twoOperandOperators[symbol]!)
        default:
            assert(false, "### BrainEngine: Operation \(symbol) is not defined")
        }
        return n.last
    }
    
    func number(_ numberString: String) -> Number { Number(numberString, precision: precision) }

    /// used on Settings
    func setPrecision(_ newPrecision: Int) -> Number {
        if newPrecision != precision {
            n.updatePrecision(from: precision, to: newPrecision)
            precision = newPrecision
        }
        return n.last
    }
    
    init(precision: Int) {
        self.precision = precision
        operatorStack.removeAll()
        n.removeAll()
        pending = false
        n.append(number("0"))
        //        operation("π")
        //        operation("8")
    }
    
}

/// DebugBrain is located in the same file, because it uses
/// fileprivate properties of BrainEngine
class DebugBrain: BrainEngine {

    func push(_ numberOrOperator: String) {
        let allOperators = [
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", ",",
            "C", "AC", "±", "%", "/", "x", "-", "+", "=",
            "( ", " )", "mc", "m+", "m-", "mr",
            "2nd", "x^2", "x^3", "x^y", "e^x", "y^x", "2^x", "10^x",
            "One_x", "√", "3√", "y√", "logy", "ln", "log2", "log10",
            "x!", "sin", "cos", "tan", "sinD", "cosD", "tanD",
            "asin", "acos", "atan", "asinD", "acosD", "atanD",
            "e", "EE",
            "Deg", "Rad", "sinh", "cosh", "tanh", "asinh", "acosh", "atanh", "π", "Rand"]
        if allOperators.contains(numberOrOperator) {
            _ = operation(numberOrOperator)
        } else {
            var isNegative = false
            for digit in numberOrOperator {
                if let intValue = digit.wholeNumberValue {
                    if intValue >= 0 && intValue <= 9 {
                        let _  = operation(String(digit))
                    }
                } else if digit == "," || digit == "." {
                    let _  = operation(".")
                } else if digit == "-" {
                    isNegative = true
                } else {
                    assert(false, "strange digit \(digit)")
                }
            }
            if isNegative {
                let _  = operation("±")
            }
        }
    }
    func push(_ integer: Int)   { push(String(integer)) }
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
    var last: Number { n.last }
    var double: Double {
        if n.last.isStr {
            n.last.toGmp()
        }
        return n.last.gmp!.toDouble()
    }

    var memoryDouble: Double {
        guard let memory = memory else { return 0.0 }
        if memory.isStr {
            memory.toGmp()
        }
        return memory.gmp!.toDouble()
    }

    func speedTestSinSqrt2() async -> String {
        let parkBenchTimer = ParkBenchTimer()
        push("2")
        push("√")
        push("sin")
        let duration = parkBenchTimer.stop()
        return duration.asTime
    }
    
    class ParkBenchTimer {
        let startTime: CFAbsoluteTime
        var endTime: CFAbsoluteTime?
    
        init() {
            startTime = CFAbsoluteTimeGetCurrent()
        }
    
        func stop() -> Double {
            endTime = CFAbsoluteTimeGetCurrent()
            return duration!
        }
        var duration: CFAbsoluteTime? {
            if let endTime = endTime {
                return endTime - startTime
            } else {
                return nil
            }
        }
    }
}
