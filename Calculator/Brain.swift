//
//  Brain.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

import Foundation
import SwiftUI

class Brain: ObservableObject {
    @Published var scrollViewTarget: Int? = nil
    var messageToUser: String? = nil
    private var n = NumberStack()
    private var operatorStack = OperatorStack()
    @Published var precision: Int = 100
    @Published var bits: Int

//    @Published var speedTestResult: Double?
//    {
//        didSet {
//            DispatchQueue.main.async {
//                self.speedTestResult = nil
//            }
//            Task {
//                let res = await speedTest()
//                DispatchQueue.main.async {
//                    self.speedTestResult = res * 1000
//                }
//            }
//        }
//    }
    
    func speedTest(testPrecision: Int) async -> Speed {
        let testBrain = Brain(precision: testPrecision)

        testBrain.nonWaitingOperation("C")
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
    
    @Published var secondKeys: Bool = false
    @Published var rad: Bool = false
    @Published var showCalculating: Bool = false
    var isCalculating: Bool = false
    
    var debugLastDouble: Double { n.last.gmp!.toDouble() }
    var debugLastGmp: Gmp { n.last.gmp! }
    
    var nonScientificAllDigits: String {
        "not implemented"
    }
    
    var isValidNumber: Bool { n.last.isValid }
    var pendingOperator: String?
    var memory: Gmp? = nil
    var nullNumber: Number {
        return Number("0", bits: bits)
    }
    func number(_ s: String) -> Number {
        return Number(s, bits: bits)
    }
    func gmpNumber(_ s: String) -> Number {
        return Number(Gmp(s, bits: bits))
    }
    var digitOperators: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var zeroOperators:       Dictionary <String, Inplace> = [:]
    var commaOperators:      Dictionary <String, Inplace> = [:]
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
        if symbol == "=" {
            self.execute(priority: Operator.equalPriority)
        } else if symbol == "C" {
            operatorStack.removeAll()
            n.removeAll()
            pendingOperator = nil
            n.append(nullNumber)
        } else if symbol == "2nd" {
            DispatchQueue.main.async {
                self.secondKeys.toggle()
            }
        } else if symbol == "Rad" || symbol == "Deg" {
            DispatchQueue.main.async {
                self.rad.toggle()
            }
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
            if let s = UIPasteboard.general.string {
                if pendingOperator != nil {
                    n.append(nullNumber)
                    pendingOperator = nil
                }
                n.replaceLast(with: gmpNumber(s))
            }
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
        } else if symbol == "+/-" {
            n.last.changeSign()
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
    }
    
    private func waitingOperation(_ symbol: String) async {
        operation(symbol)
    }
    
    func nonWaitingOperation(_ symbol: String) {
        if symbol == "messageToUser" {
            operation("C")
            //            self.nonScientific = messageToUser
            //            self.scientific = nil
            messageToUser = nil
        } else {
            operation(symbol)
        }
    }
    
    func asyncOperation(_ symbol: String) {
        Task {
            if !isCalculating {
                DispatchQueue.main.async {
                    self.isCalculating = true
                }
                let now = DispatchTime.now()
                var whenWhen: DispatchTime
                whenWhen = now + DispatchTimeInterval.milliseconds(Int(200.0))
                DispatchQueue.main.asyncAfter(deadline: whenWhen) {
                    if self.isCalculating { // still calculating?
                        self.showCalculating = true
                        //print("asyncOperation showCalculating \(self.showCalculating)")
                    }
                }
                
                await waitingOperation(symbol)
                
            }
            //print("display1... \(showCalculating)")
            DispatchQueue.main.async {
                //                self.nonScientific = self.displayData.nonScientific
                //                self.scientific = self.displayData.scientific
                self.showCalculating = false
                //print("asyncOperation showCalculating \(self.showCalculating)")
                self.isCalculating = false
            }
        }
    }
    
    var last: Number { n.last }
    var nn: Int { n.count }
    var no: Int { operatorStack.count }
    //    var last: Number { n.last() }
    
    struct Speed {
        let sqrt2Time: Double
        let precision: Int
    }
    
    @Published var speed: Speed?
    
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

        self.nonWaitingOperation("C")
        
        constantOperators = [
            "π":    Inplace(Gmp.π, 0),
            "e":    Inplace(Gmp.e, 0),
            "Rand": Inplace(Gmp.rand, 0)
        ]
        twoOperandOperators = [
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
        inplaceOperators = [
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
        openParenthesis   = Operator(Operator.openParenthesesPriority)
        closedParenthesis = Operator(Operator.openParenthesesPriority)
        equalOperator     = Operator(Operator.equalPriority)
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
