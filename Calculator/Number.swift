//
//  Number.swift
//  Calculator
//
//  Created by Joachim Neumann on 10/26/21.
//

import Foundation

struct OneLiner {
    var left: String
    var right: String? = nil
    var abreviated: Bool // shall the + be enabled or not?
}

struct MultipleLiner {
    var left: String
    var right: String? = nil
    var abreviated: Bool // show a message that there is more?
}



class Number: CustomDebugStringConvertible {
    private var _str: String?
    private var _gmp: Gmp?
    
    var isStr: Bool { _str != nil }
    var str: String? { return _str }
    var gmp: Gmp? { return _gmp }
    
    var isValid: Bool {
        if isStr { return true }
        return _gmp!.isValid
    }
    func copy() -> Number {
        if isStr {
            return Number(str!)
        } else {
            return Number(gmp!.copy())
        }
    }
    func toGmp() {
        if isStr {
            _gmp = Gmp(str!)
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
    
    init(_ str: String) {
        _str = str
        _gmp = nil
    }
    init(_ gmp: Gmp) {
        _str = nil
        _gmp = gmp
    }
    convenience init() {
        self.init("0")
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
    
    func multipleLiner(length: Int) -> MultipleLiner {
        var ret = MultipleLiner(left: "0", abreviated: false)
        guard let multipleLinerStr = str, multipleLinerStr.count <= length else {
            return ret
        }
        ret.left = multipleLinerStr
        return ret
    }
    
    func singleLine(len: Int) -> String {
        let ret: String
        let oneLiner = oneLiner(withoutComma: len, withComma: len)
        if let right = oneLiner.right {
            ret = oneLiner.left+right
        } else {
            ret = oneLiner.left
        }
        return ret
    }
    func oneLiner(withoutComma: Int, withComma: Int) -> OneLiner {
        var ret = OneLiner(left: "0", abreviated: false)
        ret.abreviated = false
        if let oneLinerStr = str {
            if oneLinerStr.contains(",") {
                if oneLinerStr.count <= withComma {
                    ret.left = oneLinerStr
                    return ret
                }
            } else {
                /// no comma
                if oneLinerStr.count <= withoutComma {
                    ret.left = oneLinerStr
                    return ret
                }
            }
        }

        /// not a short enough str, use gmp
        let oneLinerGmp: Gmp
        if gmp != nil {
            oneLinerGmp = gmp!
        } else {
            oneLinerGmp = Gmp(str!)
        }
        if oneLinerGmp.NaN {
            ret.left = "not real"
            return ret
        }
        if oneLinerGmp.inf {
            ret.left = "too large"
            return ret
        }
        
        if oneLinerGmp.isZero {
            ret.left = "0"
            return ret
        }
        
        var exponent: mpfr_exp_t = 0
        var charArray: Array<CChar> = Array(repeating: 0, count: withComma)
        mpfr_get_str(&charArray, &exponent, 10, withComma, &oneLinerGmp.mpfr, MPFR_RNDN)

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
        
        let charactersWithoutComma: Int
        let charactersWithComma: Int
        /// negative? Special treatment
        let isNegative: Bool
        if mantissa[0] == "-" {
            mantissa.removeFirst()
            isNegative = true
            charactersWithoutComma = withoutComma - 1
            charactersWithComma = withComma - 1
        } else {
            isNegative = false
            charactersWithoutComma = withoutComma
            charactersWithComma = withComma
        }

        /// Can be displayed as Integer?
        if mantissa.count <= exponent+1 && exponent+1 <= charactersWithoutComma { /// smaller than because of possible trailing zeroes in the integer
            
            /// restore trailing zeros that have been removed
            mantissa = mantissa.padding(toLength: exponent+1, withPad: "0", startingAt: 0)
            print(mantissa)
            if mantissa.count <= charactersWithoutComma {
                ret.left = (isNegative ? "-" : "") + mantissa
                return ret
            }
        }
        
        /// Is floating point XXX,xxx?
        if exponent >= 0 {
            if exponent < charactersWithComma - 1 { /// is the comma visible in the first line and is there at least one digit after the comma?
                var floatString = mantissa
                let index = floatString.index(floatString.startIndex, offsetBy: exponent+1)
                floatString.insert(",", at: index)
                ret.left = floatString
                if floatString.count <= charactersWithComma {
                    ret.left = floatString
                } else {
                    ret.left = String(floatString.prefix(charactersWithComma))
                    ret.abreviated = true
                }
                if isNegative { ret.left = "-" + ret.left }
                return ret
            }
        }
        
        /// is floating point 0,xxxx
        if exponent < 0 {
            if -1 * exponent < charactersWithComma - 1 {
                var floatString = mantissa
                for _ in 0..<(-1*exponent - 1) {
                    floatString = "0" + floatString
                }
                floatString = "0," + floatString
                if floatString.count <= charactersWithComma {
                    ret.left = floatString
                } else {
                    ret.left = String(floatString.prefix(charactersWithComma))
                    ret.abreviated = true
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
        if mantissa.count <= charactersWithComma - ret.right!.count {
            ret.left = mantissa
        } else {
            ret.left = String(mantissa.prefix(charactersWithComma - ret.right!.count))
            ret.abreviated = true
        }
        if isNegative { ret.left = "-" + ret.left }
        return ret
    }
}
