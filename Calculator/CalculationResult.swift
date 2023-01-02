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
    
    var isNull: Bool { number.isNull }
    var isValidNumber: Bool { number.isValid }
        
    func getDisplay(keyPressResponder: KeyPressResponder, screen: Screen) async -> Display {
        return await Task.detached {
            let data = number.getDisplayData(
                multipleLines: !keyPressResponder.isPreliminary && !screen.isPortraitPhone,
                lengths: screen.lengths,
                forceScientific: keyPressResponder.forceScientific,
                showAsInteger: keyPressResponder.showAsInteger,
                showAsFloat: keyPressResponder.showAsFloat)
            let format = DisplayFormat(
                for: data.length,
                withMaxLength: data.maxlength,
                showThreeDots: keyPressResponder.isPreliminary,
                screen: screen)
            return Display(data: data, format: format)
        }.value
    }
}
