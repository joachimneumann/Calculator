//
//  Number.swift
//  Calculator
//
//  Created by Joachim Neumann on 10/26/21.
//

import Foundation

class Number: CustomDebugStringConvertible {
    private (set) var precision: Int = 0
    private var _str: String?
    private var _gmp: Gmp?
    static let MAX_DISPLAY_LENGTH = 10_000 // too long strings in Text() crash the app
    
    var isStr: Bool { _str != nil }
    var str: String? { return _str }
    var gmp: Gmp? { return _gmp }
    
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
        _gmp = gmp
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
    
    func getDisplayData(
        multipleLines: Bool,
        lengths specifiedLengths: Lengths,
        useMaximalLength: Bool,
        forceScientific: Bool,
        showAsInteger: Bool,
        showAsFloat: Bool) -> DisplayData {
            let lengths: Lengths
            if useMaximalLength {
                lengths = Lengths(precision)
            } else {
                lengths = specifiedLengths
            }
            var displayData = DisplayData()
            if !forceScientific {
                if let s = str {
                    assert(!s.contains("e"), "What, a scientific string?") /// pasted numbers are always gmp
                    if let dotPosition = s.position(of: ".") {
                        if dotPosition < lengths.withCommaNonScientific { /// we want the comma to be visible in the first line!
                            if multipleLines {
                                displayData.left = String(s.prefix(Number.MAX_DISPLAY_LENGTH))
                                displayData.right = nil
                                return displayData
                            } else {
                                /// Is there something hidden after the zeroes in the first line? --> do nothing
                                let visible = String(s.prefix(lengths.withCommaNonScientific))
                                let allStripped = s.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "0", with: "")
                                let visibleStripped = visible.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "0", with: "")
                                if visibleStripped.count == 0 && allStripped.count > 0 {
                                    /// the number will be displayed as scientific
                                } else {
                                    displayData.left = String(s.prefix(lengths.withCommaNonScientific))
                                    displayData.maxlength = lengths.withCommaNonScientific
                                    return displayData
                                }
                            }
                        }
                    } else {
                        /// no comma -> Integer
                        if s.count <= lengths.withoutComma {
                            displayData.left = s
                            displayData.right = nil
                            displayData.maxlength = lengths.withoutComma
                            return displayData
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
                // Note that displayGmp is not used in further calculations!
                let displayPrecision: Int = max(str!.count * 3, 1000)
                displayGmp = Gmp(withString: str!, precision: displayPrecision)
            }
            
            if displayGmp.NaN {
                displayData.left = "not a number"
                return displayData
            }
            if displayGmp.inf {
                displayData.left = "infinity"
                return displayData
            }
            
            if !forceScientific && displayGmp.isZero {
                displayData.left = "0"
                return displayData
            }
            
            let mantissaLength: Int
            var withoutComma: Int
            var withCommaNonScientific: Int
            var withCommaScientific: Int
            var firstLineWithCommaNonScientific: Int
            var firstLineWithoutComma: Int
            
            if multipleLines {
                if useMaximalLength {
                    mantissaLength                  = precision
                    withoutComma                    = precision
                    withCommaNonScientific          = precision
                    withCommaScientific             = precision
                    firstLineWithoutComma           = precision
                    firstLineWithCommaNonScientific = precision
                } else {
                    mantissaLength                  = min(precision, Number.MAX_DISPLAY_LENGTH)
                    withoutComma                    = min(precision, Number.MAX_DISPLAY_LENGTH)
                    withCommaNonScientific          = min(precision, Number.MAX_DISPLAY_LENGTH)
                    withCommaScientific             = min(precision, Number.MAX_DISPLAY_LENGTH)
                    firstLineWithoutComma           = min(precision, lengths.withoutComma)
                    firstLineWithCommaNonScientific = min(precision, lengths.withCommaNonScientific)
                }
            } else {
                mantissaLength                  = lengths.withCommaScientific
                withoutComma                    = min(precision, lengths.withoutComma)
                withCommaNonScientific          = min(precision, lengths.withCommaNonScientific)
                withCommaScientific             = min(precision, lengths.withCommaScientific)
                firstLineWithoutComma           = withoutComma
                firstLineWithCommaNonScientific = withCommaNonScientific
            }
            
            let mantissaExponent = displayGmp.mantissaExponent(len: mantissaLength)
            
            var mantissa: String = mantissaExponent.mantissa
            var exponent: Int = mantissaExponent.exponent
            
            if mantissa.isEmpty {
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
                
                if mantissa.count > firstLineWithoutComma { displayData.canBeInteger = true }
                if mantissa.count <= firstLineWithoutComma ||
                    (multipleLines && showAsInteger) {
                    displayData.left = (isNegative ? "-" : "") + mantissa
                    displayData.maxlength = lengths.withoutComma
                    return displayData
                }
            }
            
            /// Is floating point XXX,xxx?
            if !forceScientific && exponent >= 0 {
                /// additional requirement: comma in first line. I don't want the comma to be hidden behind the keyboard
                if exponent < withCommaNonScientific - 1 {
                    var floatString = mantissa
                    let index = floatString.index(floatString.startIndex, offsetBy: exponent+1)
                    floatString.insert(".", at: index)
                    
                    /// is the comma visible in the first line and is there at least one digit after the comma?
                    if exponent + 1 >= firstLineWithCommaNonScientific { if !displayData.canBeInteger { displayData.canBeFloat = true } }
                    
                    if exponent + 1 < firstLineWithCommaNonScientific ||
                        (multipleLines && showAsFloat) {
                        if floatString.count <= withCommaNonScientific {
                            displayData.left = floatString
                        } else {
                            displayData.left = String(floatString.prefix(withCommaNonScientific))
                        }
                        if isNegative { displayData.left = "-" + displayData.left }
                        displayData.maxlength = lengths.withCommaNonScientific
                        return displayData
                    }
                }
            }
            
            /// is floating point 0,xxxx
            /// additional requirement: first non-zero digit in first line. If not -> Scientific
            if !forceScientific && exponent < 0 {
                if -1 * exponent < withCommaNonScientific - 1 {
                    if -1 * exponent + 1 >= firstLineWithCommaNonScientific { if !displayData.canBeInteger { displayData.canBeFloat = true } }
                    if -1 * exponent + 1 < firstLineWithCommaNonScientific ||
                            (multipleLines && showAsFloat) {
                        var floatString = mantissa
                        for _ in 0..<(-1*exponent - 1) {
                            floatString = "0" + floatString
                        }
                        floatString = "0," + floatString
                        if floatString.count <= withCommaNonScientific {
                            displayData.left = floatString
                        } else {
                            displayData.left = String(floatString.prefix(withCommaNonScientific))
                        }
                        if isNegative { displayData.left = "-" + displayData.left }
                        displayData.maxlength = lengths.withCommaNonScientific
                        return displayData
                    }
                }
            }
            
            /// needs to be displayed in scientific notation
            displayData.right = "e\(exponent)"
            let indexOne = mantissa.index(mantissa.startIndex, offsetBy: 1)
            mantissa.insert(".", at: indexOne)
            if mantissa.count <= 2 { mantissa += "0" } /// e.g. 1e16 -> 1,e16 -> 1,0e16
            if mantissa.count + displayData.right!.count > withCommaScientific {
                /// Do I need to shorten the mantissa to fit into the display?
                let remainingMantissaLength = withCommaScientific - displayData.right!.count
                if remainingMantissaLength < 3 {
                    displayData.left = "Can't Show"
                    displayData.right = nil
                    return displayData
                } else {
                    /// shorten...
                    mantissa = String(mantissa.prefix(withCommaScientific - displayData.right!.count))
                }
            }
            displayData.left = mantissa
            if isNegative { displayData.left = "-" + displayData.left }
            displayData.maxlength = lengths.withCommaScientific
            return displayData
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

