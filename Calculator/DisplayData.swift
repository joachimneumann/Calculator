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

    var isValidNumber: Bool
    var nonScientific: String?
    var nonScientificIsString: Bool
    var nonScientificIsInteger: Bool
    var nonScientificIsFloat: Bool
    var scientific: Scientific?

    private init(isValidNumber: Bool,
                 nonScientific: String?,
                 nonScientificIsString: Bool,
                 nonScientificIsInteger: Bool,
                 nonScientificIsFloat: Bool,
                 scientific: Scientific?) {
        self.isValidNumber          = isValidNumber
        self.nonScientific          = nonScientific
        self.nonScientificIsString  = nonScientificIsString
        self.nonScientificIsInteger = nonScientificIsInteger
        self.nonScientificIsFloat   = nonScientificIsFloat
        self.scientific             = scientific
        print("DisplayData DONE")
    }
    
    convenience init() {
        self.init(invalid: "invalid")
    }
    
    
    private convenience init(invalid: String) {
        self.init(isValidNumber: false,
                  nonScientific: invalid,
                  nonScientificIsString: true,
                  nonScientificIsInteger: false,
                  nonScientificIsFloat: false,
                  scientific: nil)
    }

    convenience init(number: Number) {
        if let str = number.str {
            let hasComma = str.contains(",")
            let temp = Gmp(str)
            let scientific = DisplayData.scientificFromGmp(data: temp.data(length: TE.lowPrecision))
            self.init(isValidNumber: true,
                      nonScientific: str,
                      nonScientificIsString: true,
                      nonScientificIsInteger: !hasComma,
                      nonScientificIsFloat: hasComma,
                      scientific: scientific)
        } else {
            self.init(gmp: number.gmp)
        }
    }

    private static func scientificFromGmp(data: Gmp.Data) -> Scientific {
        print("DisplayData scientificFromGmp")
        let exponent = "e\(data.exponent)"
        var mantissa = data.mantissa
        let index = mantissa.index(mantissa.startIndex, offsetBy: 1)
        mantissa.insert(",", at: index)
        if mantissa.count <= 2 { mantissa += "0" } /// e.g. 1e16 -> 1,e16 -> 1,0e16

        if data.negative { mantissa = "-" + mantissa }
        return Scientific(mantissa, exponent)
    }
    
    private convenience init(gmp: Gmp) {
        print("DisplayData init(gmp) START")
        if gmp.NaN {
            self.init(invalid: "not real")
            return
        }
        if gmp.inf {
            self.init(invalid: "too large for me")
            return
        }
        
        if gmp.isZero {
            self.init(isValidNumber: true,
                      nonScientific: "0",
                      nonScientificIsString: true,
                      nonScientificIsInteger: false,
                      nonScientificIsFloat: false,
                      scientific: Scientific("0,0", "e0"))
            return
        }
        
        let data = gmp.data(length: TE.lowPrecision)
        
        /// can be perfectly represented as Integer?
        if data.mantissa.count <= data.exponent + 1 && data.exponent < TE.lowPrecision {
            var integerString = data.mantissa
            if integerString.count < data.exponent+1 {
                for _ in 0..<(data.exponent+1-integerString.count) {
                    integerString += "0"
                }
            }
            if data.negative { integerString = "-" + integerString }
            self.init(isValidNumber: true,
                      nonScientific: integerString,
                      nonScientificIsString: false,
                      nonScientificIsInteger: true,
                      nonScientificIsFloat: false,
                      scientific: DisplayData.scientificFromGmp(data: data))
            return
        }
        
        /// represent as float and in scientific notation
        var floatString: String? = nil
        if data.exponent < 0 {
            if -data.exponent < TE.lowPrecision {
                /// abs(number) < 1
                floatString = "0,"
                let zeroes = -data.exponent
                for _ in 1..<zeroes {
                    floatString! += "0"
                }
                floatString! += data.mantissa
                if data.negative { floatString = "-" + floatString! }
            }
        } else if data.exponent < TE.lowPrecision {
            /// abs(number) > 1
            if data.mantissa.count > data.exponent+1 {
                floatString = data.mantissa
                let index = floatString!.index(floatString!.startIndex, offsetBy: data.exponent+1)
                floatString!.insert(",", at: index)
            }
            if data.negative { floatString! = "-" + floatString! }
        }
        self.init(isValidNumber: true,
                  nonScientific: floatString,
                  nonScientificIsString: false,
                  nonScientificIsInteger: false,
                  nonScientificIsFloat: floatString != nil,
                  scientific: DisplayData.scientificFromGmp(data: data))
    }
    
    
    static func == (lhs: DisplayData, rhs: DisplayData) -> Bool {
        if lhs.isValidNumber != rhs.isValidNumber { return false }
        if lhs.scientific    != rhs.scientific    { return false }
        if lhs.nonScientific != rhs.nonScientific  { return false }
        return true
    }
    
}
