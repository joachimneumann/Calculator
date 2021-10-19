//
//  NumberStack.swift
//  Calculator
//
//  Created by Joachim Neumann on 29/09/2021.
//

import Foundation

class Number: CustomDebugStringConvertible {
    var str: String?
    var gmp: Gmp
    
    func convertToGmp() {
        if str != nil {
            gmp = Gmp(str!)
            str = nil
        }
    }

    func execute(_ op: twoOperantsType, with other: Gmp) {
        convertToGmp()
        gmp.execute(op, with: other)
    }
    func inPlace(op: inplaceType) {
        convertToGmp()
        gmp.inPlace(op: op)
    }
    
    init(_ str: String) {
        self.str = str
        gmp = Gmp()
    }
    init(_ gmp: Gmp) {
        self.gmp = gmp
        str = nil
    }
    init() {
        self.gmp = Gmp()
        str = nil
    }
    
    func addZero()  {
        if str == nil || str == "0" {
            str = "0"
        } else {
            str!.append("0")
        }
    }
    
    func addComma() {
        if str == nil {
            str = "0,"
        } else {
            str!.append(",")
        }
    }
    
    func addDigit(_ digit: Int) {
        assert( digit > 0)
        assert( digit < 10)
        let digitString = String(digit)
        if str == nil || str == "0" {
            str = digitString
        } else {
            str!.append(digitString)
        }
    }
    
    var debugDescription: String {
        if str != nil {
            return "\(str!) s "
        } else {
            return "\(gmp.toDouble()) g "
        }
    }
}



struct NumberStack: CustomDebugStringConvertible{
    private var dd: DisplayData = DisplayData()
    private var ddLen = -1

    private var array: [Number] = []

    mutating func exponent(_ digits: Int) -> String? {
        if ddLen != digits {
            dd = DisplayData(number: array.last!, digits: digits)
            ddLen = digits
        }
        return dd.exponent
    }

    mutating func mantissa(_ digits: Int) -> String? {
        if ddLen != digits {
            dd = DisplayData(number: array.last!, digits: digits)
            ddLen = digits
        }
        print("dd.mantissa \(dd.mantissa)")
        return dd.mantissa
    }

    var debugLastDouble: Double { array.last!.convertToGmp(); return array.last!.gmp.toDouble() }
    var debugLastGmp: Gmp { array.last!.convertToGmp(); return array.last!.gmp }
    var isValidNumber: Bool { dd.isValidNumber }

    mutating func hasMoreDigits(_ digits: Int) -> Bool {
        if ddLen != digits {
            dd = DisplayData(number: array.last!, digits: digits)
            ddLen = digits
        }
        return dd.hasMoreDigits
    }

    mutating func lastDigit(_ digit: Int) {
        array.last!.addDigit(digit)
        ddLen = -1
    }
    mutating func lastZero() {
        array.last!.addZero()
        ddLen = -1
    }
    mutating func lastComma() {
        array.last!.addComma()
        ddLen = -1
    }
    mutating func lastExecute(_ op: twoOperantsType, with other: Gmp) {
        array.last!.execute(op, with: other)
        ddLen = -1
    }
    mutating func modifyLast(withOp op: inplaceType) {
        array.last!.inPlace(op: op)
        ddLen = -1
    }
    mutating func replaceLast(with number: Number) {
        array.removeLast()
        array.append(number)
        ddLen = -1
    }

    var lastConvertIntoGmp: Gmp {
        array.last!.convertToGmp()
        return array.last!.gmp
    }

//    func last() -> Number { array.last! }

    var count: Int { array.count }
    
    mutating func append(_ str: String)    { array.append(Number(str)); ddLen = -1 }
    mutating func append(_ gmp: Gmp)       { array.append(Number(gmp)); ddLen = -1 }
    mutating func popLast() -> Number?     { assert(array.count > 0); ddLen = -1; return array.popLast() }
    mutating func removeLast()             { assert(array.count > 0); array.removeLast(); ddLen = -1 }
    mutating func removeAll()              { array.removeAll(); ddLen = -1 }
    
    
    var secondLast: Number? {
        if count >= 2 {
            return array[array.count - 2]
        } else {
            return nil
        }
    }
    
    var debugDescription: String {
        var ret = "numberStack \(array.count): "
        for number in array {
            ret += "\(number) "
        }
        return ret
    }
    
}
