//
//  CalculationResult.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/28/22.
//

import Foundation

struct CalculationResult {
    let number: Number
    let hasChanged: Bool
    let pendingSymbol: String?
    
    var isNull: Bool { number.isNull }
    var isValidNumber: Bool { number.isValid }
    
    func getDisplay(isPreliminary: Bool,
                 screen: Screen,
                 forceScientific: Bool,
                 showAsInteger: Bool,
                 showAsFloat: Bool) async -> Display {
        let data = await number.getDisplayData(
            multipleLines: !isPreliminary && !screen.isPortraitPhone,
            lengths: screen.lengths,
            forceScientific: forceScientific,
            showAsInteger: showAsInteger,
            showAsFloat: showAsFloat)
        let format = DisplayFormat(
            for: data.length,
            withMaxLength: data.maxlength,
            showThreeDots: isPreliminary,
            screen: screen)
        return Display(data: data, format: format)
    }
}
