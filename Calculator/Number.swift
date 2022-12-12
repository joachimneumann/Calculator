//
//  Number.swift
//  Calculator
//
//  Created by Joachim Neumann on 10/26/21.
//

import Foundation


struct DisplayData {
    var shortLeft: String
    var shortRight: String?
    var shortAbbreviated: Bool // show a message that there is more?
    var longLeft: String
    var longRight: String?
    var longAbbreviated: Bool // show a message that there is more?
    var short : String {
        shortLeft + (shortRight != nil ? shortRight! : "")
    }
    var long : String {
        longLeft + (longRight != nil ? longRight! : "")
    }
}

class Number: CustomDebugStringConvertible {
    private var _precision: Int = 0
    private var _str: String?
    private var _gmp: Gmp?
    static let MAX_DISPLAY_LENGTH = 10000 // too long strings in Text() crash the app

    var isStr: Bool { _str != nil }
    var str: String? { return _str }
    var gmp: Gmp? { return _gmp }
    
    var isNull: Bool {
        if isStr {
            if str == "0" { return true }
            if str == "0," { return true }
            if str == "0,0" { return true }
            return false
        } else {
            if let g = gmp {
                return g.isNull()
            }
            assert(false)
        }
        return false
    }
    
    var isValid: Bool {
        if isStr { return true }
        return _gmp!.isValid
    }
    func copy() -> Number {
        if isStr {
            return Number(str!, precision: _precision)
        } else {
            return Number(gmp!.copy(), precision: _precision)
        }
    }
    func toGmp() {
        if isStr {
            _gmp = Gmp(str!, precision: _precision)
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
        _precision = precision
    }
    init(_ gmp: Gmp, precision: Int) {
        //print("Number init()")
        _str = nil
        _gmp = gmp
        _precision = precision
    }
    fileprivate init() {
        //print("Number init()")
        _str = nil
        _gmp = nil
        _precision = 0
    }

    func setValue(other number: Number) {
        number.toGmp()
        toGmp()
        _gmp!.setValue(other: number._gmp!)
    }

    func appendZero()  {
        if isStr {
            if _str != "0" {
                _str!.append("0")
            }
        } else {
            _str = "0"
            _gmp = nil
        }
    }
    
    func appendComma() {
        if str == nil {
            _str = "0,"
        } else {
            if !_str!.contains(",") { _str!.append(",") }
        }
    }
    
    func appendDigit(_ digit: String) {
        if !isStr || _str == "0" {
            _str = digit
            _gmp = nil
        } else {
            _str!.append(digit)
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
            return "\(_str!) precision \(_precision) string"
        } else {
            return "\(_gmp!.toDouble())  precision \(_precision) gmp "
        }
    }
    
    struct LR {
        var left: String
        var right: String?
        var abbreviated: Bool
    }
    
    func getDisplayData(_ lengths: Lengths, forceScientific: Bool, maxDisplayLength: Int = Number.MAX_DISPLAY_LENGTH) -> DisplayData {
        var ret = DisplayData(
            shortLeft: "0",
            shortRight: nil,
            shortAbbreviated: false,
            longLeft: "0",
            longRight: nil,
            longAbbreviated: false)
        if !forceScientific {
            if let s = str {
                if s.contains("e") {
                    /// e.g. 1.4e7
                    if s.count <= lengths.withCommaScientific {
                        let separated = s.split(separator: "e")
                        if separated.count == 2 {
                            ret.shortLeft = String(separated[0])
                            ret.shortRight = "e"+String(separated[1])
                            ret.shortAbbreviated = false
                            ret.longLeft = ret.shortLeft
                            ret.longRight = nil
                            ret.longAbbreviated = false
                            return ret
                        }
                    }
                } else {
                    if s.contains(",") {
                        /// e.g. 43.22
                        if s.count <= lengths.withCommaNonScientific {
                            ret.shortLeft = s
                            ret.shortRight = nil
                            ret.shortAbbreviated = false
                            ret.longLeft = ret.shortLeft
                            ret.longRight = nil
                            ret.longAbbreviated = false
                            return ret
                        }
                    } else {
                        /// e.g. 23423
                        if s.count <= lengths.withoutComma {
                            ret.shortLeft = s
                            ret.shortRight = nil
                            ret.shortAbbreviated = false
                            ret.longLeft = ret.shortLeft
                            ret.longRight = nil
                            ret.longAbbreviated = false
                            return ret
                        }
                    }
                }
            }
        }

        /// not a short enough str, use gmp
        let displayGmp: Gmp
        if gmp != nil {
            displayGmp = gmp!
        } else {
            displayGmp = Gmp(str!, precision: _precision)
        }
        
        if displayGmp.NaN {
            ret.shortLeft = "not a number"
            ret.shortRight = nil
            ret.shortAbbreviated = false
            ret.longLeft = ret.shortLeft
            ret.longRight = nil
            ret.longAbbreviated = false
            return ret
        }
        if displayGmp.inf {
            ret.shortLeft = "too large"
            ret.shortRight = nil
            ret.shortAbbreviated = false
            ret.longLeft = ret.shortLeft
            ret.longRight = nil
            ret.longAbbreviated = false
            return ret
        }
        
        if !forceScientific && displayGmp.isZero {
            ret.shortLeft = "0"
            ret.shortRight = nil
            ret.shortAbbreviated = false
            ret.longLeft = ret.shortLeft
            ret.longRight = nil
            ret.longAbbreviated = false
            return ret
        }
        
        let mantissaExponent = displayGmp.mantissaExponent(len: min(_precision, maxDisplayLength))

        let lrShort = process(
            mantissa: mantissaExponent.mantissa,
            exponent: mantissaExponent.exponent,
            withoutComma_ : min(_precision, lengths.withoutComma),
            withCommaNonScientific_ : min(_precision, lengths.withCommaNonScientific),
            withCommaScientific_: min(_precision, lengths.withCommaScientific),
            forceScientific_: forceScientific)
        let lrLong = process(
            mantissa: mantissaExponent.mantissa,
            exponent: mantissaExponent.exponent,
            withoutComma_ : min(_precision, maxDisplayLength),
            withCommaNonScientific_ : min(_precision, maxDisplayLength),
            withCommaScientific_: min(_precision, maxDisplayLength),
            forceScientific_: forceScientific)
        return DisplayData(
            shortLeft: lrShort.left,
            shortRight: lrShort.right,
            shortAbbreviated: lrShort.abbreviated,
            longLeft: lrLong.left,
            longRight: lrLong.right,
            longAbbreviated: lrLong.abbreviated)
    }
    
    func process(
        mantissa: String,
        exponent: Int,
        withoutComma_: Int,
        withCommaNonScientific_: Int,
        withCommaScientific_: Int,
        forceScientific_ : Bool
    ) -> LR {
        var mantissa = mantissa
        var exponent = exponent
        var lr = LR(left: "0", right: nil, abbreviated: false)
        let forceScientific = forceScientific_
        if mantissa == "" {
            mantissa = "0"
        } else {
            exponent = exponent - 1
        }
        
        let withoutComma: Int
        let withCommaNonScientific: Int
        let withCommaScientific: Int
        /// negative? Special treatment
        let isNegative: Bool
        if mantissa.first == "-" {
            mantissa.removeFirst()
            isNegative = true
            withoutComma           = withoutComma_ - 1
            withCommaNonScientific = withCommaNonScientific_ - 1
            withCommaScientific    = withCommaScientific_ - 1
        } else {
            isNegative = false
            withoutComma           = withoutComma_
            withCommaNonScientific = withCommaNonScientific_
            withCommaScientific    = withCommaScientific_
        }

        /// Can be displayed as Integer?
        if !forceScientific && mantissa.count <= exponent+1 && exponent+1 <= withoutComma { /// smaller than because of possible trailing zeroes in the integer
            
            /// restore trailing zeros that have been removed
            mantissa = mantissa.padding(toLength: exponent+1, withPad: "0", startingAt: 0)
            // print(mantissa)
            if mantissa.count <= withoutComma {
                lr.left = (isNegative ? "-" : "") + mantissa
                return lr
            }
        }
        
        /// Is floating point XXX,xxx?
        if !forceScientific && exponent >= 0 {
            if exponent < withCommaNonScientific - 1 { /// is the comma visible in the first line and is there at least one digit after the comma?
                var floatString = mantissa
                let index = floatString.index(floatString.startIndex, offsetBy: exponent+1)
                floatString.insert(",", at: index)
                lr.left = floatString
                if floatString.count <= withCommaNonScientific {
                    lr.left = floatString
                } else {
                    lr.left = String(floatString.prefix(withCommaNonScientific))
                    lr.abbreviated = true
                }
                if isNegative { lr.left = "-" + lr.left }
                return lr
            }
        }
        
        /// is floating point 0,xxxx
        if !forceScientific && exponent < 0 {
            if -1 * exponent < withCommaNonScientific - 1 {
                var floatString = mantissa
                for _ in 0..<(-1*exponent - 1) {
                    floatString = "0" + floatString
                }
                floatString = "0," + floatString
                if floatString.count <= withCommaNonScientific {
                    lr.left = floatString
                } else {
                    lr.left = String(floatString.prefix(withCommaNonScientific))
                    lr.abbreviated = true
                }
                if isNegative { lr.left = "-" + lr.left }
                return lr
            }
        }

        /// needs to be displayed in scientific notation
        lr.right = "e\(exponent)"
        let indexOne = mantissa.index(mantissa.startIndex, offsetBy: 1)
        mantissa.insert(",", at: indexOne)
        if mantissa.count <= 2 { mantissa += "0" } /// e.g. 1e16 -> 1,e16 -> 1,0e16
        if mantissa.count + lr.right!.count > withCommaScientific {
            /// Do I need to shorten the mantissa to fit into the display?
            let remainingMantissaLength = withCommaScientific - lr.right!.count
            if remainingMantissaLength < 3 {
                lr.left = "too large"
                lr.right = nil
                lr.abbreviated = false
                return lr
            } else {
                /// shorten...
                mantissa = String(mantissa.prefix(withCommaScientific - lr.right!.count))
                lr.abbreviated = true
            }
        }
        lr.left = mantissa
        if isNegative { lr.left = "-" + lr.left }
        return lr
    }
}
