//
//  Brain.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

import Foundation

class Brain {
    private let debug = true
    private var numberString: String? = "0"
    
    private var twoParameterOperationStack = TwoParameterOperationStack()
    private var gmpStack = GmpStack()
    
    private var waitingForNumber = false
    
    func shortDisplayString() -> DisplayString {
        if let last = gmpStack.peek {
            return last.displayString(digits: Configuration.shared.digits)
        } else {
            return DisplayString(
                isValidNumber: false,
                isNegative: false,
                higherPrecisionAvailable: false,
                isScientificNotation: false,
                content: "not a number")
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
        if waitingForNumber || gmpStack.count == 0 {
            gmpStack.push(Gmp(numberString!))
            waitingForNumber = false
        } else {
            gmpStack.replaceLast(with: Gmp(numberString!))
        }
        print("after addDigi \(digit): gmps: \(gmpStack.count), ops: \(twoParameterOperationStack.count) numberString: \(numberString ?? "empty") w: \(waitingForNumber) )") //gmp.peek: \(gmpStack.peek
    }
    
    func reset() {
        gmpStack.clean()
        twoParameterOperationStack.clean()
        numberString = nil
        addDigitToNumberString("0")
    }
    
    init() {
        reset()
        test()
    }
    
    func longString() -> String {
        if let last = gmpStack.peek {
            return last.displayString(digits: 70000).show()
        } else {
            return "not a number"
        }
    }
        
    func executeEverythingUpTo(priority maxPriority: Int) {
        var pendingOperations = twoParameterOperationStack.count >= 1
        var sufficientNumbers = gmpStack.count >= 2
        var lastOperationNotTooHighPriority = false
        if twoParameterOperationStack.count > 0 {
            if twoParameterOperationStack.peek!.priority >= maxPriority {
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
                if twoParameterOperationStack.peek!.priority >= maxPriority {
                    lastOperationNotTooHighPriority = true
                }
            }
            
        }
    }
    
    func operation(_ symbol: String) {
        numberString = nil
        if symbol == "C" {
            reset()
            waitingForNumber = false
        } else if symbol == "=" {
            if !waitingForNumber {
                executeEverythingUpTo(priority: -100)
                waitingForNumber = false
            }
        } else if let op = inplaceDict[symbol] {
            if !waitingForNumber {
                gmpStack.modifyLast(withOp: op)
                waitingForNumber = false
            }
        } else if let op = constDict[symbol] {
            if waitingForNumber {
                gmpStack.push(withOp: op)
            } else {
                gmpStack.replaceLast(withOp: op)
            }
            waitingForNumber = false
        } else if let op = twoParameterOperations[symbol] {
            if !waitingForNumber {
                executeEverythingUpTo(priority: op.priority)
                twoParameterOperationStack.push(op)
                waitingForNumber = true
            }
        }
        print("after operation \(symbol): gmps: \(gmpStack.count), ops: \(twoParameterOperationStack.count) numberString: \(numberString ?? "empty") w: \(waitingForNumber) ")
    }
    
    fileprivate var inplaceDict: Dictionary <String, (Gmp) -> ()> = [
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
    
    fileprivate var constDict: Dictionary <String, () -> (Gmp)> = [
        "π": π,
        "e": e,
        "γ": γ,
    ]
    
    
    fileprivate let twoParameterOperations: Dictionary <String, TwoParameterOperation> = [
        "+": TwoParameterOperation(add, 1),
        "-": TwoParameterOperation(min, 1),
        "x": TwoParameterOperation(mul, 2),
        "/": TwoParameterOperation(div, 2),
        "y√": TwoParameterOperation(sqrty, 2),
        "pow_x_y": TwoParameterOperation(pow_x_y, 2),
        "x↑↑y": TwoParameterOperation(x_double_up_arrow_y, 2),
    ]



private func test() {
    
    // 1 / 10
    addDigitToNumberString("1")
    addDigitToNumberString("0")
    operation("oneOverX")
    assert(gmpStack.peek! == Gmp("0.1"))
    addDigitToNumberString("1")
    assert(gmpStack.peek! == Gmp("1"))
    addDigitToNumberString("6")
    assert(gmpStack.peek! == Gmp("16"))
    operation("oneOverX")
    assert(gmpStack.peek! == Gmp("0.0625"))
    
    // clear
    reset()
    assert(gmpStack.count == 1)
    assert(twoParameterOperationStack.count == 0)
    
    // 1+2+5+2= + 1/4 =
    addDigitToNumberString("1")
    assert(gmpStack.peek == Gmp("1"))
    operation("+")
    assert(gmpStack.peek == Gmp("1"))
    addDigitToNumberString("2")
    operation("+")
    assert(gmpStack.peek == Gmp("3"))
    addDigitToNumberString("5")
    operation("+")
    assert(gmpStack.peek == Gmp("8"))
    addDigitToNumberString("2")
    operation("=")
    assert(gmpStack.peek == Gmp("10"))
    operation("+")
    assert(gmpStack.peek == Gmp("10"))
    addDigitToNumberString("4")
    operation("oneOverX")
    assert(gmpStack.peek == Gmp("0.25"))
    operation("=")
    assert(gmpStack.peek == Gmp("10.25"))
    
    // 1+2*4=
    reset()
    addDigitToNumberString("1")
    assert(gmpStack.peek == Gmp("1"))
    operation("+")
    addDigitToNumberString("2")
    operation("x")
    assert(gmpStack.peek == Gmp("2"))
    addDigitToNumberString("4")
    assert(gmpStack.peek == Gmp("4"))
    operation("=")
    assert(gmpStack.peek == Gmp("9"))
    
    reset()
    addDigitToNumberString("1")
    assert(gmpStack.peek == Gmp("1"))
    operation("+")
    addDigitToNumberString("2")
    operation("x")
    assert(gmpStack.peek == Gmp("2"))
    addDigitToNumberString("4")
    assert(gmpStack.peek == Gmp("4"))
    operation("+")
    assert(gmpStack.peek == Gmp("9"))
    addDigitToNumberString("1")
    addDigitToNumberString("0")
    addDigitToNumberString("0")
    assert(gmpStack.peek == Gmp("100"))
    // User: =
    operation("=")
    assert(gmpStack.peek == Gmp("109"))
    
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
    assert(gmpStack.peek == Gmp("1024"))
    reset()
}

}
