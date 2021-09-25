//
//  DisplayData.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

class DisplayData: Equatable {
    
    var isValidNumber: Bool
    var isNegative: Bool
    var higherPrecisionAvailable: Bool
    var exponent: String?
    var content: String
    
    var string: String {
        var ret = content
        if isNegative { ret = "-" + ret }
        if let exponent = exponent { ret += exponent }
        return ret
    }

    static func == (lhs: DisplayData, rhs: DisplayData) -> Bool {
        if lhs.isValidNumber != rhs.isValidNumber                       { return false }
        if lhs.isNegative != rhs.isNegative                             { return false }
        if lhs.higherPrecisionAvailable != rhs.higherPrecisionAvailable { return false }
        if lhs.exponent != rhs.exponent                                 { return false }
        if lhs.content != rhs.content                                   { return false }
        return true
    }
    private init(isValidNumber: Bool,
                 isNegative: Bool,
                 higherPrecisionAvailable: Bool,
                 exponent: String?,
                 content: String) {
        self.isValidNumber = isValidNumber
        self.isNegative = isNegative
        self.higherPrecisionAvailable = higherPrecisionAvailable
        self.exponent = exponent
        self.content = content
    }
    convenience init() {
        self.init(invalid: "invalid")
    }
    private convenience init(valid: String, negative: Bool) {
        self.init(isValidNumber: true,
                  isNegative: negative,
                  higherPrecisionAvailable: false,
                  exponent: nil,
                  content: valid)
    }
    private convenience init(invalid: String) {
        self.init(isValidNumber: false,
                  isNegative: false,
                  higherPrecisionAvailable: false,
                  exponent: nil,
                  content: invalid)
    }
    convenience init(gmp: Gmp, digits: Int) {
        if gmp.NaN {
            self.init(invalid: "not a real number")
            return
        }
        if gmp.inf {
            self.init(invalid: "(almost?) infinity")
            return
        }
        
        if gmp.isZero {
            self.init(valid: "0", negative: false)
            return
        }
        
        let data = gmp.data(length: digits)
        
        /// can be perfectly represented as Integer?
        var availableDigits = digits
        if data.negative { availableDigits -= 1 }
        
        if data.exponent >= 0 &&                      /// number >= 0?
            data.mantissa.count <= data.exponent+1 &&   /// no digits after the dot?
            data.exponent <= availableDigits { /// display sifficiently large?
            var m = data.mantissa
            if m.count < data.exponent+1 {
                for _ in 0..<(data.exponent+1-m.count) {
                    m += "0"
                }
            }
            self.init(valid: m, negative: data.negative)
            return
        }
        
        /// can be displayed as  float number? I.e., not scientific notation
        availableDigits = digits
        if data.exponent < 0 { availableDigits -= 1 } /// for "0" in "0,"
        availableDigits -= 1                          /// for ","
        if data.negative { availableDigits -= 1 }     /// for "-" The "-" is added later, outside this function
        
        if abs(data.exponent) <= availableDigits - 2 { /// display sifficiently large?
            var floatString = ""
            if data.exponent < 0 {
                /// abs(number) < 1
                floatString = "0," + floatString
                let zeroes = -data.exponent
                for _ in 1..<zeroes {
                    floatString += "0"
                }
                floatString += data.mantissa
                floatString = String(floatString.prefix(availableDigits))
                self.init(
                    isValidNumber: true,
                    isNegative: data.negative,
                    higherPrecisionAvailable: data.hasMoreDigits,
                    exponent: nil,
                    content: floatString)
                    return
            } else {
                /// abs(number) > 1
                floatString = data.mantissa
                let index = floatString.index(floatString.startIndex, offsetBy: data.exponent+1)
                floatString.insert(",", at: index)
                self.init(
                    isValidNumber: true,
                    isNegative: data.negative,
                    higherPrecisionAvailable: data.hasMoreDigits,
                    exponent: nil,
                    content: floatString)
                return
            }
        }
        
        /// lets go for scientific notation
        let exponentString = "e\(data.exponent)"
        availableDigits = digits
        availableDigits -= 1                          /// for ","
        if data.negative { availableDigits -= 1 }     /// for "-" The "-" is added later, outside this function
        availableDigits -= exponentString.count

        var scientificString = data.mantissa
        let index = scientificString.index(scientificString.startIndex, offsetBy: 1)
        scientificString.insert(",", at: index)
        if scientificString.count <= 2 { scientificString += "0" } /// e.g. 1e16 -> 1,e16 -> 1,0e16
        
        scientificString = String(scientificString.prefix(availableDigits))
        self.init(isValidNumber: true,
                  isNegative: data.negative,
                  higherPrecisionAvailable: true,
                  exponent: "e\(data.exponent)",
                  content: scientificString)
    }
}
