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
    var precision: Int = 100
    var bits: Int
    var last: Number { n.last }

    var debugLastAsDouble: Double { n.last.gmp!.toDouble() }
    var debugLastAsGmp: Gmp { n.last.gmp! }
    
    var isValidNumber: Bool { n.last.isValid }

    var haveResultCallback: () -> () = { }
    var pendingOperatorCallback: (String?) -> () = { _ in }
    var isCalculatingCallback: (Bool) -> () = { _ in }
    var pendingOperator: String? {
        willSet {
            if pendingOperator != newValue {
                pendingOperatorCallback(newValue)
            }
        }
    }
    var memory: Gmp? = nil
    var nullNumber: Number {
        return Number("0", bits: bits)
    }
    var isCalculating: Bool = false {
        willSet {
            if isCalculating != newValue {
                isCalculatingCallback(newValue)
            }
        }
    }
    
    private func speedTest(testPrecision: Int) async -> Speed {
        let testBrain = Brain(precision: testPrecision)

        testBrain.nonWaitingOperation("AC")
        testBrain.nonWaitingOperation("Rand")

        let timer = ParkBenchTimer()
        testBrain.nonWaitingOperation("√")
        let seconds = timer.stop()
        // print("The task took \(seconds) seconds. Percision \(precision)")
        return Speed(sqrt2Time: seconds, precision: testPrecision)
    }
    
    
    static func internalPrecision(_ precision: Int) -> Int {
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
    
    func number(_ s: String) -> Number {
        return Number(s, bits: bits)
    }
    func gmpNumber(_ s: String) -> Number {
        return Number(Gmp(s, bits: bits))
    }
    let digitOperators: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
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


    func press(_ digits: String) {
        for digit in digits {
            nonWaitingOperation(String(digit))
        }
    }
    
    func press(_ digit: Int) {
        if digit >= 0 && digit <= 9 {
            nonWaitingOperation(String(digit))
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
            n.last.execute(Gmp.mul, with: number("0.01"))
        } else if operatorStack.count >= 1 && n.count >= 2 {
            if let secondLast = n.secondLast {
                n.last.execute(Gmp.mul, with: number("0.01"))
                n.last.execute(Gmp.mul, with: secondLast)
            }
        }
    }
    
    private func operation(_ symbol: String) {
        /// TODO: do the switch in CalculatorModel
        if symbol == "C" {
            if last.isNull {
                operatorStack.removeAll()
                n.removeAll()
                pendingOperator = nil
                n.append(nullNumber)
            } else {
                n.removeLast()
                n.append(nullNumber)
            }
        } else if symbol == "AC" {
            operatorStack.removeAll()
            n.removeAll()
            pendingOperator = nil
            n.append(nullNumber)
        } else if symbol == "mc" {
            memory = nil
        } else if symbol == "m+" {
            n.last.toGmp()
            if memory == nil {
                memory = n.last.copy().gmp
            } else {
                memory!.execute(Gmp.add, with: n.last.gmp!)
            }
        } else if symbol == "m-" {
            if memory == nil {
                n.last.toGmp()
                let temp = n.last.copy()
                temp.execute(Gmp.changeSign)
                memory = temp.gmp!
            } else {
                memory!.execute(Gmp.sub, with: n.last.copy().gmp!)
            }
        } else if symbol == "mr" {
            if memory != nil {
                if pendingOperator != nil {
                    n.append(Number(memory!.copy()))
                    pendingOperator = nil
                } else {
                    n.replaceLast(with: Number(memory!.copy()))
                }
            }
        } else if symbol == "( " {
            self.operatorStack.push(self.openParenthesis)
        } else if symbol == " )" {
            self.execute(priority: Operator.closedParenthesesPriority)
        } else if symbol == "%" {
            self.percentage()
        } else if symbol == "fromPasteboard" {
//            if let s = UIPasteboard.general.string {
//                if pendingOperator != nil {
//                    n.append(nullNumber)
//                    pendingOperator = nil
//                }
//                n.replaceLast(with: gmpNumber(s))
//            }
        } else if symbol == "," {
            if pendingOperator != nil {
                n.append(nullNumber)
                pendingOperator = nil
            }
            n.last.appendComma()
        } else if symbol == "0" {
            if pendingOperator != nil {
                n.append(nullNumber)
                pendingOperator = nil
            }
            n.last.appendZero()
        } else if symbol == "±" {
            n.last.changeSign()
        } else if symbol == "=" {
            execute(priority: Operator.equalPriority)
        } else if self.digitOperators.contains(symbol) {
            if pendingOperator != nil {
                n.append(nullNumber)
                pendingOperator = nil
            }
            n.last.appendDigit(symbol)
        } else if let op = self.constantOperators[symbol] {
            if self.pendingOperator != nil {
                self.n.append(nullNumber)
                self.pendingOperator = nil
            }
            self.n.last.execute(op.operation)
        } else if let op = self.inplaceOperators[symbol] {
            self.n.last.execute(op.operation)
        } else if let op = self.twoOperandOperators[symbol] {
            if twoOperandOperators.keys.contains(symbol) { self.pendingOperator = symbol }
            self.execute(priority: op.priority)
            self.self.operatorStack.push(op)
        } else {
            //            print("### non-existing operation \(symbol)")
            assert(false)
        }
        haveResultCallback()
    }
    
    private func waitingOperation(_ symbol: String) async {
        operation(symbol)
    }
    
    func nonWaitingOperation(_ symbol: String) {
        if !isCalculating {
            self.isCalculating = true
            operation(symbol)
        }
        self.isCalculating = false
    }
    
    func asyncOperation(_ symbol: String) {
        Task {
            if !isCalculating {
                self.isCalculating = true
                await waitingOperation(symbol)
                
            }
            self.isCalculating = false
        }
    }
    
    func setPrecision(_ newPrecision: Int) {
        self.precision = newPrecision
        self.bits = Int(Double(Brain.internalPrecision(newPrecision)) * 3.32192809489)
        n.changePrecision(to: self.precision, newBits: self.bits)
        speed = nil
        Task {
            let speedResult =  await speedTest(testPrecision: newPrecision)
            DispatchQueue.main.async {
                self.speed = speedResult
            }
        }
    }
    
    init(precision initialPrecision: Int) {
        self.precision = initialPrecision
        self.bits = Int(Double(Brain.internalPrecision(initialPrecision)) * 3.32192809489)
        self.nonWaitingOperation("AC")
    }
    
    struct Speed {
        let sqrt2Time: Double
        let precision: Int
    }
    
    var speed: Speed?

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
