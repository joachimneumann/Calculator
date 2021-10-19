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
    var mantissa: String
    var exponent: String?

    private init(isValidNumber: Bool,
                 hasMoreDigits: Bool,
                 mantissa: String,
                 exponent: String?) {
        self.isValidNumber = isValidNumber
        self.hasMoreDigits = hasMoreDigits
        self.mantissa = mantissa
        self.exponent = exponent
    }
    
    convenience init() {
        self.init(invalid: "invalid")
    }
    
    convenience init(number: Number,
                     digits: Int) {
        if let str = number.str {
            if str.count <= digits {
                self.init(valid: str)
            } else {
                let gmp = Gmp(str)
                self.init(gmp: gmp,
                          digits: digits)
            }
        } else {
            self.init(gmp: number.gmp,
                      digits: digits)
        }
    }
    
    private convenience init(gmp: Gmp,
                     digits: Int) {
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
            data.exponent <= availableDigits {
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
        if data.negative { availableDigits -= 1 }     /// for "-". The "-" is added to the string later
        
        if abs(data.exponent) <= availableDigits - 2 { /// display sifficiently large?
            var mantissa = ""
            if data.exponent < 0 {
                /// abs(number) < 1
                mantissa = "0," + mantissa
                let zeroes = -data.exponent
                for _ in 1..<zeroes {
                    mantissa += "0"
                }
                mantissa += data.mantissa
                if data.negative { mantissa = "-" + mantissa }
                if zeroes < availableDigits+2 {
                    self.init(
                        isValidNumber: true,
                        hasMoreDigits: data.hasMoreDigits,
                        mantissa: mantissa,
                        exponent: nil)
                        return
                }
            } else {
                /// abs(number) > 1
                mantissa = data.mantissa
                let index = mantissa.index(mantissa.startIndex, offsetBy: data.exponent+1)
                mantissa.insert(",", at: index)
                if data.negative { mantissa = "-" + mantissa }

                if mantissa.count < availableDigits {
                    self.init(
                        isValidNumber: true,
                        hasMoreDigits: data.hasMoreDigits,
                        mantissa: mantissa,
                        exponent: nil)
                        return
                }
            }
        }
        
        /// --> scientific notation
        let exponentString = "e\(data.exponent)"
        availableDigits = digits
        if data.negative { availableDigits -= 1 }     /// for "-" The "-" is added later, outside this function
        availableDigits -= exponentString.count

        var mantissa = data.mantissa
        let index = mantissa.index(mantissa.startIndex, offsetBy: 1)
        mantissa.insert(",", at: index)
        if mantissa.count <= 2 { mantissa += "0" } /// e.g. 1e16 -> 1,e16 -> 1,0e16
        
        if data.negative { mantissa = "-" + mantissa }
        //let mantissa = String(lMantissa.prefix(availableDigits+1)) // +1 for the comma, which I do not count

        self.init(isValidNumber: true,
                  hasMoreDigits: true,
                  mantissa: mantissa,
                  exponent: "e\(data.exponent)")
    }
    
    private convenience init(valid: String) {
        self.init(isValidNumber: true,
                  hasMoreDigits: false,
                  mantissa: valid,
                  exponent: nil)
    }
    
    private convenience init(invalid: String) {
        self.init(isValidNumber: false,
                  hasMoreDigits: false,
                  mantissa: invalid,
                  exponent: nil)
    }

    
    static func == (lhs: DisplayData, rhs: DisplayData) -> Bool {
        if lhs.isValidNumber != rhs.isValidNumber { return false }
        if lhs.hasMoreDigits != rhs.hasMoreDigits { return false }
        if lhs.exponent      != rhs.exponent      { return false }
        if lhs.mantissa      != rhs.mantissa      { return false }
        return true
    }
    
}
