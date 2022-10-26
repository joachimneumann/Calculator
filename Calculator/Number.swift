//
//  Number.swift
//  Calculator
//
//  Created by Joachim Neumann on 10/26/21.
//

import Foundation

struct Oneliner {
    var left: String
    var right: String?
    var abreviated: Bool // shall the + be enabled or not?
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
    
    func oneLiner(length: Int) -> Oneliner {
        var ret = Oneliner(left: "0", abreviated: false)
        ret.right = nil
        ret.abreviated = false
        
        guard let oneLinerStr = str, oneLinerStr.count <= length else {
            /// the number is not a nice and short string
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
            var charArray: Array<CChar> = Array(repeating: 0, count: length+5)
            mpfr_get_str(&charArray, &exponent, 10, length+5, &oneLinerGmp.mpfr, MPFR_RNDN)

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
            
            let characters: Int
            /// negative? Special treatment
            let isNegative: Bool
            if mantissa[0] == "-" {
                mantissa.removeFirst()
                isNegative = true
                characters = length - 1
            } else {
                isNegative = false
                characters = length
            }

            /// Can be displayed as Integer?
            if mantissa.count <= exponent+1 && exponent+1 <= characters { /// smaller than because of possible trailing zeroes in the integer
                
                /// restore trailing zeros that have been removed
                mantissa = mantissa.padding(toLength: exponent+1, withPad: "0", startingAt: 0)
                print(mantissa)
                if mantissa.count <= characters {
                    ret.left = (isNegative ? "-" : "") + mantissa
                    return ret
                }
            }
            

            /// Is floating point XXX,xxx?
            if exponent >= 0 {
                if exponent < characters { /// is the comma visible in the first line and is there at least one digit after the comma?
                    var floatString = mantissa
                    let index = floatString.index(floatString.startIndex, offsetBy: exponent+1)
                    floatString.insert(",", at: index)
                    ret.left = floatString
                    if floatString.count <= characters {
                        ret.left = floatString
                    } else {
                        ret.left = String(floatString.prefix(characters))
                        ret.abreviated = true
                    }
                    if isNegative { ret.left = "-" + ret.left }
                    return ret
                }
            }
            
            /// is floating point 0,xxxx
            if exponent < 0 {
                if -1 * exponent < characters - 1 {
                    var floatString = mantissa
                    for _ in 0..<(-1*exponent - 1) {
                        floatString = "0" + floatString
                    }
                    floatString = "0," + floatString
                    if floatString.count <= characters {
                        ret.left = floatString
                    } else {
                        ret.left = String(floatString.prefix(characters))
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
            if mantissa.count <= characters - ret.right!.count {
                ret.left = mantissa
            } else {
                ret.left = String(mantissa.prefix(characters - ret.right!.count))
                ret.abreviated = true
            }
            if isNegative { ret.left = "-" + ret.left }
            return ret
        }
        
        ret.left = oneLinerStr
        return ret
        
    }
}
