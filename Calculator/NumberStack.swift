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
        if str == nil {
            str = "0"
        } else if str != "0" {
            str!.append("0")
        }
    }
    
    func addComma() {
        if str == nil {
            str = "0,"
        } else {
            if !str!.contains(",") { str!.append(",") }
        }
    }
    
    func addDigit(_ digit: String) {
        if str == nil || str == "0" {
            str = digit
        } else {
            str!.append(digit)
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
            print("NumberStack nonScientific dd \(dd == nil ? "nil" : "not nil")")
            if dd == nil { dd = DisplayData(number: array.last!) }
            return dd!.nonScientific
        }
    }
    
    var nonScientificIsString: Bool {
        mutating get {
            print("NumberStack nonScientificIsString dd \(dd == nil ? "nil" : "not nil")")
            if dd == nil { dd = DisplayData(number: array.last!) }
            return dd!.nonScientificIsString
        }
    }

    var nonScientificIsInteger: Bool {
        mutating get {
            print("NumberStack nonScientificIsInteger dd \(dd == nil ? "nil" : "not nil")")
            if dd == nil { dd = DisplayData(number: array.last!) }
            return dd!.nonScientificIsInteger
        }
    }

    var nonScientificIsFloat: Bool {
        mutating get {
            print("NumberStack nonScientificIsFloat dd \(dd == nil ? "nil" : "not nil")")
            if dd == nil { dd = DisplayData(number: array.last!) }
            return dd!.nonScientificIsFloat
        }
    }

    var scientific: Scientific? {
        mutating get {
            print("NumberStack scientific dd \(dd == nil ? "nil" : "not nil")")
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
    
    mutating func lastDigit(_ digit: String) {
        array.last!.addDigit(digit)
        print("lastDigit dd = nil")
        dd = nil
    }
    mutating func lastZero() {
        array.last!.addZero()
        print("lastZero dd = nil")
        dd = nil
    }
    mutating func lastComma() {
        array.last!.addComma()
        print("lastComma dd = nil")
        dd = nil
    }
    mutating func lastExecute(_ op: twoOperantsType, with other: Gmp) {
        array.last!.execute(op, with: other)
        print("lastExecute dd = nil")
        dd = nil
    }
    mutating func modifyLast(withOp op: inplaceType) {
        array.last!.inPlace(op: op)
        print("modifyLast dd = nil")
        dd = nil
    }
    mutating func replaceLast(with number: Number) {
        array.removeLast()
        array.append(number)
        print("replaceLast dd = nil")
        dd = nil
    }
    mutating func append(_ number: Number) {
        array.append(number)
        print("append dd = nil")
        dd = nil
    }

    
    var lastConvertIntoGmp: Gmp {
        array.last!.convertToGmp()
        return array.last!.gmp
    }

//    func last() -> Number { array.last! }

    var count: Int { array.count }
    
    mutating func append(_ str: String)    { array.append(Number(str)); print("append str dd = nil"); dd = nil }
    mutating func append(_ gmp: Gmp)       { array.append(Number(gmp)); print("append gmp dd = nil"); dd = nil }
    mutating func popLast() -> Number?     { assert(array.count > 0); print("popLast dd = nil"); dd = nil; return array.popLast() }
    mutating func removeLast()             { assert(array.count > 0); array.removeLast(); print("removeLast dd = nil"); dd = nil }
    mutating func removeAll()              { array.removeAll(); print("removeAll dd = nil"); dd = nil }
    
    
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
