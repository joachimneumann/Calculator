//
//  Brain.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

import Foundation
import SwiftUI

class Brain: ObservableObject {
    @Published var zoomed: Bool = false
    @Published var calibrated: Bool = false
    @Published var digitsInDisplayInteger: Int = 1000000
    @Published var digitsInDisplayFloat: Int = 1000000
    @Published var digitsInDisplayScientific: Int = 1000000
    private var n = NumberStack()
    private var operatorStack = OperatorStack()
    var calculating: Bool = false
    var showCalculating: Bool = false
    var secondKeys: Bool = false
    var rad: Bool = false
    var debugLastDouble: Double { n.debugLastDouble }
    var debugLastGmp: Gmp { n.debugLastGmp }
    
    var nonScientific:          String?     { n.nonScientific }
    var nonScientificIsInteger: Bool        { n.nonScientificIsInteger }
    var nonScientificIsFloat:   Bool        { n.nonScientificIsFloat }
    var scientific:             Scientific? { n.scientific }

    var displayAsString: Bool {
        if n.nonScientific != nil && n.nonScientificIsInteger == false && n.nonScientificIsFloat == false {
            return true
        } else {
            return false
        }
    }

    var displayAsInteger: Bool {
        if let nonScientific = nonScientific {
            if nonScientific.contains(" ") { return false }
            if nonScientific.contains("e") { return false }
            if nonScientific.contains(",")  { return false }
            if n.nonScientificIsInteger == false { return false }
            if n.nonScientific!.count > digitsInDisplayInteger { return false }
        } else {
            return false
        }
        return true
    }

    var displayAsFloat: Bool {
        if let nonScientific = nonScientific {
            if nonScientific.contains(" ") { return false }
            if nonScientific.contains("e") { return false }
            if n.nonScientificIsFloat == false { return false }

            if let firstIndex = nonScientific.firstIndex(of: ",") {
                let index: Int = nonScientific.distance(from: nonScientific.startIndex, to: firstIndex)

                // comma at the very end of the display or not even in the first line?
                if index > digitsInDisplayInteger - 2 { return false }

                // 0,0000... ?
                let range = NSRange(location: 0, length: nonScientific.utf16.count)
                let regex = try! NSRegularExpression(pattern: "[1-9]")
                let firstNonZeroDigitIndex = regex.firstMatch(in: nonScientific, options: [], range: range)
                if let firstNonZeroDigitIndex = firstNonZeroDigitIndex {
                    // [1-9] found
                    let position = firstNonZeroDigitIndex.range.lowerBound
                    if position > digitsInDisplayInteger - 2 { return false }
                } else {
                    return false
                }
            } else {
                // no comma found
                return false
            }
        } else {
            return false
        }
        return true
    }

    //    func sString(_ digits: Int) -> String { n.sString(digits) }
    //func sString(_ digits: Int) -> String { "6.734" }
    var isValidNumber: Bool { n.isValidNumber }
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
        n.lastDigit(digit)
        objectWillChange.send()
    }
    
    var notCalculating: Bool { calculating == false }
    var digitsAllowed: Bool { notCalculating }
    func zero() {
        if pendingOperator != nil {
            n.append(Gmp())
            pendingOperator = nil
        }
        n.lastZero()
        objectWillChange.send()
    }
    func comma() {
        if pendingOperator != nil {
            n.append(Gmp())
            pendingOperator = nil
        }
        n.lastComma()
        objectWillChange.send()
    }
    
    func execute(priority newPriority: Int) {
        while !operatorStack.isEmpty && operatorStack.last!.priority >= newPriority {
            let op = operatorStack.pop()
            if let twoOperand = op as? TwoOperand {
                if n.count >= 2 {
                    let temp = n.popLast()!
                    temp.convertToGmp()
                    let gmp2 = temp.gmp
                    n.lastExecute(twoOperand.operation, with: gmp2)
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
            n.lastExecute(Gmp.mul, with: Gmp("0.01"))
        } else if operatorStack.count >= 1 && n.count >= 2 {
            if let secondLast = n.secondLast {
                n.lastExecute(Gmp.mul, with: Gmp("0.01"))
                secondLast.convertToGmp()
                n.lastExecute(Gmp.mul, with: secondLast.gmp)
            }
        }
    }
    
    func operationWorker(_ symbol: String, withPending: Bool = true) {
        if symbol == "=" {
            self.execute(priority: Operator.equalPriority)
        } else if symbol == "(" {
            self.operatorStack.push(self.openParenthesis)
        } else if symbol == ")" {
            self.execute(priority: Operator.closedParenthesesPriority)
        } else if symbol == "%" {
            self.percentage()
        } else if let op = self.constantOperators[symbol] {
            if self.pendingOperator != nil {
                self.n.append(Gmp())
                self.pendingOperator = nil
            }
            self.n.modifyLast(withOp: op.operation)
        } else if let op = self.inplaceOperators[symbol] {
            self.n.modifyLast(withOp: op.operation)
        } else if let op = self.twoOperandOperators[symbol] {
            if withPending { self.pendingOperator = symbol }
            self.execute(priority: op.priority)
            self.self.operatorStack.push(op)
        } else {
            print("### non-existing operation \(symbol)")
            assert(false)
        }
//        print("X after op   (\"\(symbol)\": " +
//              "numbers: \(n.count), " +
//              "ops: \(operatorStack.count), " +
//              "display: \(display)")
    }
    
    // TODO: make this work in the app: 9 % % % % x^2 x^2 x^2
    // it works in test, using the worker
    func operation(_ symbol: String, withPending: Bool = true) {
        self.operationWorker(symbol, withPending: withPending)
        self.objectWillChange.send()
        // TODO assert that this works for make this work in the app: 9 % % % % x^2 x^2 x^2 x^2
        // TODO use iOS 15 async
    }
    
    func reset() {
        operatorStack.removeAll()
        n.removeAll()
        pendingOperator = nil
        n.append(Gmp())
        self.objectWillChange.send()
    }
    func clearMemory() {
        memory = nil
        objectWillChange.send()
    }
    func addToMemory() {
        if memory == nil {
            memory = n.lastConvertIntoGmp.copy()
        } else {
            memory!.add(other: n.lastConvertIntoGmp)
        }
        objectWillChange.send()
    }
    func subtractFromMemory() {
        if memory == nil {
            memory = n.lastConvertIntoGmp.copy()
            memory!.changeSign()
        } else {
            memory!.sub(other: n.lastConvertIntoGmp)
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

    var nn: Int { n.count }
    var no: Int { operatorStack.count }
//    var last: Number { n.last() }

    init() {
        constantOperators = [
            "π":    Inplace(Gmp.π, 0),
            "e":    Inplace(Gmp.e, 0),
            "rand": Inplace(Gmp.rand, 0)
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
            "+/-":    Inplace(Gmp.changeSign, 1),
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
            "sinhD":  Inplace(Gmp.sinhD, 1),
            "coshD":  Inplace(Gmp.coshD, 1),
            "tanhD":  Inplace(Gmp.tanhD, 1),
            "asinhD": Inplace(Gmp.asinhD, 1),
            "acoshD": Inplace(Gmp.acoshD, 1),
            "atanhD": Inplace(Gmp.atanhD, 1),
            "2^x":    Inplace(Gmp.pow_2_x, 1),
            "x^3":    Inplace(Gmp.pow_x_3, 1),
            "e^x":    Inplace(Gmp.pow_e_x, 1),
            "10^x":   Inplace(Gmp.pow_10_x, 1)
        ]
        openParenthesis   = Operator(Operator.openParenthesesPriority)
        closedParenthesis = Operator(Operator.openParenthesesPriority)
        equalOperator     = Operator(Operator.equalPriority)
        reset()
    }
    
    func fromPasteboard() {
        if let s = UIPasteboard.general.string {
            let gmp = Gmp(s)
            if pendingOperator != nil {
                n.append(gmp)
                pendingOperator = nil
            }
            n.replaceLast(with: Number(gmp))
            objectWillChange.send()
        }
    }
    
}
