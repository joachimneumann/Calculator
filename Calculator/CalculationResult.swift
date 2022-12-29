//
//  CalculationResult.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/28/22.
//

import Foundation

struct CalculationResult {
    let number: Number?
    let pendingSymbol: String?
    
    var isNull: Bool { number?.isNull ?? false }
    var isValidNumber: Bool { number?.isValid ?? false }
}
