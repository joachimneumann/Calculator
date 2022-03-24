//
//  MultilineDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 14.03.22.
//

import Foundation


class MultilineDisplay {
    let charactersInOneLine: Int
    let precision: Int
    var oneLine: String
    var left: String
    var right: String?
    var moreThanOneLine: Bool
    
    init(charactersInOneLine: Int, precision: Int) {
        self.charactersInOneLine = charactersInOneLine
        self.precision = precision
        oneLine = "0"
        left = "0"
        right = nil
        moreThanOneLine = false
    }
    
    private func oneLine(_ s: String) {
        oneLine = s
        left = s
        right = nil
        moreThanOneLine = false
    }

    func update(_ number: Number) {
        let gmp: Gmp
        if let str = number.str {
            if str.count <= charactersInOneLine {
                oneLine(str)
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
            oneLine("not real")
            return
        }
        if gmp.inf {
            oneLine("too large for me")
            return
        }
        
        if gmp.isZero {
            oneLine("0")
            return
        }
        
        var exponent: mpfr_exp_t = 0
        var charArray: Array<CChar> = Array(repeating: 0, count: precision+5)
        mpfr_get_str(&charArray, &exponent, 10, precision+5, &gmp.mpfr, MPFR_RNDN)

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
        
        let charactersInOneLineX: Int
        let negative: Bool
        /// negative? Special treatment
        if mantissa[0] == "-" {
            mantissa.removeFirst()
            negative = true
            charactersInOneLineX = charactersInOneLine - 1
        } else {
            negative = false
            charactersInOneLineX = charactersInOneLine
        }
        
        /// Can be displayed as Integer?
        if mantissa.count <= exponent+1 && mantissa.count <= precision { /// smaller than because of possible trailing zeroes in the integer
            
            /// restore trailing zeros that have been removed
            mantissa = mantissa.padding(toLength: exponent+1, withPad: "0", startingAt: 0)

            if mantissa.count <= charactersInOneLineX {
                oneLine(mantissa)
            } else {
                /// multiline integer
                left = mantissa
                right = nil
                let oneLineExponent = "e\(exponent)"
                oneLine = String(mantissa.prefix(charactersInOneLineX - oneLineExponent.count - 1)) + oneLineExponent
                let indexOne = oneLine.index(oneLine.startIndex, offsetBy: 1)
                oneLine.insert(",", at: indexOne)
                moreThanOneLine = true
            }
            if negative {
                left = "-" + left
                oneLine = "-" + oneLine
            }
            return
        }
        
        /// Is floating point?
        if exponent >= 0 {
            /// XXX,xxx
            if exponent < charactersInOneLineX - 2 { /// is the comma visible in the first line and is there at least one digit after the comma?
                var floatString = mantissa
                let index = floatString.index(floatString.startIndex, offsetBy: exponent+1)
                floatString.insert(",", at: index)
                left = floatString
                oneLine = String(floatString.prefix(charactersInOneLineX))
                if negative {
                    left = "-" + left
                    oneLine = "-" + oneLine
                }
                return
            }
        }
        left = "?"
        right = "?"
        oneLine = "?"
        
        /// can be perfectly represented as Integer in one line?
//        if mantissa.count <= charactersInOneLine &&
        
//        /// mantissa not too long for the exponent?
//        if data.mantissa.count <= data.exponent + 1 {
//            /// the integer fits into one line?
//            if data.exponent < DisplayData.digitsInOneLine {
//                var integerString = data.mantissa
//                /// zero padding
//                for _ in 0..<(data.exponent+1-integerString.count) {
//                    integerString += "0"
//                }
//                if data.negative { integerString = "-" + integerString }
//                if integerString.count <= DisplayData.digitsInOneLine {
//                    set(integerString)
//                    return
//                }
//            }
//        }
//        
//        /// Can be represent as float?
//        if data.exponent >= 0 {
//            /// X,xxxx
//            if data.exponent < DisplayData.digitsInOneLine - 3 {
//                /// can be displayed
//                var floatString = data.mantissa
//                let index = floatString.index(floatString.startIndex, offsetBy: data.exponent+1)
//                floatString.insert(",", at: index)
//                if data.negative { floatString = "-" + floatString }
//                set(floatString)
//                return
//            }
//        } else {
//            /// 0,xxxx
//            if -data.exponent < DisplayData.digitsInOneLine - 3 {
//                /// can be displayed
//                var floatString = "0,"
//                let zeroes = -data.exponent
//                for _ in 1..<zeroes {
//                    floatString += "0"
//                }
//                floatString += data.mantissa
//                if data.negative { floatString = "-" + floatString }
//                set(floatString)
//                return
//            }
//        }
//        
//        /// needs to be displayed in scientific notation
//        let exponent = "e\(data.exponent)"
//        var mantissa = data.mantissa
//        let indexOne = mantissa.index(mantissa.startIndex, offsetBy: 1)
//        mantissa.insert(",", at: indexOne)
//        if mantissa.count <= 2 { mantissa += "0" } /// e.g. 1e16 -> 1,e16 -> 1,0e16
//        if data.negative { mantissa = "-" + mantissa }
//        set(Scientific(mantissa, exponent))
    }
}
