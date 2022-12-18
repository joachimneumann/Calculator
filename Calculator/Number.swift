//
//  Number.swift
//  Calculator
//
//  Created by Joachim Neumann on 10/26/21.
//

import Foundation


struct DisplayData {
    var left: String = "0"
    var right: String?
    var isInteger: Bool = false
    var isFloat: Bool = false
    var isAbbreviated: Bool = false // show a message that there is more?
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
    
    func getDisplayData(
        forLong: Bool,
        lengths: Lengths,
        forceScientific: Bool,
        showAsInteger: Bool,
        showAsFloat: Bool,
        maxDisplayLength: Int = Number.MAX_DISPLAY_LENGTH) -> DisplayData {
        var ret = DisplayData()
        if !forceScientific {
            if let s = str {
                if s.contains("e") {
                    /// e.g. 1.4e7
                    if s.count <= lengths.withCommaScientific {
                        let separated = s.split(separator: "e")
                        if separated.count == 2 {
                            ret.left = String(separated[0])
                            ret.right = "e"+String(separated[1])
                            ret.isAbbreviated = false
                            return ret
                        }
                    }
                } else {
                    if s.contains(",") {
                        /// e.g. 43.22
                        if s.count <= lengths.withCommaNonScientific {
                            ret.left = s
                            ret.right = nil
                            ret.isAbbreviated = false
                            return ret
                        }
                    } else {
                        /// e.g. 23423
                        if s.count <= lengths.withoutComma {
                            ret.left = s
                            ret.right = nil
                            ret.isAbbreviated = false
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
            ret.left = "not a number"
            return ret
        }
        if displayGmp.inf {
            ret.left = "infinity"
            return ret
        }
        
        if !forceScientific && displayGmp.isZero {
            ret.left = "0"
            return ret
        }
        
        let mantissaLength: Int
        var withoutComma: Int
        var withCommaNonScientific: Int
        var withCommaScientific: Int
        var firstLineWithCommaNonScientific: Int
        var firstLineWithoutComma: Int

        if forLong {
            mantissaLength                  = min(_precision, maxDisplayLength)
            withoutComma                    = min(_precision, maxDisplayLength)
            withCommaNonScientific          = min(_precision, maxDisplayLength)
            withCommaScientific             = min(_precision, maxDisplayLength)
            firstLineWithoutComma           = min(_precision, lengths.withoutComma)
            firstLineWithCommaNonScientific = min(_precision, lengths.withCommaNonScientific)
        } else {
            mantissaLength                  = lengths.withCommaScientific
            withoutComma                    = min(_precision, lengths.withoutComma)
            withCommaNonScientific          = min(_precision, lengths.withCommaNonScientific)
            withCommaScientific             = min(_precision, lengths.withCommaScientific)
            firstLineWithoutComma           = withoutComma
            firstLineWithCommaNonScientific = withCommaNonScientific
        }
        
        let mantissaExponent = displayGmp.mantissaExponent(len: mantissaLength)

        var mantissa: String = mantissaExponent.mantissa
        var exponent: Int = mantissaExponent.exponent
        
        if mantissa == "" {
            mantissa = "0"
        } else {
            exponent = exponent - 1
        }
        
        /// negative? Special treatment
        let isNegative = mantissa.first == "-"
        if isNegative {
            mantissa.removeFirst()
            withoutComma                    -= 1
            withCommaNonScientific          -= 1
            withCommaScientific             -= 1
            firstLineWithoutComma           -= 1
            firstLineWithCommaNonScientific -= 1
        }

        /// Can be displayed as Integer?
        if !forceScientific && mantissa.count <= exponent+1 && exponent+1 <= withoutComma { /// smaller than because of possible trailing zeroes in the integer
            /// restore trailing zeros that have been removed
            mantissa = mantissa.padding(toLength: exponent+1, withPad: "0", startingAt: 0)
            // print(mantissa)
            if mantissa.count <= firstLineWithoutComma ||
                (forLong && showAsInteger) {
                ret.left = (isNegative ? "-" : "") + mantissa
                return ret
            } else {
                ret.isInteger = true
            }
        }
        
        /// Is floating point XXX,xxx?
        /// additional requirement: comma in first line. If not, it is not easy to see the comma
        if !forceScientific && exponent >= 0 {
            if exponent < withCommaNonScientific - 1 {
                var floatString = mantissa
                let index = floatString.index(floatString.startIndex, offsetBy: exponent+1)
                floatString.insert(",", at: index)

                /// is the comma visible in the first line and is there at least one digit after the comma?
                if exponent + 1 < firstLineWithCommaNonScientific ||
                    (forLong && showAsFloat) {
                    if floatString.count <= withCommaNonScientific {
                        ret.left = floatString
                    } else {
                        ret.left = String(floatString.prefix(withCommaNonScientific))
                        ret.isAbbreviated = true
                    }
                    if isNegative { ret.left = "-" + ret.left }
                    return ret
                } else {
                    /// can be displayed as float, but the comma is not in the first line
                    if !ret.isInteger { ret.isFloat = true }
                }
            }
        }
        
        /// is floating point 0,xxxx
        /// additional requirement: first non-zero digit in first line. If not -> Scientific
        if !forceScientific && exponent < 0 {
            if -1 * exponent < withCommaNonScientific - 1 {
                if -1 * exponent + 1 < firstLineWithCommaNonScientific ||
                        (forLong && showAsFloat) {
                    var floatString = mantissa
                    for _ in 0..<(-1*exponent - 1) {
                        floatString = "0" + floatString
                    }
                    floatString = "0," + floatString
                    if floatString.count <= withCommaNonScientific {
                        ret.left = floatString
                    } else {
                        ret.left = String(floatString.prefix(withCommaNonScientific))
                        ret.isAbbreviated = true
                    }
                    if isNegative { ret.left = "-" + ret.left }
                    return ret
                } else {
                    /// can be displayed as float, but the comma is not in the first line
                    if !ret.isInteger { ret.isFloat = true }
                }
            }
        }

        /// needs to be displayed in scientific notation
        ret.right = "e\(exponent)"
        let indexOne = mantissa.index(mantissa.startIndex, offsetBy: 1)
        mantissa.insert(",", at: indexOne)
        if mantissa.count <= 2 { mantissa += "0" } /// e.g. 1e16 -> 1,e16 -> 1,0e16
        if mantissa.count + ret.right!.count > withCommaScientific {
            /// Do I need to shorten the mantissa to fit into the display?
            let remainingMantissaLength = withCommaScientific - ret.right!.count
            if remainingMantissaLength < 3 {
                ret.left = "too large"
                ret.right = nil
                ret.isAbbreviated = false
                return ret
            } else {
                /// shorten...
                mantissa = String(mantissa.prefix(withCommaScientific - ret.right!.count))
                ret.isAbbreviated = true
            }
        }
        ret.left = mantissa
        if isNegative { ret.left = "-" + ret.left }
        return ret
    }
}
