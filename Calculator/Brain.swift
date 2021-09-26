//
//  Brain.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

class Brain {
    func shortDisplayData() -> DisplayData {
        displayData(digits: Configuration.shared.digitsInSmallDisplay)
    }
    
    var allDigitsDisplayData: DisplayData {
        displayData(digits: 10000) // TODO Bogus
    }
    
    private let debug = true
    private var numberString: String? = "0"
    
    private var twoParameterOperationStack = TwoParameterOperationStack()
    private var gmpStack = GmpStack()
    
    private var expectingNumber = false
    
    
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
        if expectingNumber {
            gmpStack.push(Gmp(numberString!))
            expectingNumber = false
        } else {
            gmpStack.replaceLast(with: Gmp(numberString!))
        }
        print("after add \"\(digit)\": " +
              "gmps: \(gmpStack.count), " +
              "ops: \(twoParameterOperationStack.count) " +
              "numberString: \(numberString ?? "empty") " +
              "expectingNumber: \(expectingNumber)")
    }
    
    func reset() {
        gmpStack.clean()
        gmpStack.push(Gmp("0"))
        twoParameterOperationStack.clean()
        numberString = nil
        expectingNumber = false
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
            expectingNumber = false
        } else if symbol == "=" {
            executeEverythingUpTo(priority: -100)
            expectingNumber = false
        } else if symbol == "%" {
            percentage()
            expectingNumber = false
        } else if let op = inplaceOperations[symbol] {
            gmpStack.inPlaceModifyLast(withOp: op)
            expectingNumber = false
        } else if let op = constDict[symbol] {
            if expectingNumber {
                gmpStack.push(withOp: op)
                expectingNumber = false
            } else {
                gmpStack.replaceLastWithConstant(withOp: op)
                expectingNumber = false
            }
        } else if let op = twoParameterOperations[symbol] {
            if expectingNumber {
                // the user seems to have changed his mind
                // correct operation
                twoParameterOperationStack.removeLast()
                twoParameterOperationStack.push(op)
            } else {
                executeEverythingUpTo(priority: op.priority)
                twoParameterOperationStack.push(op)
                expectingNumber = true
            }
        }
        print("after operation \(symbol): gmps: \(gmpStack.count), ops: \(twoParameterOperationStack.count) numberString: \(numberString ?? "empty") expectingNumber: \(expectingNumber) ")
    }

    let inplaceOperations: Dictionary <String, (Gmp) -> () -> ()> = [
        "+/-": Gmp.changeSign,
        "x^2":Gmp.pow_x_2,
        "oneOverX": Gmp.rez,
        "x!": Gmp.fac,
        "Z": Gmp.Z,
        "ln": Gmp.ln,
        "log10": Gmp.log10,
        "√": Gmp.sqrt,
        "3√": Gmp.sqrt3,
        "sin": Gmp.sin,
        "cos": Gmp.cos,
        "tan": Gmp.tan,
        "asin": Gmp.asin,
        "acos": Gmp.acos,
        "atan": Gmp.atan,
        "x^3": Gmp.pow_x_3,
        "e^x": Gmp.pow_e_x,
        "10^x": Gmp.pow_10_x
    ]
    
    var constDict: Dictionary <String, () -> (Gmp)> = [
        "π": Gmp.π,
        "e": Gmp.e,
        "γ": Gmp.γ,
    ]
    
    
    let twoParameterOperations: Dictionary <String, TwoParameterOperation> = [
        "+": TwoParameterOperation(Gmp.add, 1),
        "-": TwoParameterOperation(Gmp.min, 1),
        "x": TwoParameterOperation(Gmp.mul, 2),
        "/": TwoParameterOperation(Gmp.div, 2),
        "y√": TwoParameterOperation(Gmp.sqrty, 3),
        "pow_x_y": TwoParameterOperation(Gmp.pow_x_y, 3),
        "x↑↑y": TwoParameterOperation(Gmp.x_double_up_arrow_y, 3),
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
