//
//  LongDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct LongDisplay: View {
    private let mantissa: String
    private let exponent: String?
    private let abbreviated: Bool
    let keyModel: KeyModel
    let fontSize: CGFloat
    let isCopyingOrPasting: Bool
    let color: Color
    let highlightColor = Color(
        red:    118.0/255.0,
        green:  250.0/255.0,
        blue:   113.0/255.0)

    init(keyModel: KeyModel, fontSize: CGFloat) {
        self.keyModel = keyModel
        self.fontSize = fontSize
        let multipleLines = keyModel.multipleLines
        abbreviated = multipleLines.abbreviated
        mantissa = multipleLines.left + (abbreviated ? "..." : "")
        exponent = multipleLines.right
//        private var abbreviated = false
//        text = multipleLines.oneLine(showAbbreviation: true)
//        if multipleLines.abbreviated {
//            if keyModel.precision > C.maxDigitsInLongDisplay {
//                abbreviated = true
//                print("precision \(keyModel.precision) C.maxDigitsInLongDisplay \(C.maxDigitsInLongDisplay) text.count \(text.count)")
//            }
//        }
        isCopyingOrPasting = false
        color = Color(uiColor: C.digitColors.textColor)
    }
    
    var body: some View {
            HStack(alignment: .top, spacing: 0.0) {
                ScrollView(.vertical) {
                    Text(mantissa)
                        .font(Font(UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .thin)))
                        .minimumScaleFactor(1.0)
                        .foregroundColor(isCopyingOrPasting ? highlightColor : color)
                        .lineLimit(100)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .multilineTextAlignment(.trailing)
                    if abbreviated {
                        HStack() {
                            Spacer()
                            Text("This result is abbreviated to \(C.maxDigitsInLongDisplay.useWords) significant digits. To get up to \(keyModel.precision.useWords) significant digits use copy")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                if exponent != nil {
                    Text(exponent!)
                        .font(Font(UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .thin)))
                        .minimumScaleFactor(1.0)
                        .foregroundColor(isCopyingOrPasting ? highlightColor : color)
                        .lineLimit(100)
                        .multilineTextAlignment(.trailing)
                }
            }
    }
}

/*
 struct MultiLineDisplay: View {
    let color: Color
    let text: String
    let uiFont: UIFont
    let height: CGFloat
    let isCopyingOrPasting: Bool
    let highlightColor = Color(
        red:    118.0/255.0,
        green:  250.0/255.0,
        blue:   113.0/255.0)

    init(brain: Brain, t: TE, isCopyingOrPasting: Bool) {
        self.color = Color.white
        self.isCopyingOrPasting = isCopyingOrPasting
        self.text = brain.last.singleLine(len: brain.precision)
        self.uiFont = t.displayUIFont
        self.height = t.multipleLineDisplayHeight
    }
    
    var body: some View {
        ScrollView {
            Text(text)
                .font(Font(uiFont))
                .minimumScaleFactor(1.0)
                .foregroundColor(isCopyingOrPasting ? highlightColor : color)
                .lineLimit(100)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .multilineTextAlignment(.trailing)
                .frame(height: height)
        }
    }
}
*/

struct LongDisplay_Previews: PreviewProvider {
    static var previews: some View {
        LongDisplay(keyModel: KeyModel(), fontSize: 12.0)
    }
}
