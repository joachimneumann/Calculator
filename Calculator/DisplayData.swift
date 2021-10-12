//
//  DisplayData.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

class DisplayData: Equatable {
    
    var isValidNumber: Bool
    var hasMoreDigits: Bool
    var exponent: String?
    var mantissa: String
    
    var string: String {
        var ret = mantissa
        if let exponent = exponent {
            ret += " " + exponent // a space in front of the "e"
        }
        return ret
    }

    static func == (lhs: DisplayData, rhs: DisplayData) -> Bool {
        if lhs.isValidNumber != rhs.isValidNumber { return false }
        if lhs.hasMoreDigits != rhs.hasMoreDigits { return false }
        if lhs.exponent != rhs.exponent           { return false }
        if lhs.mantissa != rhs.mantissa           { return false }
        return true
    }
    
    private init(isValidNumber: Bool,
                 hasMoreDigits: Bool,
                 exponent: String?,
                 content: String) {
        self.isValidNumber = isValidNumber
        self.hasMoreDigits = hasMoreDigits
        self.exponent = exponent
        self.mantissa = content
    }
    convenience init() {
        self.init(invalid: "invalid")
    }
    private convenience init(valid: String) {
        self.init(isValidNumber: true,
                  hasMoreDigits: false,
                  exponent: nil,
                  content: valid)
    }
    private convenience init(invalid: String) {
        self.init(isValidNumber: false,
                  hasMoreDigits: false,
                  exponent: nil,
                  content: invalid)
    }
    convenience init(number: Number, digits: Int, favourScientific: Bool) {
        let gmp = number.str == nil ? number.convertIntoGmp : Gmp(number.str)
        self.init(gmp: gmp, digits: digits, favourScientific: favourScientific)
    }
    convenience init(gmp: Gmp, digits: Int, favourScientific: Bool) {
        print("dd \(digits)")
        if gmp.NaN {
            self.init(invalid: "not a real number")
            return
        }
        if gmp.inf {
            self.init(invalid: "(almost?) infinity")
            return
        }
        
        if gmp.isZero {
            self.init(valid: "0")
            return
        }
        
        let data = gmp.data(length: digits)
        
        var availableDigits = digits
        if data.negative { availableDigits -= 1 }
        
        /// can be perfectly represented as Integer?
        if data.exponent >= 0 &&                        /// number >= 0?
            data.mantissa.count <= data.exponent+1 &&   /// no digits after the dot?
            data.mantissa.count <= availableDigits &&   /// display sifficiently large?
            data.exponent <= availableDigits &&         /// display sifficiently large?
            (!favourScientific || abs(data.exponent) <= 4) {
            var m = data.mantissa
            if m.count < data.exponent+1 {
                for _ in 0..<(data.exponent+1-m.count) {
                    m += "0"
                }
            }
            if data.negative { m = "-" + m }
            self.init(valid: m)
            return
        }
        
        /// can be displayed as  float number? I.e., not scientific notation
        availableDigits = digits
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
                floatString = String(floatString.prefix(availableDigits+1)) /// +1 for the comma
                if data.negative { floatString = "-" + floatString }

                self.init(
                    isValidNumber: true,
                    hasMoreDigits: data.hasMoreDigits,
                    exponent: nil,
                    content: floatString)
                    return
            } else {
                /// abs(number) > 1
                floatString = data.mantissa
                let index = floatString.index(floatString.startIndex, offsetBy: data.exponent+1)
                floatString.insert(",", at: index)
                var ret = String(floatString.prefix(digits+1))
                if data.negative { ret = "-" + ret }

                self.init(
                    isValidNumber: true,
                    hasMoreDigits: data.hasMoreDigits,
                    exponent: nil,
                    content: ret)
                return
            }
        }
        
        /// lets go for scientific notation
        let exponentString = "e\(data.exponent)"
        availableDigits = digits
        if data.negative { availableDigits -= 1 }     /// for "-" The "-" is added later, outside this function
        availableDigits -= exponentString.count

        var scientificString = data.mantissa
        let index = scientificString.index(scientificString.startIndex, offsetBy: 1)
        scientificString.insert(",", at: index)
        if scientificString.count <= 2 { scientificString += "0" } /// e.g. 1e16 -> 1,e16 -> 1,0e16
        
        scientificString = String(scientificString.prefix(availableDigits+1)) // +1 for the comma, which I do not count
        if data.negative { scientificString = "-" + scientificString }

        self.init(isValidNumber: true,
                  hasMoreDigits: true,
                  exponent: "e\(data.exponent)",
                  content: scientificString)
    }
}
