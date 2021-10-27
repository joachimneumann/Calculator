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
    
    @AppStorage("precision") var precision: Int = TE.lowPrecision {
        didSet {
            calculateSignificantBits()
            Gmp.deleteConstants()
            operation("C")
        }
    }
    var precisionIconName: String {
        switch precision {
        case TE.lowPrecision:
            return "h.circle.fill"
        case TE.mediumPrecision:
            return "t.circle.fill"
        case TE.highPrecision:
            return "m.circle.fill"
        default:
            return "questionmark.circle.fill"
        }
    }
    var precisionMessage: String {
        switch precision {
        case TE.lowPrecision:
            return TE.lowPrecisionString
        case TE.mediumPrecision:
            return TE.mediumPrecisionString
        case TE.highPrecision:
            return TE.highPrecisionString
        default:
            return "unknown precision"
        }
    }
    
    @Published var zoomed: Bool = false
    @Published var calibrated: Bool = false
    @Published var secondKeys: Bool = false
    @Published var rad: Bool = false
    @Published var calculating: Bool = false    
    
//    var debugLastDouble: Double { n.debugLastDouble }
//    var debugLastGmp: Gmp { n.debugLastGmp }
    
    @Published var displayData: DisplayData = DisplayData()
    var nonScientificAllDigits: String {
        "not implemented"
    }
    
    var isValidNumber: Bool { true } //n.isValidNumber }
    var pendingOperator: String?
    var memory: Number? = nil
    
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
            operation(String(digit))
        }
    }

    func press(_ digit: Int) {
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
            n.last.execute(Gmp.mul, with: Number("0.01"))
        } else if operatorStack.count >= 1 && n.count >= 2 {
            if let secondLast = n.secondLast {
                n.last.execute(Gmp.mul, with: Number("0.01"))
                n.last.execute(Gmp.mul, with: secondLast)
            }
        }
    }
    
    func operation(_ symbol: String, withPending: Bool = true) {
        if symbol == "=" {
            self.execute(priority: Operator.equalPriority)
        } else if symbol == "C" {
            calculateSignificantBits()
            operatorStack.removeAll()
            n.removeAll()
            pendingOperator = nil
            n.append(Number("0"))
        } else if symbol == "mc" {
            memory = nil
        } else if symbol == "m+" {
            if memory == nil {
                memory = n.last.copy()
            } else {
                memory!.execute(Gmp.add, with: n.last)
            }
        } else if symbol == "m-" {
            if memory == nil {
                memory = n.last.copy()
                memory!.execute(Gmp.changeSign)
            } else {
                memory!.execute(Gmp.sub, with: n.last)
            }
        } else if symbol == "mr" {
            if memory != nil {
                if pendingOperator != nil {
                    n.append(memory!)
                    pendingOperator = nil
                } else {
                    n.replaceLast(with: memory!)
                }
                memory = nil
            }
        } else if symbol == "(" {
            self.operatorStack.push(self.openParenthesis)
        } else if symbol == ")" {
            self.execute(priority: Operator.closedParenthesesPriority)
        } else if symbol == "%" {
            self.percentage()
        } else if symbol == "fromPasteboard" {
            if let s = UIPasteboard.general.string {
                let gmp = Gmp(s)
                if pendingOperator != nil {
                    n.append(Number(Gmp()))
                    pendingOperator = nil
                }
                n.replaceLast(with: Number(gmp))
            }
        } else if symbol == "," {
            if pendingOperator != nil {
                n.append(Number("0"))
                pendingOperator = nil
            }
            n.last.addComma()
        } else if symbol == "0" {
            if pendingOperator != nil {
                n.append(Number("0"))
                pendingOperator = nil
            }
            n.last.addZero()
        } else if symbol == "+/-" {
            n.last.changeSign()
        } else if self.digitOperators.contains(symbol) {
            if pendingOperator != nil {
                n.append(Number("0"))
                pendingOperator = nil
            }
            n.last.addDigit(symbol)
        } else if let op = self.constantOperators[symbol] {
            if self.pendingOperator != nil {
                self.n.append(Number(Gmp()))
                self.pendingOperator = nil
            }
            self.n.last.execute(op.operation)
        } else if let op = self.inplaceOperators[symbol] {
            self.n.last.execute(op.operation)
        } else if let op = self.twoOperandOperators[symbol] {
            if withPending { self.pendingOperator = symbol }
            self.execute(priority: op.priority)
            self.self.operatorStack.push(op)
        } else {
//            print("### non-existing operation \(symbol)")
            assert(false)
        }
    }
    
    func waitingOperation(_ symbol: String, withPending: Bool = true) async {
        operation(symbol, withPending: withPending)
    }
    
    func asyncOperation(_ symbol: String, withPending: Bool = true) {
        Task {
            print("calc... \(calculating)")
            await waitingOperation(symbol, withPending: withPending)
            print("display1... \(calculating)")
            var dd = DisplayData()
            let x = await dd.calc(n.last)
            DispatchQueue.main.async {
                self.displayData = x
            }
        }
    }

    var nn: Int { n.count }
    var no: Int { operatorStack.count }
    //    var last: Number { n.last() }
    
    private func calculateSignificantBits() {
        var significantBits: Int
        if (precision < TE.mediumPrecision) {
            /// let's be generous
            significantBits = 10 * precision
        } else {
            significantBits = Int( Double(precision) * 3.3219 + 1000) /// 1.0 / log2(10) plus 1000 digits
        }
        globalGmpSignificantBits = significantBits
        globalGmpPrecision = precision
    }
    
    init() {
                
        operation("C")
        
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
    
}
