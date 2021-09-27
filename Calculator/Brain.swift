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
    
    var memory: Gmp = Gmp()
    
    private let debug = true
    private var numberString: String? = "0"
    
    private var operatorStack = OperatorStack()
    private var gmpStack = GmpStack()
    
    private var expectingNumber = false
    
    
    private func displayData(digits: Int) -> DisplayData {
        if let last = gmpStack.last {
            return DisplayData(gmp: last, digits: digits)
        } else {
            return DisplayData()
        }
    }
    
    func clearmemory() {
        memory = Gmp()
    }
    func addToMemory(_ plus: Gmp) {
        memory.add(other: plus)
        print("memory=\(memory.toDouble())")
    }
    func substractFromMemory(_ minus: Gmp) {
        memory.min(other: minus)
        print("memory=\(memory.toDouble())")
    }
    func getMemory() {
        if expectingNumber {
            gmpStack.append(memory)
            expectingNumber = false
        } else {
            gmpStack.replaceLast(with: memory)
            expectingNumber = false
        }

        print("memory=\(memory.toDouble())")
        print("gmpStack.last?=\(gmpStack.last!.toDouble())")
    }

    var last: Gmp? {
        gmpStack.last
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
              "ops: \(operatorStack.count) " +
              "numberString: \(numberString ?? "empty") " +
              "expectingNumber: \(expectingNumber)")
    }
    
    func reset() {
        gmpStack.removeAll()
        gmpStack.append(Gmp())
        operatorStack.clean()
        numberString = nil
        expectingNumber = false
    }
    
    init() {
        reset()
        //test()
    }
    
    
    func executeEverythingUpTo(priority maxPriority: Int) {
        func moreOperations() -> Bool {
            let pendingOperations = operatorStack.count >= 1
            let sufficientNumbers = gmpStack.count >= 2
            var lastOperationNotTooHighPriority = false
            if operatorStack.count > 0 {
                if operatorStack.last!.priority >= maxPriority {
                    lastOperationNotTooHighPriority = true
                }
            }
            return pendingOperations && sufficientNumbers && lastOperationNotTooHighPriority
        }
        
        while moreOperations() {
            let op = operatorStack.pop()!
            if let gmpTwoOperands = op as? TwoOperands {
                let gmp2 = gmpStack.popLast()!
                let gmp1 = gmpStack.last!
                gmp1.execute(gmpTwoOperands.operation, with: gmp2)
            }
        }
    }
    
    func percentage() {
        if operatorStack.count == 0 && gmpStack.count >= 1 {
            if let last = gmpStack.last {
                last.mul(other: Gmp("0.01"))
                gmpStack.replaceLast(with: last)
            }
            
        } else if operatorStack.count >= 1 && gmpStack.count >= 2 {
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
        } else if let op = operators[symbol] {
            if expectingNumber {
                // the user seems to have changed his mind
                // correct operation
                operatorStack.removeLast()
                operatorStack.push(op)
            } else {
                executeEverythingUpTo(priority: op.priority)
                operatorStack.push(op)
                expectingNumber = true
            }
        }
        print("after operation \(symbol): gmps: \(gmpStack.count), ops: \(operatorStack.count) numberString: \(numberString ?? "empty") expectingNumber: \(expectingNumber) ")
    }

    let inplaceOperations: Dictionary <String, inplaceType> = [
        "+/-":    Gmp.changeSign,
        "x^2":    Gmp.pow_x_2,
        "oneOverX": Gmp.rez,
        "x!":     Gmp.fac,
        "Z":      Gmp.Z,
        "ln":     Gmp.ln,
        "log10":  Gmp.log10,
        "log2":   Gmp.log2,
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
        "2^x":    Gmp.pow_2_x,
        "x^3":    Gmp.pow_x_3,
        "e^x":    Gmp.pow_e_x,
        "10^x":   Gmp.pow_10_x,
    ]
    
    let constDict: Dictionary <String, inplaceType> = [
        // same Gmp function as inplaceOperations, but handled differently
        "π":    Gmp.π,
        "e":    Gmp.e,
        "rand": Gmp.rand
    ]
    
    let operators: Dictionary <String, Operator> = [
        "+":    TwoOperands(Gmp.add, 1),
        "-":    TwoOperands(Gmp.min, 1),
        "x":    TwoOperands(Gmp.mul, 2),
        "/":    TwoOperands(Gmp.div, 2),
        "y√":   TwoOperands(Gmp.sqrty, 3),
        "x^y":  TwoOperands(Gmp.pow_x_y, 3),
        "y^x":  TwoOperands(Gmp.pow_y_x, 3),
        "logy": TwoOperands(Gmp.logy, 3),
        "x↑↑y": TwoOperands(Gmp.x_double_up_arrow_y, 3),
        "(":    Operator(4),
        ")":    Operator(4)
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
        assert(operatorStack.count == 0)
        
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
        operation("x^y")
        addDigitToNumberString("1")
        addDigitToNumberString("0")
        operation("=")
        assert(gmpStack.last == Gmp("1024"))
        reset()
    }
    
}
