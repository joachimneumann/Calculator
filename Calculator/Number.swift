//
//  Number.swift
//  Calculator
//
//  Created by Joachim Neumann on 10/26/21.
//

import Foundation

class Number: CustomDebugStringConvertible {
    private var _precision: Int = 0
    private var _str: String?
    private var _gmp: Gmp?
    static let MAX_DISPLAY_LENGTH = 10_000 // too long strings in Text() crash the app
    
    var isStr: Bool { _str != nil }
    var str: String? { return _str }
    var gmp: Gmp? { return _gmp }
    var valueHasChanged: Bool
    
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
            _gmp = Gmp(fromString: str!, bits: Self.bits(for: _precision))
            _str = nil
        }
    }
    func execute(_ op: twoOperantsType, with other: Number) {
        toGmp()
        other.toGmp()
        _gmp!.execute(op, with: other._gmp!)
        valueHasChanged = true
    }
    func execute(_ op: inplaceType) {
        toGmp()
        _gmp!.inPlace(op: op)
        valueHasChanged = true
    }
    
    init(_ str: String, precision: Int) {
        _str = str
        _gmp = nil
        _precision = precision
        valueHasChanged = true
    }
    init(_ gmp: Gmp, precision: Int) {
        //print("Number init()")
        _str = nil
        _gmp = gmp
        _precision = precision
        valueHasChanged = true
    }
    fileprivate init() {
        //print("Number init()")
        _str = nil
        _gmp = nil
        _precision = 0
        valueHasChanged = true
    }
    
    func setValue(other number: Number) {
        if number.isStr {
            _str = number.str
            _gmp = nil
        } else {
            toGmp()
            _gmp!.setValue(other: number._gmp!)
        }
        valueHasChanged = true
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
        valueHasChanged = true
    }
    
    func appendComma() {
        if str == nil {
            _str = "0,"
        } else {
            if !_str!.contains(",") { _str!.append(",") }
        }
        valueHasChanged = true
    }
    
    func appendDigit(_ digit: String) {
        if !isStr || _str == "0" {
            _str = digit
            _gmp = nil
        } else {
            _str!.append(digit)
        }
        valueHasChanged = true
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
        valueHasChanged = true
    }
    
    var debugDescription: String {
        if isStr {
            return "\(_str!) precision \(_precision) string"
        } else {
            return "\(_gmp!.toDouble())  precision \(_precision) gmp "
        }
    }
    
    func getDisplayData(
        multipleLines: Bool,
        lengths: Lengths,
        forceScientific: Bool,
        showAsInteger: Bool,
        showAsFloat: Bool,
        maxDisplayLength: Int = Number.MAX_DISPLAY_LENGTH) async -> DisplayData {
            //print("getDisplayData!!!!!!!")
            var ret = DisplayData()
            if !forceScientific {
                if let s = str {
                    if !s.contains("e") { // no shortcut for "scientific strings". This can not happen (I think)
                        if let pos = s.position(of: ",") {
                            if pos < lengths.withCommaNonScientific {
                                if multipleLines {
                                    //                                ret.isAbbreviated = s.count > maxDisplayLength
                                    ret.left = String(s.prefix(maxDisplayLength))
                                    ret.right = nil
                                    return ret
                                } else {
                                    /// portrait
                                    let leftCandidate = String(s.prefix(lengths.withCommaNonScientific))
                                    
                                    /// Oh. I dont't want to allow 0.0000000
                                    if leftCandidate.count == lengths.withCommaNonScientific &&
                                        leftCandidate == "0," + String(repeating: "0", count: leftCandidate.count - 2) {
                                        /// do nothing
                                    } else {
                                        ret.left = leftCandidate
                                        ret.maxlength = lengths.withCommaNonScientific
                                        // ret.isAbbreviated = s.count > lengths.withCommaNonScientific
                                        return ret
                                    }
                                }
                            }
                        } else {
                            /// e.g. 23423
                            if s.count <= lengths.withoutComma {
                                ret.left = s
                                ret.right = nil
                                ret.maxlength = lengths.withoutComma
                                //                            ret.isAbbreviated = false
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
                // what precision do I need to convert the string into a Gmp?
                // The length of the string is not sufficient because Gmp does not use base 10
                // Let's try three times the length with a minumum of 1000
                // Note that displayGmp is not use in further calculations!
                let displayPrecision: Int = max(str!.count * 3, 1000)
                displayGmp = Gmp(fromString: str!, bits: Self.bits(for: displayPrecision))
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
            
            if multipleLines {
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
                
                if mantissa.count > firstLineWithoutComma { ret.canBeInteger = true }
                if mantissa.count <= firstLineWithoutComma ||
                    (multipleLines && showAsInteger) {
                    ret.left = (isNegative ? "-" : "") + mantissa
                    ret.maxlength = lengths.withoutComma
                    return ret
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
                    if exponent + 1 >= firstLineWithCommaNonScientific { if !ret.canBeInteger { ret.canBeFloat = true } }
                    
                    if exponent + 1 < firstLineWithCommaNonScientific ||
                        (multipleLines && showAsFloat) {
                        if floatString.count <= withCommaNonScientific {
                            ret.left = floatString
                        } else {
                            ret.left = String(floatString.prefix(withCommaNonScientific))
                            // ret.isAbbreviated = true
                        }
                        if isNegative { ret.left = "-" + ret.left }
                        ret.maxlength = lengths.withCommaNonScientific
                        return ret
                    }
                }
            }
            
            /// is floating point 0,xxxx
            /// additional requirement: first non-zero digit in first line. If not -> Scientific
            if !forceScientific && exponent < 0 {
                if -1 * exponent < withCommaNonScientific - 1 {
                    if -1 * exponent + 1 >= firstLineWithCommaNonScientific { if !ret.canBeInteger { ret.canBeFloat = true } }
                    if -1 * exponent + 1 < firstLineWithCommaNonScientific ||
                            (multipleLines && showAsFloat) {
                        var floatString = mantissa
                        for _ in 0..<(-1*exponent - 1) {
                            floatString = "0" + floatString
                        }
                        floatString = "0," + floatString
                        if floatString.count <= withCommaNonScientific {
                            ret.left = floatString
                        } else {
                            ret.left = String(floatString.prefix(withCommaNonScientific))
                            //                        ret.isAbbreviated = true
                        }
                        if isNegative { ret.left = "-" + ret.left }
                        ret.maxlength = lengths.withCommaNonScientific
                        return ret
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
                    ret.left = "Can't Show"
                    ret.right = nil
                    // ret.isAbbreviated = false
                    return ret
                } else {
                    /// shorten...
                    mantissa = String(mantissa.prefix(withCommaScientific - ret.right!.count))
                    // ret.isAbbreviated = true
                }
            }
            ret.left = mantissa
            if isNegative { ret.left = "-" + ret.left }
            ret.maxlength = lengths.withCommaScientific
            return ret
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

