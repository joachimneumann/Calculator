//
//  LongDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct LongDisplay: View {
//    let mantissa: String
//    let zoomed: Bool
//    let exponent: String?
//    let abbreviated: Bool
//    let smallFont: Font
//    let largeFont: Font
//    let scaleFont: Bool
//    let isCopyingOrPasting: Bool
//    let precisionString: String
    let zoomed: Bool
    let smallFont: Font
    var body: some View {
        ScrollView() {
            HStack {
                Spacer()
                if zoomed {
                    Text("hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello helsdflo hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello sdfhello hello hello hello hello hello hello hello hsdfello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hellsdfo hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hellohello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello helsdflo hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello sdfhello hello hello hello hello hello hello hello hsdfello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hellsdfo hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hellohello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello helsdflo hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello sdfhello hello hello hello hello hello hello hello hsdfello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hellsdfo hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hellohello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello helsdflo hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello sdfhello hello hello hello hello hello hello hello hsdfello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hellsdfo hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello")
                        .font(smallFont)
                } else {
                    Text("hello")
                        .font(smallFont)
                }
//                    .font(Font(UIFont.monospacedSystemFont(ofSize: 53, weight: .thin)))
            }
        }
        .multilineTextAlignment(.trailing)
            .padding(30)
            .offset(x: -30)
            .animation(Animation.linear(duration: 0.1) , value: zoomed)
//        ScrollView() {
//            HStack {
//                Spacer()
//                Text(mantissa)
//                    .font(smallFont)
//            }
//        }
//        .scrollDisabled(!zoomed)
//        .multilineTextAlignment(.trailing)
//            .padding(30)
//            .offset(x: -30)
//            .animation(Animation.linear(duration: 0.5) , value: zoomed)
    }
}
/*
 struct LongDisplay: View {
 let mantissa: String
 let exponent: String?
 let abbreviated: Bool
 let smallFont: Font
 let largeFont: Font
 let scaleFont: Bool
 let isCopyingOrPasting: Bool
 let precisionString: String
 let scrollingDisabled: Bool
 
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
 ScrollView(.vertical) {
 Text(mantissa)
 .background(Color.green)
 .font(scaleFont ? largeFont : smallFont)
 .minimumScaleFactor(scaleFont ? 1.0/1.5 : 1.0)
 .foregroundColor(isCopyingOrPasting ? isCopyingOrPastingColor : .white)
 .lineLimit(scaleFont ? 1 : 100)
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
 .font(smallFont)
 .minimumScaleFactor(1.0)
 .foregroundColor(isCopyingOrPasting ? isCopyingOrPastingColor : .white)
 .lineLimit(100)
 .multilineTextAlignment(.trailing)
 }
 }
 Spacer()
 }
 }
 }
 }
 */

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
