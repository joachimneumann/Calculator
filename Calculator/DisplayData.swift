//
//  DisplayData.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct DisplayData: Equatable {
    let isValidNumber: Bool
    let isNegative: Bool
    let higherPrecisionAvailable: Bool
    let exponent: String?
    let content: String
    var string: String { isNegative ? "-"+content : content }
    init(invalid: String) {
        isValidNumber = false
        isNegative = false
        higherPrecisionAvailable = false
        exponent = nil
        content = invalid
    }
    init(valid: String) {
        isValidNumber = true
        isNegative = false
        higherPrecisionAvailable = true
        exponent = nil
        content = valid
    }
    init(
        isValidNumber: Bool,
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
}
