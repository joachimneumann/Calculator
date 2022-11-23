//
//  OneLineDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/21/22.
//

import SwiftUI

struct OneLineDisplay: View {
    private let text: String
    private let size: CGSize
    private let largeFont: Font
    private let smallFont: Font
    private let maximalTextLength: Int
    private var fontScaleFactor = 1.0

    init(keyModel: CalculatorModel, size: CGSize, fontShouldScale: Bool) {
        text = keyModel.last
        self.size = size
        let displayFontSize  = round(size.height * 0.79)
        let uiFont = UIFont.monospacedDigitSystemFont(ofSize: displayFontSize, weight: .thin)
        var w = 0.0
        var s = ""
        while w < size.width {
            s.append("0")
            w = s.sizeOf_String(uiFont: uiFont).width
        }
        keyModel.oneLineWithoutCommaLength = s.count - 1
        
        w = 0.0
        s = ","
        while w < size.width {
            s.append("0")
            w = s.sizeOf_String(uiFont: uiFont).width
        }
        keyModel.oneLineWithCommaLength = s.count - 1
        if fontShouldScale {
            fontScaleFactor = 1.5
        }
        smallFont = Font(UIFont.monospacedDigitSystemFont(ofSize: displayFontSize, weight: .thin))
        largeFont = Font(UIFont.monospacedDigitSystemFont(ofSize: displayFontSize*fontScaleFactor, weight: .thin))
        maximalTextLength = text.contains(",") ? keyModel.oneLineWithCommaLength : keyModel.oneLineWithoutCommaLength
    }
    
    var body: some View {
        HStack(spacing: 0.0) {
            Spacer(minLength: 0.0)
            if text.count >= maximalTextLength {
                Text(text)
                    .foregroundColor(Color.white)
                    .scaledToFit()
                    .font(smallFont)
            } else {
                Text(text)
                    .foregroundColor(Color.white)
                    .scaledToFit()
                    .font(largeFont)
                    .minimumScaleFactor(1.0 / fontScaleFactor)
            }
        }
    }
}

struct OneLineDisplay_Previews: PreviewProvider {
    static var previews: some View {
        OneLineDisplay(keyModel: CalculatorModel(), size: CGSize(width: 300, height: 100), fontShouldScale: true)
            .background(Color.black)
    }
}
