//
//  CalculationResult.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/28/22.
//

import Foundation

struct CalculationResult {
    let number: Number
    private let hasChanged: Bool
    
    init() {
        self.init(number: Number("0", precision: 10), hasChanged: false)
    }
    
    init(number: Number, hasChanged: Bool) {
        self.number = number
        self.hasChanged = hasChanged
    }
    
    var isNull: Bool { number.isNull }
    var isValidNumber: Bool { number.isValid }
    
    func getDisplay(keyPressResponder: KeyPressResponder, screen: Screen) async -> Display {
        return await Task.detached {
            let data = number.getDisplayData(
                multipleLines: !screen.isPortraitPhone,
                lengths: screen.lengths,
                forceScientific: keyPressResponder.forceScientific,
                showAsInteger: keyPressResponder.showAsInteger,
                showAsFloat: keyPressResponder.showAsFloat)
            let format = DisplayFormat(
                for: data.length,
                withMaxLength: data.maxlength,
                showThreeDots: false,
                screen: screen)
            return Display(data: data, format: format)
        }.value
    }
}
