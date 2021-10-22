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
    private var dd: DisplayData? = nil
    private var array: [Number] = []

    var nonScientific: String? {
        mutating get {
            if dd == nil { dd = DisplayData(number: array.last!) }
            return dd!.nonScientific
        }
    }

    var scientific: Scientific? {
        mutating get {
            if dd == nil { dd = DisplayData(number: array.last!) }
            return dd!.scientific
        }
    }
    

    var debugLastDouble: Double { array.last!.convertToGmp(); return array.last!.gmp.toDouble() }
    var debugLastGmp: Gmp { array.last!.convertToGmp(); return array.last!.gmp }
    var isValidNumber: Bool {
        mutating get {
            if dd == nil { dd = DisplayData(number: array.last!) }
            return dd!.isValidNumber
        }
    }
    
    mutating func lastDigit(_ digit: Int) {
        array.last!.addDigit(digit)
        dd = nil
    }
    mutating func lastZero() {
        array.last!.addZero()
        dd = nil
    }
    mutating func lastComma() {
        array.last!.addComma()
        dd = nil
    }
    mutating func lastExecute(_ op: twoOperantsType, with other: Gmp) {
        array.last!.execute(op, with: other)
        dd = nil
    }
    mutating func modifyLast(withOp op: inplaceType) {
        array.last!.inPlace(op: op)
        dd = nil
    }
    mutating func replaceLast(with number: Number) {
        array.removeLast()
        array.append(number)
        dd = nil
    }

    var lastConvertIntoGmp: Gmp {
        array.last!.convertToGmp()
        return array.last!.gmp
    }

//    func last() -> Number { array.last! }

    var count: Int { array.count }
    
    mutating func append(_ str: String)    { array.append(Number(str)); dd = nil }
    mutating func append(_ gmp: Gmp)       { array.append(Number(gmp)); dd = nil }
    mutating func popLast() -> Number?     { assert(array.count > 0); dd = nil; return array.popLast() }
    mutating func removeLast()             { assert(array.count > 0); array.removeLast(); dd = nil }
    mutating func removeAll()              { array.removeAll(); dd = nil }
    
    
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
