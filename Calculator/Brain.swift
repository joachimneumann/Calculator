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
    
    func shortDisplayString() -> ShortDisplayString {
        if let last = gmpStack.peek {
            return last.shortDisplayString()
        } else {
            return ShortDisplayString(
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
        print("after addDigi \(digit): gmps: \(gmpStack.count), ops: \(twoParameterOperationStack.count) numberString: \(numberString ?? "empty") w: \(waitingForNumber)")
    }
    
    func reset() {
        gmpStack.clean()
        twoParameterOperationStack.clean()
        numberString = nil
        addDigitToNumberString("0")
    }
    
    init() {
        reset()
    }
    
    //    private func fromLongString(_ string: String) -> Bool {
    //        if isValidGmpString(s: string, precision: nBits) {
    //            let value = Gmp(string, precision: nBits)
    //            n.push(value)
    //            XXX_OLD_STRING = value.toLongString()
    //            return true
    //        } else {
    //            return false
    //        }
    //    }
    
    
    func longString() -> String {
        //        var result = XXX_OLD_STRING
        //        let maxPrecision = 70000
        //        var resultArray = result.split(separator: "e")
        //        if resultArray.count == 2 {
        //            if resultArray[0].count > maxPrecision {
        //                resultArray[0] = resultArray[0].prefix(maxPrecision)
        //                result = String(resultArray[0])+"e"+String(resultArray[1])
        //            }
        //        } else {
        //            // no E
        //            result = String(resultArray[0].prefix(maxPrecision))
        //        }
        //        return result
        return "longString()"
    }
    
    
    //    func changeSign_() {
    //        if XXX_OLD_STRING.starts(with: "-") {
    //            XXX_OLD_STRING = String(XXX_OLD_STRING.dropFirst())
    //        } else {
    //            XXX_OLD_STRING = "-" + XXX_OLD_STRING
    //        }
    //        //        let n1 = Gmp(internalDisplay, precision: nBits)
    //        //        changeSign(n1)
    //        //        if n.count() > 0 { n.removeLast() }
    //        //        n.push(n1)
    //    }
    
    func executeEverythingUpTo(priority maxPriority: Int) {
        var pendingOperations = twoParameterOperationStack.count >= 1
        var sufficientNumbers = gmpStack.count >= 2
        var lastOperationNotTooHighPriority = false
        if twoParameterOperationStack.count > 0 {
            if twoParameterOperationStack.peek!.priority <= maxPriority {
                lastOperationNotTooHighPriority = true
            }
        }
        while pendingOperations && sufficientNumbers && lastOperationNotTooHighPriority {
            let op = twoParameterOperationStack.pop()!
            let gmp1 = gmpStack.pop()!
            let gmp2 = gmpStack.pop()!
            let result = op.op(gmp1, gmp2)
            gmpStack.push(result)
            
            pendingOperations = twoParameterOperationStack.count >= 1
            sufficientNumbers = gmpStack.count >= 2
            lastOperationNotTooHighPriority = false
            if twoParameterOperationStack.count > 0 {
                if twoParameterOperationStack.peek!.priority <= maxPriority {
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
                executeEverythingUpTo(priority: 100)
                waitingForNumber = false
            }
        } else if let op = inplaceDict[symbol] {
            gmpStack.modifyLast(withOp: op)
            waitingForNumber = false
        } else if let op = constDict[symbol] {
            gmpStack.replaceLast(withOp: op)
            waitingForNumber = false
        } else if let op = twoParameterOperations[symbol] {
            if !waitingForNumber {
                executeEverythingUpTo(priority: op.priority)
                twoParameterOperationStack.push(op)
                waitingForNumber = true
            }
        }
        print("after operation \(symbol): gmps: \(gmpStack.count), ops: \(twoParameterOperationStack.count) numberString: \(numberString ?? "empty") w: \(waitingForNumber)")
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
}


/*
 private func test() {
 precision = 75
 
 // 1 / 10
 digit("1")
 digit("0")
 operation("1\\x")
 assert(n.peek()! == Gmp("0.1", precision: nBits))
 digit("1")
 assert(n.peek()! == Gmp("1", precision: nBits))
 digit("6")
 assert(n.peek()! == Gmp("16", precision: nBits))
 operation("1\\x")
 assert(n.peek()! == Gmp("0.0625", precision: nBits))
 
 // clear
 reset()
 assert(n.peek() == nil)
 assert(op.count() == 0)
 
 // 1+2+5+2= + 1/4 =
 digit("1")
 assert(n.peek() == Gmp("1", precision: nBits))
 operation("+")
 assert(n.peek() == Gmp("1", precision: nBits))
 digit("2")
 operation("+")
 assert(n.peek() == Gmp("3", precision: nBits))
 digit("5")
 operation("+")
 assert(n.peek() == Gmp("8", precision: nBits))
 digit("2")
 operation("=")
 assert(n.peek() == Gmp("10", precision: nBits))
 operation("+")
 assert(n.peek() == Gmp("10", precision: nBits))
 digit("4")
 operation("1\\x")
 assert(n.peek() == Gmp("0.25", precision: nBits))
 operation("=")
 assert(n.peek() == Gmp("10.25", precision: nBits))
 
 // 1+2*4=
 reset()
 digit("1")
 assert(n.peek() == Gmp("1", precision: nBits))
 operation("+")
 digit("2")
 operation("x")
 assert(n.peek() == Gmp("2", precision: nBits))
 digit("4")
 assert(n.peek() == Gmp("4", precision: nBits))
 operation("=")
 assert(n.peek() == Gmp("9", precision: nBits))
 
 reset()
 digit("1")
 assert(n.peek() == Gmp("1", precision: nBits))
 operation("+")
 digit("2")
 operation("x")
 assert(n.peek() == Gmp("2", precision: nBits))
 digit("4")
 assert(n.peek() == Gmp("4", precision: nBits))
 operation("+")
 assert(n.peek() == Gmp("9", precision: nBits))
 digit("1")
 digit("0")
 digit("0")
 assert(n.peek() == Gmp("100", precision: nBits))
 // User: =
 operation("=")
 assert(n.peek() == Gmp("109", precision: nBits))
 
 reset()
 operation("π")
 operation("x")
 digit("2")
 operation("=")
 
 reset()
 digit("2")
 operation("pow_x_y")
 digit("1")
 digit("0")
 operation("=")
 assert(n.peek() == Gmp("1024", precision: nBits))
 reset()
 }
 */
