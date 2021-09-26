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
    
    private var op2Stack = Op2Stack()
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
            gmpStack.append(Gmp(numberString!))
            expectingNumber = false
        } else {
            gmpStack.replaceLast(with: Gmp(numberString!))
        }
        print("after add \"\(digit)\": " +
              "gmps: \(gmpStack.count), " +
              "ops: \(op2Stack.count) " +
              "numberString: \(numberString ?? "empty") " +
              "expectingNumber: \(expectingNumber)")
    }
    
    func reset() {
        gmpStack.removeAll()
        gmpStack.append(Gmp())
        op2Stack.clean()
        numberString = nil
        expectingNumber = false
    }
    
    init() {
        reset()
        //test()
    }
    
    
    func executeEverythingUpTo(priority maxPriority: Int) {
        func moreOperations() -> Bool {
            let pendingOperations = op2Stack.count >= 1
            let sufficientNumbers = gmpStack.count >= 2
            var lastOperationNotTooHighPriority = false
            if op2Stack.count > 0 {
                if op2Stack.last!.priority >= maxPriority {
                    lastOperationNotTooHighPriority = true
                }
            }
            return pendingOperations && sufficientNumbers && lastOperationNotTooHighPriority
        }
        
        while moreOperations() {
            let op = op2Stack.pop()!
            let gmp2 = gmpStack.popLast()!
            let gmp1 = gmpStack.last!
            gmp1.withOther(op: op.operation, other: gmp2)
        }
    }
    
    func percentage() {
        if op2Stack.count == 0 && gmpStack.count >= 1 {
            if let last = gmpStack.last {
                last.mul(other: Gmp("0.01"))
                gmpStack.replaceLast(with: last)
            }
            
        } else if op2Stack.count >= 1 && gmpStack.count >= 2 {
            if let last = gmpStack.last {
                if let secondLast = gmpStack.secondLast {
                    last.mul(other: Gmp("0.01"))
                    last.mul(other: secondLast)
                    gmpStack.replaceLast(with: last)
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
            gmpStack.modifyLast(withOp: op)
            expectingNumber = false
        } else if let op = constDict[symbol] {
            if expectingNumber {
                gmpStack.append(Gmp())
                gmpStack.modifyLast(withOp: op)
                expectingNumber = false
            } else {
                gmpStack.modifyLast(withOp: op)
                expectingNumber = false
            }
        } else if let op = op2[symbol] {
            if expectingNumber {
                // the user seems to have changed his mind
                // correct operation
                op2Stack.removeLast()
                op2Stack.push(op)
            } else {
                executeEverythingUpTo(priority: op.priority)
                op2Stack.push(op)
                expectingNumber = true
            }
        }
        print("after operation \(symbol): gmps: \(gmpStack.count), ops: \(op2Stack.count) numberString: \(numberString ?? "empty") expectingNumber: \(expectingNumber) ")
    }

    let inplaceOperations: Dictionary <String, (Gmp) -> () -> ()> = [
        "+/-": Gmp.changeSign,
        "x^2":Gmp.pow_x_2,
        "oneOverX": Gmp.rez,
        "x!":     Gmp.fac,
        "Z":      Gmp.Z,
        "ln":     Gmp.ln,
        "log10":  Gmp.log10,
        "√":      Gmp.sqrt,
        "3√":     Gmp.sqrt3,
        "sin":    Gmp.sin,
        "cos":    Gmp.cos,
        "tan":    Gmp.tan,
        "asin":   Gmp.asin,
        "acos":   Gmp.acos,
        "atan":   Gmp.atan,
        "sinh":   Gmp.sinh,
        "cosh":   Gmp.cosh,
        "tanh":   Gmp.tanh,
        "asinh":  Gmp.asinh,
        "acosh":  Gmp.acosh,
        "atanh":  Gmp.atanh,
        "sinD":   Gmp.sinD,
        "cosD":   Gmp.cosD,
        "tanD":   Gmp.tanD,
        "asinD":  Gmp.asinD,
        "acosD":  Gmp.acosD,
        "atanD":  Gmp.atanD,
        "sinhD":  Gmp.sinhD,
        "coshD":  Gmp.coshD,
        "tanhD":  Gmp.tanhD,
        "asinhD": Gmp.asinhD,
        "acoshD": Gmp.acoshD,
        "atanhD": Gmp.atanhD,
        "x^3":    Gmp.pow_x_3,
        "e^x":    Gmp.pow_e_x,
        "10^x":   Gmp.pow_10_x,
    ]
    
    let constDict: Dictionary <String, (Gmp) -> () -> ()> = [
        // same Gmp function as inplaceOperations, but handled differently
        "π":    Gmp.π,
        "e":    Gmp.e,
        "rand": Gmp.rand
    ]
    
    
    let op2: Dictionary <String, Op2> = [
        "+": Op2(Gmp.add, 1),
        "-": Op2(Gmp.min, 1),
        "x": Op2(Gmp.mul, 2),
        "/": Op2(Gmp.div, 2),
        "y√": Op2(Gmp.sqrty, 3),
        "pow_x_y": Op2(Gmp.pow_x_y, 3),
        "x↑↑y": Op2(Gmp.x_double_up_arrow_y, 3),
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
        assert(op2Stack.count == 0)
        
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
