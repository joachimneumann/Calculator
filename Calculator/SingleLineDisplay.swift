//
//  SingleLineDisplay.swift
//  Calculator
//
//  Created by joachim on 2/4/22.
//

import SwiftUI

/// in TE, I determine the number of digits in a line:
/// 1. Calculate a first estimate for t.displayFontSize based on the key height
/// 2. Determine the number of digits in an integer that fint into a single line
/// 3. Using minimumScaleFactor, determin the font size that fits this number with a comma.
/// 4. This is the t.displayFontSize
/// 5. Define the maximal factor for shorter numbers, e.g. 1.5
///
/// Notes:
/// - A digital number can at most have one comma,
/// - The optional e is counted as a digit
/// - The comma is counted, i.e. the length of 1,23 is 4
/// - Because the comma take up less space, a number with comma will be a bit shorter (space to the left)

struct SingleLineDisplay: View {
    let color: Color
    let text: String
    let uiFont: UIFont
    let fontGrowthFactor: CGFloat
    let height: CGFloat
    let isPortraitIPhone: Bool
    
    init(brain: Brain, t: TE) {
        self.color = Color.white
        text = brain.last.singleLine(len: t.withComma)
        isPortraitIPhone = !t.isPad && t.isPortrait
        if isPortraitIPhone {
            fontGrowthFactor = t.iPhonePortraitSingleLineDisplayHeight / t.singleLineDisplayHeight
            self.uiFont = t.iPhonePortraitDisplayUIFont
            self.height = t.iPhonePortraitSingleLineDisplayHeight
        } else {
            fontGrowthFactor = 1.0
            self.uiFont = t.displayUIFont
            self.height = t.singleLineDisplayHeight
        }
    }
    
    var body: some View {
        // TODO: use growthfactor and minimumScaleFactor only if the length of the single ine is less than the max length
        HStack(spacing: 0.0) {
            Spacer(minLength: 0.0)
            if isPortraitIPhone {
                Text(text)
                    .font(Font(uiFont))
                    .scaledToFit()
                    .minimumScaleFactor(1.0 / fontGrowthFactor)
                    .lineLimit(1)
                    .foregroundColor(color)
            } else {
                Text(text)
                    .font(Font(uiFont))
                    .minimumScaleFactor(1.0/fontGrowthFactor)
                    .foregroundColor(color)
                    .frame(height: height, alignment: .topTrailing)
            }
        }
    }
}

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

//struct SingleLineDisplay_Previews: PreviewProvider {
//    static var previews: some View {
//        let brain = Brain(precision: 100)
//        let _ = brain.nonWaitingOperation("π")
//        SingleLineDisplay(brain: brain, t: TE(appFrame: CGSize(width: 200, height: 200)))
////            .background(Color.green)
//    }
//}

