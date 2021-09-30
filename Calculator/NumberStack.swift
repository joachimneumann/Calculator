//
//  NumberStack.swift
//  Calculator
//
//  Created by Joachim Neumann on 29/09/2021.
//

import Foundation

class Number: CustomDebugStringConvertible {
    var str: String?
    var isValid: Bool = true
    var hasMoreDigits: Bool = false
    private var _gmp: Gmp
    var gmp: Gmp {
        if str != nil {
            _gmp = Gmp(str!)
            str = nil
        }
        return _gmp
    }
    func check() {
        let temp: Gmp
        if str != nil {
            temp = Gmp(str)
        } else {
            temp = _gmp
        }
        isValid = temp.isValid
        hasMoreDigits = DisplayData(gmp: temp, digits: Configuration.shared.digitsInSmallDisplay).hasMoreDigits
    }
    func inPlace(op: inplaceType) {
        gmp.inPlace(op: op)
        check()
    }
    init(_ str: String) {
        self.str = str
        _gmp = Gmp()
        check()
    }
    init(_ gmp: Gmp)    {
        self._gmp = gmp
        str = nil
        check()
    }
    init()              {
        self._gmp = Gmp()
        str = nil
        check()
    }
    
    // && str != "0" { append("0") } }
    func zero()  {
        if str == nil || str == "0" {
            str = "0"
        } else {
            str!.append("0")
        }
        check()
    }
    func comma() {
        if str == nil {
            str = "0,"
        } else {
            str!.append(",")
        }
        check()
    }
    func digit(_ digit: Int) {
        assert( digit > 0)
        assert( digit < 10)
        if str == nil {
            str = String(digit)
        } else {
            str!.append(String(digit))
        }
        check()
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
    var display: String {
        let temp: Gmp
        if let str = last.str {
            if str.count <= Configuration.shared.digitsInSmallDisplay {
                return str
            } else {
                temp = Gmp(str)
            }
        } else {
            temp = last.gmp
        }
        let dd = DisplayData(gmp: temp, digits: Configuration.shared.digitsInSmallDisplay)
        return dd.string
    }

    
    var longDisplay: String {
        return DisplayData(gmp: last.gmp, digits: 10000-1).string // TODO only calculate DisplayData once
    }
    var hasMoreDigits: Bool {
        return last.hasMoreDigits
    }
    
    var isValid: Bool {
        return last.isValid
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
