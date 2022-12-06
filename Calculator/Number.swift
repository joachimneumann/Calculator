//
//  Number.swift
//  Calculator
//
//  Created by Joachim Neumann on 10/26/21.
//

import Foundation


struct MultipleLiner {
    var left: String
    var right: String? = nil
    var abbreviated: Bool // show a message that there is more?
    var asOneLine: String {
        left + (right != nil ? right! : "")
    }
}

class Number: CustomDebugStringConvertible {
    private var _bits: Int
    private var _str: String?
    private var _gmp: Gmp?
    
    var isStr: Bool { _str != nil }
    var str: String? { return _str }
    var gmp: Gmp? { return _gmp }
    var multipleLines: MultipleLiner?
    
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
            return Number(str!, bits: _bits)
        } else {
            return Number(gmp!.copy())
        }
    }
    func toGmp() {
        if isStr {
            _gmp = Gmp(str!, bits: _bits)
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
    
    init(_ str: String, bits: Int) {
        //print("Number init()")
        _str = str
        _gmp = nil
        _bits = bits
    }
    init(_ gmp: Gmp) {
        //print("Number init()")
        _str = nil
        _gmp = gmp
        _bits = gmp.bits
    }
    fileprivate init() {
        //print("Number init()")
        _str = nil
        _gmp = nil
        _bits = 0
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
            return "\(_str!) s "
        } else {
            return "\(_gmp!.toDouble()) g "
        }
    }
    
//    func multipleLiner(length: Int) -> MultipleLiner {
//        var ret = MultipleLiner(left: "0", abreviated: false)
//        guard let multipleLinerStr = str, multipleLinerStr.count <= length else {
//            return ret
//        }
//        ret.left = multipleLinerStr
//        return ret
//    }

    func multipleLines(_ lengthMeasurementResult: LengthMeasurementResult, forceScientific: Bool = false) -> MultipleLiner {
        var ret = MultipleLiner(left: "0", abbreviated: false)
        ret.abbreviated = false
        if !forceScientific {
            if let s = str {
                if s.contains(",") {
                    if s.count <= lengthMeasurementResult.withCommaNonScientific {
                        ret.left = s
                        return ret
                    }
                } else {
                    /// no comma
                    if s.count <= lengthMeasurementResult.withoutComma {
                        ret.left = s
                        return ret
                    }
                }
            }
        }

        /// not a short enough str, use gmp
        let displayGmp: Gmp
        if gmp != nil {
            displayGmp = gmp!
        } else {
            displayGmp = Gmp(str!, bits: _bits)
        }
        if displayGmp.NaN {
            ret.left = "not a number"
            return ret
        }
        if displayGmp.inf {
            ret.left = "too large"
            return ret
        }
        
        if !forceScientific && displayGmp.isZero {
            ret.left = "0"
            return ret
        }
        
        var exponent: mpfr_exp_t = 0
        var charArray: Array<CChar> = Array(repeating: 0, count: lengthMeasurementResult.withCommaNonScientific)
        mpfr_get_str(&charArray, &exponent, 10, lengthMeasurementResult.withCommaNonScientific, &displayGmp.mpfr, MPFR_RNDN)

        var mantissa: String = ""
        for c in charArray {
            if c != 0 {
                let x1 = UInt8(c)
                let x2 = UnicodeScalar(x1)
                let x3 = String(x2)
                mantissa += x3.withCString { String(format: "%s", $0) }
            }
        }

        while mantissa.last == "0" {
            mantissa.removeLast()
        }

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
        if mantissa[0] == "-" {
            mantissa.removeFirst()
            isNegative = true
            withoutComma           = lengthMeasurementResult.withoutComma - 1
            withCommaNonScientific = lengthMeasurementResult.withCommaNonScientific - 1
            withCommaScientific    = lengthMeasurementResult.withCommaScientific - 1
        } else {
            isNegative = false
            withoutComma = lengthMeasurementResult.withoutComma
            withCommaNonScientific = lengthMeasurementResult.withCommaNonScientific
            withCommaScientific    = lengthMeasurementResult.withCommaScientific
        }

        /// Can be displayed as Integer?
        if !forceScientific && mantissa.count <= exponent+1 && exponent+1 <= withoutComma { /// smaller than because of possible trailing zeroes in the integer
            
            /// restore trailing zeros that have been removed
            mantissa = mantissa.padding(toLength: exponent+1, withPad: "0", startingAt: 0)
            // print(mantissa)
            if mantissa.count <= withoutComma {
                ret.left = (isNegative ? "-" : "") + mantissa
                return ret
            }
        }
        
        /// Is floating point XXX,xxx?
        if !forceScientific && exponent >= 0 {
            if exponent < withCommaNonScientific - 1 { /// is the comma visible in the first line and is there at least one digit after the comma?
                var floatString = mantissa
                let index = floatString.index(floatString.startIndex, offsetBy: exponent+1)
                floatString.insert(",", at: index)
                ret.left = floatString
                if floatString.count <= withCommaNonScientific {
                    ret.left = floatString
                } else {
                    ret.left = String(floatString.prefix(withCommaNonScientific))
                    ret.abbreviated = true
                }
                if isNegative { ret.left = "-" + ret.left }
                return ret
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
                    ret.left = floatString
                } else {
                    ret.left = String(floatString.prefix(withCommaNonScientific))
                    ret.abbreviated = true
                }
                if isNegative { ret.left = "-" + ret.left }
                return ret
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
                return ret
            } else {
                /// shorten...
                mantissa = String(mantissa.prefix(withCommaScientific - ret.right!.count))
                ret.abbreviated = true
            }
        }
        ret.left = mantissa
        if isNegative { ret.left = "-" + ret.left }
        return ret
    }
}
