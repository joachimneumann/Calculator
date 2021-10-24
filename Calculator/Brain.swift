//
//  Brain.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

import Foundation
import SwiftUI

class Brain: ObservableObject {
    @Published var globalScrollViewTarget: Int? = nil
    var messageToUser: String? = nil
    private var n = NumberStack()
    private var operatorStack = OperatorStack()
    
    @AppStorage("precision") var persistantPrecision: Int = TE.lowPrecision
    
    @Published var precision: Int = TE.lowPrecision {
        didSet {
            persistantPrecision = precision
            var significantBits: Int
            if (precision < TE.maxScrollViewLength) {
                /// let's be generous
                significantBits = 10 * precision
            } else {
                significantBits = Int( Double(precision) * 3.3219 + 1000) /// 1.0 / log2(10) plus 1000 digits
            }
            globalGmpSignificantBits = significantBits
            globalGmpPrecision = precision
            Gmp.deleteConstants()
            reset()
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
    
    var digitsInDisplayInteger: Int    = 2*TE.highPrecision
    var digitsInDisplayFloat: Int      = 2*TE.highPrecision
    var digitsInDisplayScientific: Int = 2*TE.highPrecision
    
    
    var debugLastDouble: Double { n.debugLastDouble }
    var debugLastGmp: Gmp { n.debugLastGmp }
    
    var nonScientific: String? = nil
    var scientific: Scientific? = nil
    
    var isValidNumber: Bool { n.isValidNumber }
    var pendingOperator: String?
    var memory: Gmp? = nil
    
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
        if newPriority == Operator.closedParenthesesPriority &&
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
        } else if symbol == "," {
            if pendingOperator != nil {
                n.append(Gmp())
                pendingOperator = nil
            }
            n.lastComma()
        } else if symbol == "0" {
            if pendingOperator != nil {
                n.append(Gmp())
                pendingOperator = nil
            }
            n.lastZero()
        } else if self.digitOperators.contains(symbol) {
            if pendingOperator != nil {
                n.append(Gmp())
                pendingOperator = nil
            }
            n.lastDigit(symbol)
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
//            print("### non-existing operation \(symbol)")
            assert(false)
        }
    }
    
    func asyncOperationWorker(_ symbol: String, withPending: Bool = true) async {
        self.operationWorker(symbol, withPending: withPending)
    }
    
    func determineDisplay() async {
//        print("XXXXX display2... \(calculating)")
        
        var showNonScientific: Bool = false
        var doneChecking = false
        if messageToUser != nil {
            let temp = messageToUser!
            messageToUser = nil
            nonScientific = temp
            showNonScientific = true
            doneChecking = true
        } else {
            if let ns = n.nonScientific {
                /// before we go, we need to check if nonScientific
                /// can be displayed in one line
                
                /// Is it a str?
                if !doneChecking && n.nonScientificIsString && ns.count < digitsInDisplayInteger {
                    showNonScientific = true
                    doneChecking = true
                }
                
                /// is it an Integer?
                if !doneChecking && n.nonScientificIsInteger && ns.count < digitsInDisplayInteger {
                    showNonScientific = true
                    doneChecking = true
                }
                
                /// is it a float?
                if !doneChecking && n.nonScientificIsFloat {
                    if let firstIndex = ns.firstIndex(of: ",") {
                        let index: Int = ns.distance(from: ns.startIndex, to: firstIndex)
                        
                        /// comma at the very end of the display or not even in the first line?
                        if index > digitsInDisplayInteger - 2 {
                            showNonScientific = false
                            doneChecking = true
                        } else {
                            /// 0,0000... ?
                            let range = NSRange(location: 0, length: ns.utf16.count)
                            let regex = try! NSRegularExpression(pattern: "[1-9]")
                            let firstNonZeroDigitIndex = regex.firstMatch(in: ns, options: [], range: range)
                            if let firstNonZeroDigitIndex = firstNonZeroDigitIndex {
                                // [1-9] found
                                let position = firstNonZeroDigitIndex.range.lowerBound
                                if position > digitsInDisplayInteger - 2 {
                                    showNonScientific = false
                                    doneChecking = true
                                }
                            }
                        }
                    } else {
                        showNonScientific = false
                        doneChecking = true
                    }
                    
                    if !doneChecking {
                        /// seems to be a float :)
                        showNonScientific = true
                        doneChecking = true
                    }
                }
                
                if !doneChecking {
                    /// Not a str, integer or float
                    showNonScientific = false
                    doneChecking = true
                }
            } else {
                /// n.nonScientific is nil
                showNonScientific = false
                doneChecking = true
            }
        }
        
        if showNonScientific {
            nonScientific = n.nonScientific
            scientific = nil
        } else {
            scientific = n.scientific
            nonScientific = nil
        }
        DispatchQueue.main.async {
//            print("done1... \(self.calculating)")
            self.calculating = false
//            print("done2... \(self.calculating)")
        }
    }
    
    func operation(_ symbol: String, withPending: Bool = true) {
        calculating = true
        Task {
            await Task.sleep(UInt64(0.01 * Double(NSEC_PER_SEC)))
//            print("calc... \(calculating)")
            await asyncOperationWorker(symbol, withPending: withPending)
//            print("display1... \(calculating)")
            await determineDisplay()
        }
    }
    
    func reset() {
        calculating = true
//        print("reset... \(calculating)")
        Task {
            operatorStack.removeAll()
            n.removeAll()
            pendingOperator = nil
            n.append(Gmp())
            await determineDisplay()
        }
    }
    func clearMemory() {
        calculating = true
//        print("clearMemory... \(calculating)")
        Task {
            memory = nil
            await determineDisplay()
        }
    }
    func addToMemory() {
        calculating = true
//        print("addToMemory... \(calculating)")
        Task {
            if memory == nil {
                memory = n.lastConvertIntoGmp.copy()
            } else {
                memory!.add(other: n.lastConvertIntoGmp)
            }
            await determineDisplay()
        }
    }
    func subtractFromMemory() {
        calculating = true
//        print("subtractFromMemory... \(calculating)")
        Task {
            if memory == nil {
                memory = n.lastConvertIntoGmp.copy()
                memory!.changeSign()
            } else {
                memory!.sub(other: n.lastConvertIntoGmp)
            }
            await determineDisplay()
        }
    }
    func getMemory() {
        if memory != nil {
            calculating = true
//            print("getMemory... \(calculating)")
            Task {
                let temp = memory!.copy()
                let num = Number(temp)
                
                if pendingOperator != nil {
                    n.append(num)
                    pendingOperator = nil
                } else {
                    n.replaceLast(with: num)
                }
                await determineDisplay()
            }
        }
    }
    
    var nn: Int { n.count }
    var no: Int { operatorStack.count }
    //    var last: Number { n.last() }
    
    init() {
        precision = persistantPrecision // this triggers brain.reset()
        
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
            "2^x":    Inplace(Gmp.pow_2_x, 1),
            "x^3":    Inplace(Gmp.pow_x_3, 1),
            "e^x":    Inplace(Gmp.pow_e_x, 1),
            "10^x":   Inplace(Gmp.pow_10_x, 1)
        ]
        openParenthesis   = Operator(Operator.openParenthesesPriority)
        closedParenthesis = Operator(Operator.openParenthesesPriority)
        equalOperator     = Operator(Operator.equalPriority)
    }
    
    func fromPasteboard() {
        if let s = UIPasteboard.general.string {
            calculating = true
            Task {
                let gmp = Gmp(s)
                if pendingOperator != nil {
                    n.append(gmp)
                    pendingOperator = nil
                }
                n.replaceLast(with: Number(gmp))
                await determineDisplay()
            }
        }
    }
    
}
