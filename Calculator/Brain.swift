//
//  Brain.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

import Foundation

class Brain {
    var n = NumberStack()
    private var operatorStack = OperatorStack()
    private(set) var precision: Int = 0
    var trigonometricToZero = true
    var last: Number { n.last }

    var debugLastAsDouble: Double { n.last.gmp!.toDouble() }
    var debugLastAsGmp: Gmp { n.last.gmp! }
    
    var isValidNumber: Bool { n.last.isValid }

    var haveResultCallback: () -> () = { }
    var pendingOperatorCallback: (String?) -> () = { _ in }
    var pendingOperator: String? {
        willSet {
            if pendingOperator != newValue {
                pendingOperatorCallback(newValue)
            }
        }
    }
        
    var memory: Gmp? = nil
    var nullNumber: Number {
        return Number("0", precision: precision)
    }
        
    func number(_ s: String) -> Number {
        return Number(s, precision: precision)
    }
    func gmpNumber(_ s: String) -> Number {
        return Number(Gmp(s, precision: precision))
    }
    let digitOperators: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
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


    func press(_ digits: String) {
        for digit in digits {
            if let intValue = digit.wholeNumberValue {
                press(intValue)
            } else {
                assert(false)
            }
        }
    }
    
    func press(_ digit: Int) {
        if digit >= 0 && digit <= 9 {
            Task {
                operation(String(digit))
            }
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
    
    func operation(_ symbol: String) {
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
            n.last.execute(op.operation)
            if trigonometricOperators.contains(symbol) {
                if trigonometricToZero {
                    let mantissaExponent = n.last.gmp!.mantissaExponent(len: 50)
                    if mantissaExponent.exponent < -1 * precision {
                        n.removeLast()
                        n.append(nullNumber)
                    }
                }
            }
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
    
    func setPrecision(_ newPrecision: Int) {
        if newPrecision != precision {
            n.updatePrecision(from: precision, to: newPrecision)
            precision = newPrecision
            haveResultCallback()
        }
    }
    
    init(precision: Int) {
        self.precision = precision
        operation("AC")
//        var precision = 3200*1024*1024
//        var x = Gmp("0", bits: 100)
//        while true {
//            let internalPrecision = Double(Brain.internalPrecision(precision))
//            let bits = Int(internalPrecision * 3.32192809489)
//
//            var used_megabytes: Int = 0
//            var total_bytes = Float(ProcessInfo.processInfo.physicalMemory)
//            var total_megabytes = Int(round(total_bytes / 1024.0 / 1024.0))
//            var info = mach_task_basic_info()
//            var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
//            var kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
//                $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
//                    task_info(
//                        mach_task_self_,
//                        task_flavor_t(MACH_TASK_BASIC_INFO),
//                        $0,
//                        &count
//                    )
//                }
//            }
//            if kerr == KERN_SUCCESS {
//                let used_bytes: Float = Float(info.resident_size)
//                used_megabytes = Int(round(used_bytes / 1024.0 / 1024.0))
//            }
//        
//            print("")
//            print("\(total_megabytes) total_megabytes ")
//            print("\(used_megabytes) used_megabytes ")
//            print("\(Int(round(Double(bits) / 1024.0 / 1024.0))) Mbits")
//            print("\(Int(Double(precision) / 1024.0 / 1024.0)) Mprecision")
//            x = Gmp("0", bits: bits)
//            x.rand()
//            used_megabytes = 0
//            total_bytes = Float(ProcessInfo.processInfo.physicalMemory)
//            total_megabytes = Int(round(total_bytes / 1024.0 / 1024.0))
//            info = mach_task_basic_info()
//            count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
//            kerr = withUnsafeMutablePointer(to: &info) {
//                $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
//                    task_info(
//                        mach_task_self_,
//                        task_flavor_t(MACH_TASK_BASIC_INFO),
//                        $0,
//                        &count
//                    )
//                }
//            }
//            if kerr == KERN_SUCCESS {
//                let used_bytes: Float = Float(info.resident_size)
//                used_megabytes = Int(round(used_bytes / 1024.0 / 1024.0))
//            }
//            print("\(used_megabytes) used_megabytes (after)")
//            precision += 200*1024*1024
//        }
    }
            
}
