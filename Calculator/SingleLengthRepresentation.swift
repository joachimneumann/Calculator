//
//  Representation.swift
//  Calculator
//
//  Created by Joachim Neumann on 14.03.22.
//

import Foundation


class SingleLengthRepresentation {
    let length: Int
    var left: String
    var right: String?
    var isAbreviated: Bool
    
    init(length l: Int) {
        self.length = l
        left = "0"
        right = nil
        isAbreviated = false
    }
    
    func update(_ number: Number) {
        right = nil
        isAbreviated = false

        let gmp: Gmp

        if let str = number.str {
            if str.count <= length {
                left = str
                return
            } else {
                /// str, but too long for one line
                gmp = Gmp(str)
            }
        } else {
            /// no str? gmp must exist
            gmp = number.gmp!
        }
        
        if gmp.NaN {
            left = "not real"
            return
        }
        if gmp.inf {
            if "too large for me".count <= length {
                left = "too large for me"
            } else {
                left = String("too large for me".prefix(length))
                isAbreviated = true
            }
            return
        }
        
        if gmp.isZero {
            left = "0"
            return
        }
        
        var exponent: mpfr_exp_t = 0
        var charArray: Array<CChar> = Array(repeating: 0, count: length+5)
        mpfr_get_str(&charArray, &exponent, 10, length+5, &gmp.mpfr, MPFR_RNDN)

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
        
        let charactersX: Int
        let negative: Bool
        /// negative? Special treatment
        if mantissa[0] == "-" {
            mantissa.removeFirst()
            negative = true
            charactersX = length - 1
        } else {
            negative = false
            charactersX = length
        }
        
        /// Can be displayed as Integer?
        if mantissa.count <= exponent+1 && exponent+1 <= length { /// smaller than because of possible trailing zeroes in the integer
            
            /// restore trailing zeros that have been removed
            mantissa = mantissa.padding(toLength: exponent+1, withPad: "0", startingAt: 0)

            if mantissa.count <= charactersX {
                left = mantissa
                if negative {
                    left = "-" + left
                }
                return
            }
        }
        
        /// Is floating point XXX,xxx?
        if exponent >= 0 {
            if exponent < charactersX - 2 { /// is the comma visible in the first line and is there at least one digit after the comma?
                var floatString = mantissa
                let index = floatString.index(floatString.startIndex, offsetBy: exponent+1)
                floatString.insert(",", at: index)
                left = floatString
                if floatString.count <= charactersX {
                    left = floatString
                } else {
                    left = String(floatString.prefix(charactersX))
                    isAbreviated = true
                }
                if negative { left = "-" + left }
                return
            }
        }
        
        /// is floating point 0,xxxx
        if exponent < 0 {
            if Double(-1 * exponent - 1) < 0.3 * Double(length) {
                var floatString = mantissa
                for _ in 0..<(-1*exponent - 1) {
                    floatString = "0" + floatString
                }
                floatString = "0," + floatString
                if floatString.count <= charactersX {
                    left = floatString
                } else {
                    left = String(floatString.prefix(charactersX))
                    isAbreviated = true
                }
                if negative { left = "-" + left }
                return
            }
        }


        /// needs to be displayed in scientific notation
        right = "e\(exponent)"
        let indexOne = mantissa.index(mantissa.startIndex, offsetBy: 1)
        mantissa.insert(",", at: indexOne)
        if mantissa.count <= 2 { mantissa += "0" } /// e.g. 1e16 -> 1,e16 -> 1,0e16
        if mantissa.count <= charactersX - right!.count {
            left = mantissa
        } else {
            left = String(mantissa.prefix(charactersX - right!.count))
            isAbreviated = true
        }
        if negative { left = "-" + left }
    }
}
