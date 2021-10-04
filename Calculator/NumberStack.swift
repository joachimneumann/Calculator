//
//  NumberStack.swift
//  Calculator
//
//  Created by Joachim Neumann on 29/09/2021.
//

import Foundation

class Number: CustomDebugStringConvertible {
    var str: String?
    private var _gmp: Gmp
    var convertIntoGmp: Gmp {
        if str != nil {
            _gmp = Gmp(str!)
            str = nil
        }
        return _gmp
    }

    func execute(_ op: twoOperantsType, with other: Gmp) {
        convertIntoGmp.execute(op, with: other)
    }
    func inPlace(op: inplaceType) {
        convertIntoGmp.inPlace(op: op)
    }
    
    init(_ str: String) {
        self.str = str
        _gmp = Gmp()
    }
    init(_ gmp: Gmp) {
        self._gmp = gmp
        str = nil
    }
    init() {
        self._gmp = Gmp()
        str = nil
    }
    
    func zero()  {
        if str == nil || str == "0" {
            str = "0"
        } else {
            str!.append("0")
        }
    }
    
    func comma() {
        if str == nil {
            str = "0,"
        } else {
            str!.append(",")
        }
    }
    
    func digit(_ digit: Int) {
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
            return "\(_gmp.toDouble()) g "
        }
    }
}

struct NumberStack: CustomDebugStringConvertible{
    private var array: [Number] = []
    
    var longDisplay: (String, String?) {
        let dd = DisplayData(gmp: last.convertIntoGmp, digits: TE.digitsInAllDigitsDisplay)
        return (dd.string, dd.exponent)
    }
    
    var last: Number {
        assert(array.last != nil)
        return array.last!
    }
    
    var count: Int { array.count }
    
    mutating func append(_ str: String)    { array.append(Number(str)) }
    mutating func append(_ gmp: Gmp)       { array.append(Number(gmp)) }
    mutating func popLast() -> Number?     { assert(array.count > 0); return array.popLast() }
    mutating func removeLast()             { assert(array.count > 0); array.removeLast() }
    mutating func removeAll()              { array.removeAll() }
    
    func modifyLast(withOp op: inplaceType) {
        if let last = array.last {
            last.inPlace(op: op)
        }
    }
    mutating func replaceLast(with number: Number) {
        array.removeLast()
        array.append(number)
    }
    
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
