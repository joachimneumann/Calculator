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
    let l: Int
    let fontSize: CGFloat
    let fontGrowthFactor = 1.0
    
    init(number: Number, fontSize: CGFloat, length: Int) {
        self.color = Color.white
        self.fontSize = fontSize
        let oneLiner = number.oneLiner(length: length)
        if let right = oneLiner.right {
            text = oneLiner.left+right
        } else {
            text = oneLiner.left
        }
        l = length
    }
    
    var body: some View {
        // TODO: use growthfactor and minimumScaleFactor only if the length of the single ine is less than the max length
        VStack(spacing: 0.0) {
            Text(text)
                .font(Font.system(size: fontSize*fontGrowthFactor, weight: .thin).monospacedDigit())
                .minimumScaleFactor(1.0/fontGrowthFactor)
                .foregroundColor(color)
                .background(Color.yellow)
                .frame(maxWidth: .infinity, alignment: .trailing)
            Spacer(minLength: 0.0)
        }
    }

}

struct MultiLineDisplay: View {
    let color: Color
    let text: String
    let l: Int
    let fontSize: CGFloat
    let fontGrowthFactor = 1.0
    
    init(number: Number, fontSize: CGFloat, length: Int) {
        self.color = Color.white
        self.fontSize = fontSize
        let oneLiner = number.oneLiner(length: length)
        if let right = oneLiner.right {
            text = oneLiner.left+right
        } else {
            text = oneLiner.left
        }
        l = length
    }
    
    var body: some View {
        ScrollView {
            Text(text)
                .font(Font.system(size: fontSize, weight: .thin).monospacedDigit())
                .minimumScaleFactor(1.0)
                .foregroundColor(color)
                .background(Color.yellow)
                .lineLimit(100)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

}

struct SingleLineDisplay_Previews: PreviewProvider {
    static var previews: some View {
        
        SingleLineDisplay(number: Number("123,456789"), fontSize: 47.0925, length: 8)
            .background(Color.green)
    }
}

