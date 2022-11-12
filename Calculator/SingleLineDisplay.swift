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
    let fontGrowthFactor = 1.0
    let height: CGFloat
    
    init(brain: Brain, t: TE) {
        self.color = Color.white
        let oneLiner = brain.last.oneLiner(withoutComma: t.withoutComma, withComma: t.withComma)
        if let right = oneLiner.right {
            text = oneLiner.left+right
        } else {
            text = oneLiner.left
        }
        self.uiFont = t.displayUIFont
        self.height = t.singleLineDisplayHeight
    }
    
    var body: some View {
        // TODO: use growthfactor and minimumScaleFactor only if the length of the single ine is less than the max length
        HStack(spacing: 0.0) {
            Spacer(minLength: 0.0)
            Text(text)
                .font(Font(uiFont))
                .minimumScaleFactor(1.0/fontGrowthFactor)
                .foregroundColor(color)
                .frame(height: height, alignment: .topTrailing)
//                .background(Color.yellow).opacity(0.4)
        }
//        .transition(.move(edge: .trailing))
    }
}

struct MultiLineDisplay: View {
    let color: Color
    let text: String
    let uiFont: UIFont
    let height: CGFloat

    init(brain: Brain, t: TE) {
        self.color = Color.white
        let oneLiner = brain.last.oneLiner(withoutComma: brain.precision, withComma: brain.precision)
        if let right = oneLiner.right {
            text = oneLiner.left+right
        } else {
            text = oneLiner.left
        }
        self.uiFont = t.displayUIFont
        self.height = t.multipleLineDisplayHeight
    }
    
    var body: some View {
        ScrollView {
            Text(text)
                .font(Font(uiFont))
                .minimumScaleFactor(1.0)
                .foregroundColor(color)
                .lineLimit(100)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .multilineTextAlignment(.trailing)
                .frame(height: height)
                .background(Color.yellow.opacity(0.4))
        }
    }
}

struct SingleLineDisplay_Previews: PreviewProvider {
    static var previews: some View {
        let brain = Brain()
        let _ = brain.nonWaitingOperation("π")
        SingleLineDisplay(brain: brain, t: TE(appFrame: CGSize(width: 200, height: 200)))
//            .background(Color.green)
    }
}

