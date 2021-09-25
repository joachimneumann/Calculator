//
//  Brain.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

import Foundation

class Brain {
    func shortDisplayData() -> DisplayData {
        displayData(
            digits: Configuration.shared.digitsInSmallDisplay)
    }
    
    var allDigitsDisplayData: DisplayData {
        displayData(
            digits: 10) // TODO Bogus
    }
    
    private let debug = true
    private var numberString: String? = "0"
    
    private var twoParameterOperationStack = TwoParameterOperationStack()
    private var gmpStack = GmpStack()
    
    private var isTyping = false
    
    
    private func displayData(digits: Int) -> DisplayData {
        if let last = gmpStack.last {
            return DisplayData(gmp: last, digits: digits)
        } else {
            return DisplayData()
        }
    }
    
    func addDigitToNumberString(_ digit: Character) {
        if digit == "," {
            if numberString == nil {
                numberString = "0,"
            } else {
                if !numberString!.contains(",") {
                    numberString!.append(",")
                }
            }
        } else {
            // normal digit
            if numberString == nil {
                numberString = String(digit)
            } else {
                if numberString == "0" {
                    numberString = String(digit)
                } else {
                    numberString!.append(String(digit))
                }
            }
        }
        guard gmpStack.count >= 0 else {
            print("### ERROR")
            return
        }
        guard numberString != nil else {
            print("### ERROR")
            return
        }
        if isTyping {
            gmpStack.replaceLast(with: Gmp(numberString!))
        } else {
            gmpStack.push(Gmp(numberString!))
            isTyping = true
        }
        print("after add \"\(digit)\": " +
              "gmps: \(gmpStack.count), " +
              "ops: \(twoParameterOperationStack.count) " +
              "numberString: \(numberString ?? "empty") " +
              "typing: \(isTyping)")
    }
    
    func reset() {
        gmpStack.clean()
        twoParameterOperationStack.clean()
        numberString = nil
        isTyping = false
        addDigitToNumberString("0")
    }
    
    init() {
        reset()
        //test()
    }
    
    
    func executeEverythingUpTo(priority maxPriority: Int) {
        var pendingOperations = twoParameterOperationStack.count >= 1
        var sufficientNumbers = gmpStack.count >= 2
        var lastOperationNotTooHighPriority = false
        if twoParameterOperationStack.count > 0 {
            if twoParameterOperationStack.last!.priority >= maxPriority {
                lastOperationNotTooHighPriority = true
            }
        }
        while pendingOperations && sufficientNumbers && lastOperationNotTooHighPriority {
            let op = twoParameterOperationStack.pop()!
            let gmp1 = gmpStack.pop()!
            let gmp2 = gmpStack.pop()!
            let result = op.op(gmp2, gmp1)
            gmpStack.push(result)
            
            pendingOperations = twoParameterOperationStack.count >= 1
            sufficientNumbers = gmpStack.count >= 2
            lastOperationNotTooHighPriority = false
            if twoParameterOperationStack.count > 0 {
                if twoParameterOperationStack.last!.priority >= maxPriority {
                    lastOperationNotTooHighPriority = true
                }
            }
            
        }
    }
    
    func percentage() {
        if twoParameterOperationStack.count == 0 && gmpStack.count >= 1 {
            if let x1 = gmpStack.last {
                let x2 = Gmp("0.01")
                let x3 = x1 * x2
                gmpStack.replaceLast(with: x3)
            }
            
        } else if twoParameterOperationStack.count >= 1 && gmpStack.count >= 2 {
            if let x1 = gmpStack.last {
                if let x2 = gmpStack.secondLast {
                    let x3 = Gmp("0.01")
                    let x4 = x1 * x2 * x3
                    gmpStack.replaceLast(with: x4)
                }
            }
        }
    }
    
    func operation(_ symbol: String) {
        numberString = nil
        if symbol == "C" {
            reset()
            isTyping = false
        } else if symbol == "=" {
            executeEverythingUpTo(priority: -100)
            isTyping = false
        } else if symbol == "%" {
            if isTyping {
                percentage()
                isTyping = false
            } else {
                percentage()
            }
        } else if let op = inplaceDict[symbol] {
            if isTyping {
                gmpStack.modifyLast(withOp: op)
                isTyping = false
            } else {
                gmpStack.modifyLast(withOp: op)
            }
        } else if let op = constDict[symbol] {
            if isTyping {
                gmpStack.replaceLastWithConstant(withOp: op)
                isTyping = false
            } else {
                gmpStack.push(withOp: op)
                isTyping = false
            }
        } else if let op = twoParameterOperations[symbol] {
            if isTyping {
                executeEverythingUpTo(priority: op.priority)
                twoParameterOperationStack.push(op)
                isTyping = false
            } else {
                // The user seems to have changed his mind
                // Drop the last operation and replace it with this one
                if twoParameterOperationStack.count > 0 {
                    // this should always be the case
                    twoParameterOperationStack.removeLast()
                    twoParameterOperationStack.push(op)
                }
            }
        }
        print("after operation \(symbol): gmps: \(gmpStack.count), ops: \(twoParameterOperationStack.count) numberString: \(numberString ?? "empty") w: \(isTyping) ")
    }
    
    var inplaceDict: Dictionary <String, (Gmp) -> ()> = [
        "+/-": changeSign,
        "oneOverX": rez,
        "x!": fac,
        "Z": Z,
        "ln": ln,
        "log10": log10,
        "√": sqrt,
        "3√": sqrt3,
        "sin": sin,
        "cos": cos,
        "tan": tan,
        "asin": asin,
        "acos": acos,
        "atan": atan,
        "x^2": pow_x_2,
        "x^3": pow_x_3,
        "e^x": pow_e_x,
        "10^x": pow_10_x
    ]
    
    var constDict: Dictionary <String, () -> (Gmp)> = [
        "π": π,
        "e": e,
        "γ": γ,
    ]
    
    
    let twoParameterOperations: Dictionary <String, TwoParameterOperation> = [
        "+": TwoParameterOperation(add, 1),
        "-": TwoParameterOperation(min, 1),
        "x": TwoParameterOperation(mul, 2),
        "/": TwoParameterOperation(div, 2),
        "y√": TwoParameterOperation(sqrty, 3),
        "pow_x_y": TwoParameterOperation(pow_x_y, 3),
        "x↑↑y": TwoParameterOperation(x_double_up_arrow_y, 3),
    ]
    
    
    
    private func test() {
        
        // 1 / 10
        addDigitToNumberString("1")
        addDigitToNumberString("0")
        operation("oneOverX")
        assert(gmpStack.last! == Gmp("0.1"))
        addDigitToNumberString("1")
        assert(gmpStack.last! == Gmp("1"))
        addDigitToNumberString("6")
        assert(gmpStack.last! == Gmp("16"))
        operation("oneOverX")
        assert(gmpStack.last! == Gmp("0.0625"))
        
        // clear
        reset()
        assert(gmpStack.count == 1)
        assert(twoParameterOperationStack.count == 0)
        
        // 1+2+5+2= + 1/4 =
        addDigitToNumberString("1")
        assert(gmpStack.last == Gmp("1"))
        operation("+")
        assert(gmpStack.last == Gmp("1"))
        addDigitToNumberString("2")
        operation("+")
        assert(gmpStack.last == Gmp("3"))
        addDigitToNumberString("5")
        operation("+")
        assert(gmpStack.last == Gmp("8"))
        addDigitToNumberString("2")
        operation("=")
        assert(gmpStack.last == Gmp("10"))
        operation("+")
        assert(gmpStack.last == Gmp("10"))
        addDigitToNumberString("4")
        operation("oneOverX")
        assert(gmpStack.last == Gmp("0.25"))
        operation("=")
        assert(gmpStack.last == Gmp("10.25"))
        
        // 1+2*4=
        reset()
        addDigitToNumberString("1")
        assert(gmpStack.last == Gmp("1"))
        operation("+")
        addDigitToNumberString("2")
        operation("x")
        assert(gmpStack.last == Gmp("2"))
        addDigitToNumberString("4")
        assert(gmpStack.last == Gmp("4"))
        operation("=")
        assert(gmpStack.last == Gmp("9"))
        
        reset()
        addDigitToNumberString("1")
        assert(gmpStack.last == Gmp("1"))
        operation("+")
        addDigitToNumberString("2")
        operation("x")
        assert(gmpStack.last == Gmp("2"))
        addDigitToNumberString("4")
        assert(gmpStack.last == Gmp("4"))
        operation("+")
        assert(gmpStack.last == Gmp("9"))
        addDigitToNumberString("1")
        addDigitToNumberString("0")
        addDigitToNumberString("0")
        assert(gmpStack.last == Gmp("100"))
        // User: =
        operation("=")
        assert(gmpStack.last == Gmp("109"))
        
        reset()
        operation("π")
        operation("x")
        addDigitToNumberString("2")
        operation("=")
        
        reset()
        addDigitToNumberString("2")
        operation("pow_x_y")
        addDigitToNumberString("1")
        addDigitToNumberString("0")
        operation("=")
        assert(gmpStack.last == Gmp("1024"))
        reset()
    }
    
}
