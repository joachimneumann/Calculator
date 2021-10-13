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
    private var ds: DisplayData = DisplayData()
    private var dl: DisplayData = DisplayData()
    private var dsLen = -1
    private var dlLen = -1

    private var array: [Number] = []

//    mutating func sString(_ digits: Int) -> String {
//        // ok as string?
//        if let str = array.last!.str {
//            if str.count <= digits {
//                dsLen = -1; dlLen = -1
//                return str
//            }
//        }
//        // --> GMP
//        if dsLen != digits {
//            ds = DisplayData(number: array.last!, digits: digits, favourScientific: false)
//            dsLen = digits
//        }
//        return ds.string
//    }


    mutating func sMantissa(_ digits: Int) -> String {
        if dsLen != digits {
            ds = DisplayData(number: array.last!, digits: digits, favourScientific: false)
            dsLen = digits
        }
        print("ds.mantissa \(ds.mantissa)")
        return ds.mantissa
    }
    mutating func sExponent(_ digits: Int) -> String? {
//        if array.last!.str != nil {
//            return nil
//        }
        if dsLen != digits {
            ds = DisplayData(number: array.last!, digits: digits, favourScientific: false)
            dsLen = digits
        }
        return ds.exponent
    }

    mutating func lMantissa(_ digits: Int) -> String {
//        if let str = array.last!.str {
//            return str
//        }
        if dlLen != digits {
            dl = DisplayData(number: array.last!, digits: digits, favourScientific: true)
            dlLen = digits
        }
        return dl.mantissa
    }

    mutating func lExponent(_ digits: Int) -> String? {
        if array.last!.str != nil {
            return nil
        }
        if dsLen != digits {
            ds = DisplayData(number: array.last!, digits: digits, favourScientific: true)
            dsLen = digits
        }
        return ds.exponent
    }

    var debugLastDouble: Double { array.last!.convertToGmp(); return array.last!.gmp.toDouble() }
    var debugLastGmp: Gmp { array.last!.convertToGmp(); return array.last!.gmp }
    var isValidNumber: Bool { ds.isValidNumber }

    mutating func hasMoreDigits(_ digits: Int) -> Bool {
        if dsLen != digits {
            ds = DisplayData(number: array.last!, digits: digits, favourScientific: false)
            dsLen = digits
        }
        return ds.hasMoreDigits
    }

    mutating func lastDigit(_ digit: Int) {
        array.last!.addDigit(digit)
        dsLen = -1; dlLen = -1
    }
    mutating func lastZero() {
        array.last!.addZero()
        dsLen = -1; dlLen = -1
    }
    mutating func lastComma() {
        array.last!.addComma()
        dsLen = -1; dlLen = -1
    }
    mutating func lastExecute(_ op: twoOperantsType, with other: Gmp) {
        array.last!.execute(op, with: other)
        dsLen = -1; dlLen = -1
    }
    mutating func modifyLast(withOp op: inplaceType) {
        array.last!.inPlace(op: op)
        dsLen = -1; dlLen = -1
    }
    mutating func replaceLast(with number: Number) {
        array.removeLast()
        array.append(number)
        dsLen = -1; dlLen = -1
    }

    var lastConvertIntoGmp: Gmp {
        array.last!.convertToGmp()
        return array.last!.gmp
    }

//    func last() -> Number { array.last! }

    var count: Int { array.count }
    
    mutating func append(_ str: String)    { array.append(Number(str)); dsLen = -1; dlLen = -1 }
    mutating func append(_ gmp: Gmp)       { array.append(Number(gmp)); dsLen = -1; dlLen = -1 }
    mutating func popLast() -> Number?     { assert(array.count > 0); dsLen = -1; dlLen = -1; return array.popLast() }
    mutating func removeLast()             { assert(array.count > 0); array.removeLast(); dsLen = -1; dlLen = -1 }
    mutating func removeAll()              { array.removeAll(); dsLen = -1; dlLen = -1 }
    
    
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
