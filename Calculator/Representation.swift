////
////  Representation.swift
////  Calculator
////
////  Created by Joachim Neumann on 14.03.22.
////
//
//import Foundation
//
//
//class Representation {
//    let totalCharacters: Int
//    var left: String
//    var right: String?
//    var abreviated: Bool // shall the + be enabled or not?
//    let singleLine: Bool
//    
//    init(characters: Int, singleLine: Bool) {
//        self.totalCharacters = characters
//        left = "0"
//        right = nil
//        abreviated = false
//        self.singleLine = singleLine
//    }
//    
//    func update(_ number: Number) {
//        right = nil
//        abreviated = false
//
//        let gmp: Gmp
//
////        if let str = number.str {
////            if str.count <= characters {
////                left = str
////                return
////            } else {
////                /// str, but too long for one line
////                gmp = Gmp(str)
////            }
////        } else {
////            /// no str? gmp must exist
////            gmp = number.gmp!
////        }
//        
//        if let str = number.str {
//                gmp = Gmp(str)
//        } else {
//            gmp = number.gmp!
//        }
//        
//        
//        if gmp.NaN {
//            left = "not real"
//            return
//        }
//        if gmp.inf {
//            left = "too large"
//            return
//        }
//        
//        if gmp.isZero {
//            left = "0"
//            return
//        }
//        
//        var exponent: mpfr_exp_t = 0
//        var charArray: Array<CChar> = Array(repeating: 0, count: totalCharacters+5)
//        mpfr_get_str(&charArray, &exponent, 10, totalCharacters+5, &gmp.mpfr, MPFR_RNDN)
//
//        var mantissa: String = ""
//        for c in charArray {
//            if c != 0 {
//                let x1 = UInt8(c)
//                let x2 = UnicodeScalar(x1)
//                let x3 = String(x2)
//                mantissa += x3.withCString { String(format: "%s", $0) }
//            }
//        }
//
//        while mantissa.last == "0" {
//            mantissa.removeLast()
//        }
//
//        if mantissa == "" {
//            mantissa = "0"
//        } else {
//            exponent = exponent - 1
//        }
//        
//        let characters: Int
//        /// negative? Special treatment
//        let isNegative: Bool
//        if mantissa[0] == "-" {
//            mantissa.removeFirst()
//            isNegative = true
//            characters = totalCharacters - 1
//        } else {
//            isNegative = false
//            characters = totalCharacters
//        }
//
//        /// Can be displayed as Integer?
//        if mantissa.count <= exponent+1 && exponent+1 <= characters { /// smaller than because of possible trailing zeroes in the integer
//            
//            /// restore trailing zeros that have been removed
//            mantissa = mantissa.padding(toLength: exponent+1, withPad: "0", startingAt: 0)
//            print(mantissa)
//            if mantissa.count <= characters {
//                left = (isNegative ? "-" : "") + mantissa
//                return
//            }
//        }
//        
//
//        /// Is floating point XXX,xxx?
//        if exponent >= 0 {
//            if exponent < characters { /// is the comma visible in the first line and is there at least one digit after the comma?
//                var floatString = mantissa
//                let index = floatString.index(floatString.startIndex, offsetBy: exponent+1)
//                floatString.insert(",", at: index)
//                left = floatString
//                if floatString.count <= characters {
//                    left = floatString
//                } else {
//                    left = String(floatString.prefix(characters))
//                    abreviated = true
//                }
//                if isNegative { left = "-" + left }
//                return
//            }
//        }
//        
//        /// is floating point 0,xxxx
//        if exponent < 0 {
//            if -1 * exponent < characters - 1 {
//                var floatString = mantissa
//                for _ in 0..<(-1*exponent - 1) {
//                    floatString = "0" + floatString
//                }
//                floatString = "0," + floatString
//                if floatString.count <= characters {
//                    left = floatString
//                } else {
//                    left = String(floatString.prefix(characters))
//                    abreviated = true
//                }
//                if isNegative { left = "-" + left }
//                return
//            }
//        }
//
//
//        /// needs to be displayed in scientific notation
//        right = "e\(exponent)"
//        let indexOne = mantissa.index(mantissa.startIndex, offsetBy: 1)
//        mantissa.insert(",", at: indexOne)
//        if mantissa.count <= 2 { mantissa += "0" } /// e.g. 1e16 -> 1,e16 -> 1,0e16
//        if mantissa.count <= characters - right!.count {
//            left = mantissa
//        } else {
//            left = String(mantissa.prefix(characters - right!.count))
//            abreviated = true
//        }
//        if isNegative { left = "-" + left }
//    }
//}
