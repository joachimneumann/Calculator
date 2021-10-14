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
    var sMantissa: String
    var lMantissa: String?
    var exponent: String?

    private init(isValidNumber: Bool,
                 hasMoreDigits: Bool,
                 sMantissa: String,
                 lMantissa: String?,
                 exponent: String?) {
        self.isValidNumber = isValidNumber
        self.hasMoreDigits = hasMoreDigits
        self.sMantissa = sMantissa
        self.lMantissa = lMantissa
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
        
        let data = gmp.data(length: TE.digitsInAllDigitsDisplay)
        
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
            var lMantissa = ""
            if data.exponent < 0 {
                /// abs(number) < 1
                lMantissa = "0," + lMantissa
                let zeroes = -data.exponent
                for _ in 1..<zeroes {
                    lMantissa += "0"
                }
                lMantissa += data.mantissa
                if data.negative { lMantissa = "-" + lMantissa }
                if lMantissa.count > availableDigits {
                    let sMantissa = String(lMantissa.prefix(availableDigits+1)) /// +1 for the comma
                    self.init(
                        isValidNumber: true,
                        hasMoreDigits: data.hasMoreDigits,
                        sMantissa: sMantissa,
                        lMantissa: lMantissa,
                        exponent: nil)
                        return
                } else {
                    self.init(
                        isValidNumber: true,
                        hasMoreDigits: data.hasMoreDigits,
                        sMantissa: lMantissa,
                        lMantissa: nil,
                        exponent: nil)
                        return
                }
            } else {
                /// abs(number) > 1
                lMantissa = data.mantissa
                let index = lMantissa.index(lMantissa.startIndex, offsetBy: data.exponent+1)
                lMantissa.insert(",", at: index)
                if data.negative { lMantissa = "-" + lMantissa }

                if lMantissa.count > availableDigits {
                    let sMantissa = String(lMantissa.prefix(availableDigits+1)) /// +1 for the comma
                    self.init(
                        isValidNumber: true,
                        hasMoreDigits: data.hasMoreDigits,
                        sMantissa: sMantissa,
                        lMantissa: lMantissa,
                        exponent: nil)
                        return
                } else {
                    self.init(
                        isValidNumber: true,
                        hasMoreDigits: data.hasMoreDigits,
                        sMantissa: lMantissa,
                        lMantissa: nil,
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

        var lMantissa = data.mantissa
        let index = lMantissa.index(lMantissa.startIndex, offsetBy: 1)
        lMantissa.insert(",", at: index)
        if lMantissa.count <= 2 { lMantissa += "0" } /// e.g. 1e16 -> 1,e16 -> 1,0e16
        
        if data.negative { lMantissa = "-" + lMantissa }
        let sMantissa = String(lMantissa.prefix(availableDigits+1)) // +1 for the comma, which I do not count

        self.init(isValidNumber: true,
                  hasMoreDigits: true,
                  sMantissa: sMantissa,
                  lMantissa: lMantissa,
                  exponent: "e\(data.exponent)")
    }
    
    private convenience init(valid: String) {
        self.init(isValidNumber: true,
                  hasMoreDigits: false,
                  sMantissa: valid,
                  lMantissa: nil,
                  exponent: nil)
    }
    
    private convenience init(invalid: String) {
        self.init(isValidNumber: false,
                  hasMoreDigits: false,
                  sMantissa: invalid,
                  lMantissa: nil,
                  exponent: nil)
    }

    
    static func == (lhs: DisplayData, rhs: DisplayData) -> Bool {
        if lhs.isValidNumber != rhs.isValidNumber { return false }
        if lhs.hasMoreDigits != rhs.hasMoreDigits { return false }
        if lhs.exponent      != rhs.exponent      { return false }
        if lhs.sMantissa     != rhs.sMantissa     { return false }
        if lhs.lMantissa     != rhs.lMantissa     { return false }
        return true
    }
    
}
