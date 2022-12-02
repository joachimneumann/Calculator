//
//  OneLineDisplayCalibration.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/1/22.
//

import SwiftUI

struct OneLineDisplayCalibration: View {
    let text: String
    let size: CGSize
    let largeFont: Font
    let smallFont: Font
    let maximalTextLength: Int
    var fontScaleFactor = 1.0
    
        init(keyModel: KeyModel, size: CGSize, fontSize: CGFloat, fontShouldScale: Bool) {
            print("OneLineDisplayCalibration init()")
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
            text = keyModel.oneLineP
            smallFont = Font(UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .thin))
            largeFont = Font(UIFont.monospacedDigitSystemFont(ofSize: fontSize*fontScaleFactor, weight: .thin))
            maximalTextLength = text.contains(",") ? keyModel.oneLineWithCommaLength : keyModel.oneLineWithoutCommaLength
            print("oneLineWithCommaLength \(keyModel.oneLineWithCommaLength)")
        }
    var body: some View {
        Rectangle()
            .foregroundColor(Color.black)
    }
}
    
extension String {
    func sizeOf_String(uiFont: UIFont) -> CGSize {
        let fontAttribute = [NSAttributedString.Key.font: uiFont]
        let size = self.size(withAttributes: fontAttribute)  // for Single Line
       return size;
    }
}
