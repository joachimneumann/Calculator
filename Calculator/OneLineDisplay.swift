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

    init(keyModel: KeyModel, size: CGSize, fontSize: CGFloat, fontShouldScale: Bool) {
         print("OneLineDisplay init")
        self.size = size
        let uiFont = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .thin)
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
        text = keyModel.oneLine
        smallFont = Font(UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .thin))
        largeFont = Font(UIFont.monospacedDigitSystemFont(ofSize: fontSize*fontScaleFactor, weight: .thin))
        maximalTextLength = text.contains(",") ? keyModel.oneLineWithCommaLength : keyModel.oneLineWithoutCommaLength
    }
    
    var body: some View {
        let _ = print("OneLineDisplay body")
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
        OneLineDisplay(keyModel: KeyModel(), size: CGSize(width: 300, height: 100.0), fontSize: round(100.0 * 0.79), fontShouldScale: true)
            .background(Color.black)
    }
}

extension String {
    func sizeOf_String(uiFont: UIFont) -> CGSize {
        let fontAttribute = [NSAttributedString.Key.font: uiFont]
        let size = self.size(withAttributes: fontAttribute)  // for Single Line
       return size;
    }
}
