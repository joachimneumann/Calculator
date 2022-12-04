//
//  LongDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct LongDisplay: View {
    let zoomed: Bool
    let mantissa: String
    let exponent: String?
    let ePadding: CGFloat
    let abbreviated: Bool
    let smallFont: Font
    let largeFont: Font
    let scaleFont: Bool
    let isCopyingOrPasting: Bool
    let precisionString: String
    
    private let isCopyingOrPastingColor = Color(
        red:    118.0/255.0,
        green:  250.0/255.0,
        blue:   113.0/255.0)
    
    var body: some View {
        if scaleFont {
            VStack(spacing: 0.0) {
                Spacer()
                HStack(spacing: 0.0) {
                    Spacer()
                    Text(mantissa)
                        .foregroundColor(Color.white)
                        .scaledToFit()
                        .font(largeFont)
                        .minimumScaleFactor(1.0 / 1.5)
                }
            }
        } else {
            VStack(spacing: 0.0) {
                HStack(alignment: .top, spacing: 0.0) {
//                    if zoomed {
//                        HStack(spacing: 0.0) {
//                            Text(mantissa)
//                            if exponent != nil {
//                                Text(exponent!)
//                                    .padding(.leading, ePadding)
//                                    .padding(.trailing, 0.0)
//                            }
//                        }
//                        .background(Color.blue)
//                        .font(scaleFont ? largeFont : smallFont)
////                        .minimumScaleFactor(scaleFont ? 1.0/1.5 : 1.0)
//                        .foregroundColor(isCopyingOrPasting ? isCopyingOrPastingColor : .white)
//                        .lineLimit(1)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
//                        .multilineTextAlignment(.trailing)
                        /*
                        ScrollView(.vertical) {
                            Text(mantissa)
                                .background(Color.green)
                                .font(smallFont)
                                .foregroundColor(isCopyingOrPasting ? isCopyingOrPastingColor : .white)
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
                        if exponent != nil {
                            Text(exponent!)
                                .font(smallFont)
                                .foregroundColor(isCopyingOrPasting ? isCopyingOrPastingColor : .white)
                                .multilineTextAlignment(.trailing)
                                .padding(.leading, ePadding)
                        }
                         */
//                    } else {
                        HStack(spacing: 0.0) {
                            Text(mantissa)
                            if exponent != nil {
                                Text(exponent!)
                                    .padding(.leading, ePadding)
                                    .padding(.trailing, 0.0)
                            }
                        }
                        .background(Color.blue)
                        .font(scaleFont ? largeFont : smallFont)
//                        .minimumScaleFactor(scaleFont ? 1.0/1.5 : 1.0)
                        .foregroundColor(isCopyingOrPasting ? isCopyingOrPastingColor : .white)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .multilineTextAlignment(.trailing)
//                    }
                }
                Spacer()
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
