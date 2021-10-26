//
//  DisplayData.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct Scientific: Equatable {
    let mantissa: String
    let exponent: String
    
    var combined: String { mantissa + " " + exponent }
    init(_ mantissa: String, _ exponent: String) {
        self.mantissa = mantissa
        self.exponent = exponent
    }
    
    static func == (lhs: Scientific, rhs: Scientific) -> Bool {
        if lhs.mantissa != rhs.mantissa { return false }
        if lhs.exponent != rhs.exponent { return false }
        return true
    }

}

class DisplayData: Equatable {
    /// This value will be determined in Display()
    static var digitsInOneLine: Int = .max
    static let digitsInExpandedDisplay: Int = 200
    
    private var _nonScientific: String?
    private var _scientific: Scientific?

    var isNonScientific: Bool   { _nonScientific != nil }
    var nonScientific: String?  { _nonScientific }
    var scientific: Scientific? { _scientific }

    private init(_ str: String) {
        _nonScientific = str
        _scientific    = nil
    }
    private init(_ scientific: Scientific) {
        _nonScientific = nil
        _scientific    = scientific
    }

    convenience init(number: Number) {
        let gmp: Gmp
        if let str = number.str {
            if str.count <= DisplayData.digitsInOneLine {
                self.init(str)
                return
            } else {
                /// str, but too long for one line
                gmp = Gmp(str)
            }
        } else {
            gmp = number.gmp!
        }

        print("DisplayData init(gmp) START")
        if gmp.NaN {
            self.init("not real")
            return
        }
        if gmp.inf {
            self.init("too large for me")
            return
        }
        
        if gmp.isZero {
            self.init("0")
            return
        }
        
        print("data 1")
        let data = gmp.data(DisplayData.digitsInExpandedDisplay)
        print("data 2")

        /// can be perfectly represented as Integer in one line?
        
        /// mantissa not too long for the exponent?
        if data.mantissa.count <= data.exponent + 1 {
            /// the integer fits into one line?
            if data.exponent < DisplayData.digitsInOneLine {
                var integerString = data.mantissa
                /// zero padding
                for _ in 0..<(data.exponent+1-integerString.count) {
                    integerString += "0"
                }
                if data.negative { integerString = "-" + integerString }
                if integerString.count <= DisplayData.digitsInOneLine {
                    self.init(integerString)
                    return
                }
            }
        }
        
        /// Can be represent as float?
        if data.exponent >= 0 {
            /// X,xxxx
            if data.exponent < DisplayData.digitsInOneLine - 3 {
                /// can be displayed
                var floatString = data.mantissa
                let index = floatString.index(floatString.startIndex, offsetBy: data.exponent+1)
                floatString.insert(",", at: index)
                if data.negative { floatString = "-" + floatString }
                self.init(floatString)
                return
            }
        } else {
            /// 0,xxxx
            if -data.exponent < DisplayData.digitsInOneLine - 3 {
                /// can be displayed
                var floatString = "0,"
                let zeroes = -data.exponent
                for _ in 1..<zeroes {
                    floatString += "0"
                }
                floatString += data.mantissa
                self.init(floatString)
                return
            }
        }
        
        /// needs to be displayed in scientific notation
        let exponent = "e\(data.exponent)"
        var mantissa = data.mantissa
        let indexOne = mantissa.index(mantissa.startIndex, offsetBy: 1)
        mantissa.insert(",", at: indexOne)
        if mantissa.count <= 2 { mantissa += "0" } /// e.g. 1e16 -> 1,e16 -> 1,0e16
        if data.negative { mantissa = "-" + mantissa }
        self.init(Scientific(mantissa, exponent))
        return
    }
    
    
    static func == (lhs: DisplayData, rhs: DisplayData) -> Bool {
        if lhs._scientific    != rhs._scientific    { return false }
        if lhs._nonScientific != rhs._nonScientific  { return false }
        return true
    }
    
}
