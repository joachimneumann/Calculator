//
//  LongDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct LongDisplay: View {
    let mantissa: String
    let exponent: String?
    let abbreviated: Bool
    
//    let keyModel: KeyModel
    let font: Font
    let isCopyingOrPasting: Bool
    let isCopyingOrPastingColor = Color(
        red:    118.0/255.0,
        green:  250.0/255.0,
        blue:   113.0/255.0)
    let precisionString: String
    let scrollingDisabled: Bool

//    init(keyModel: KeyModel, fontSize: CGFloat) {
//        print("LongDisplay init()")
//        self.keyModel = keyModel
//        self.fontSize = fontSize
//        let multipleLines = keyModel.multipleLines
//        abbreviated = multipleLines.abbreviated
//        mantissa = multipleLines.left + (abbreviated ? "..." : "")
//        exponent = multipleLines.right
////        private var abbreviated = false
////        text = multipleLines.oneLine(showAbbreviation: true)
////        if multipleLines.abbreviated {
////            if keyModel.precision > C.maxDigitsInLongDisplay {
////                abbreviated = true
////                print("precision \(keyModel.precision) C.maxDigitsInLongDisplay \(C.maxDigitsInLongDisplay) text.count \(text.count)")
////            }
////        }
//        isCopyingOrPasting = false
//        color = Color(uiColor: C.digitColors.textColor)
//    }
    
    var body: some View {
            HStack(alignment: .top, spacing: 0.0) {
                ScrollView(.vertical) {
                    Text(mantissa)
                        .font(font)
                        .minimumScaleFactor(1.0)
                        .foregroundColor(isCopyingOrPasting ? isCopyingOrPastingColor : .white)
                        .lineLimit(100)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .multilineTextAlignment(.trailing)
                    if abbreviated {
                        HStack() {
                            Spacer()
                            Text("This result is abbreviated to \(C.maxDigitsInLongDisplay.useWords) significant digits. To get up to \(precisionString) significant digits use copy")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .scrollDisabled(scrollingDisabled)
                if exponent != nil {
                    Text(exponent!)
                        .font(font)
                        .minimumScaleFactor(1.0)
                        .foregroundColor(isCopyingOrPasting ? isCopyingOrPastingColor : .white)
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

//struct LongDisplay_Previews: PreviewProvider {
//    static var previews: some View {
//        LongDisplay(keyModel: KeyModel(), fontSize: 12.0)
//    }
//}
