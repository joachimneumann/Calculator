//
//  Number.swift
//  Calculator
//
//  Created by Joachim Neumann on 10/26/21.
//

import Foundation

class Number: CustomDebugStringConvertible, Equatable {
    private (set) var precision: Int = 0
    private var _str: String?
    private var _gmp: Gmp?
    
    var isStr: Bool { _str != nil }
    var isGmp: Bool { _gmp != nil }
    var str: String? { return _str }
    var gmp: Gmp? { return _gmp }
    
    static func ==(lhs: Number, rhs: Number) -> Bool {
        if lhs.isStr && rhs.isStr { return lhs.str! == rhs.str! }
        if lhs.isGmp && rhs.isGmp { return lhs.gmp! == rhs.gmp! }
        /// mixed str and Gmp

        if lhs.precision != rhs.precision { return false }

        let lGmp: Gmp
        let rGmp: Gmp
        if lhs.isGmp {
            lGmp = lhs.gmp!
        } else {
            lGmp = Gmp(withString: lhs.str!, precision: lhs.precision)
        }
        if rhs.isGmp {
            rGmp = rhs.gmp!
        } else {
            rGmp = Gmp(withString: rhs.str!, precision: lhs.precision)
        }
        return lGmp == rGmp
    }
    
    static func !=(lhs: Number, rhs: Number) -> Bool {
        return !(lhs == rhs)
    }
    
    var isValid: Bool {
        if isStr { return true }
        return _gmp!.isValid
    }
    func copy() -> Number {
        if isStr {
            return Number(str!, precision: precision)
        } else {
            return Number(gmp!.copy())
        }
    }
    func toGmp() {
        if isStr {
            _gmp = Gmp(withString: str!, precision: precision)
            _str = nil
        }
    }
    func execute(_ op: twoOperantsType, with other: Number) {
        toGmp()
        other.toGmp()
        _gmp!.execute(op, with: other._gmp!)
    }
    func execute(_ op: inplaceType) {
        toGmp()
        _gmp!.inPlace(op: op)
    }
    
    init(_ str: String, precision: Int) {
        _str = str
        _gmp = nil
        self.precision = precision
    }
    init(_ gmp: Gmp) {
        //print("Number init()")
        _str = nil
        _gmp = gmp.copy()
        self.precision = gmp.precision
    }
    fileprivate init() {
        //print("Number init()")
        _str = nil
        _gmp = nil
        precision = 0
    }
    
    func setValue(other number: Number) {
        if number.isStr {
            _str = number.str
            _gmp = nil
        } else {
            toGmp()
            _gmp!.setValue(other: number._gmp!)
        }
    }
    
    func append(_ digit: String) {
        if !isStr {
            _str = digit
            _gmp = nil
        } else if _str == "0" {
            _str = digit
        } else {
            _str!.append(digit)
        }
    }
    
    func appendDot() {
        if str == nil {
            _str = "0."
        } else {
            if !_str!.contains(".") { _str!.append(".") }
        }
    }
    var isNegative: Bool {
        if isStr {
            return _str!.starts(with: "-")
        } else {
            return _gmp!.isNegtive()
        }
    }
    func changeSign() {
        if isStr {
            if _str == "0" { return }
            if _str!.starts(with: "-") {
                _str!.removeFirst()
            } else {
                _str! = "-" + _str!
            }
        } else {
            _gmp!.changeSign()
        }
    }
    
    var debugDescription: String {
        if isStr {
            return "\(_str!) precision \(precision) string"
        } else {
            return "\(_gmp!.toDouble())  precision \(precision) gmp "
        }
    }
    
    static func internalPrecision(for precision: Int) -> Int {
        // return precision
        if precision <= 500 {
            return 1000
        } else if precision <= 10000 {
            return 2 * precision
        } else if precision <= 100000 {
            return Int(round(1.5*Double(precision)))
        } else {
            return precision + 50000
        }
    }
    
    static func bits(for precision: Int) -> Int {
        Int(Double(internalPrecision(for: precision)) * 3.32192809489)
    }
}


public extension String {
    func position(of char: Character) -> Int? {
        return firstIndex(of: char)?.utf16Offset(in: self)
    }
}

