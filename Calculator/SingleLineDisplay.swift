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
/// - The comma is not counted, i.e. the number of digits is determined with a number 1,23456789123, etc
/// - Thus, an Integer number without comma would be a bit shorter (space to the left)

struct SingleLineDisplay: View {
    let color: Color
    let text: String
    let l: Int
    let fontSize: CGFloat
    let fontGrowthFactor = 1.5
    let displayFontSizeCandidate: CGFloat
    @State var initialHeight: CGFloat? = nil
    
    init(r: Representation, t: TE) {
        self.color = Color.white
        self.fontSize = t.displayFontSizeCandidate
        if let right = r.right {
            text = r.left+right
        } else {
            text = r.left
        }
        l = r.characters
        self.displayFontSizeCandidate = t.displayFontSizeCandidate
    }
    
    var body: some View {
        if !TE.calibrated {
            FindSingleLineCharacterLimit(displayFontSizeCandidate: 40)
        } else {
            Text(text)
                .font(Font.system(size: fontSize*fontGrowthFactor, weight: .thin).monospacedDigit())
                .minimumScaleFactor(1.0/fontGrowthFactor)
                .foregroundColor(color)
                .background(Color.yellow)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    struct FindSingleLineCharacterLimit: View {
        let displayFontSizeCandidate: CGFloat
        @State var singleLineheight: CGFloat? = nil
        var body: some View {
            if singleLineheight == nil {
                Text("x")
                    .font(Font.system(size: displayFontSizeCandidate, weight: .thin).monospacedDigit())
                    .overlay(
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
                                    singleLineheight = proxy.size.height
                                }
                        }
                    )
            } else {
                ForEach((1..<40), id: \.self) { i in
                    let s = ","+String(repeating: "x", count: i)
                    Text(s)
                        .font(Font.system(size: displayFontSizeCandidate, weight: .thin).monospacedDigit())
                        .overlay(
                            GeometryReader { proxy in
                                Color.clear
                                    .onAppear {
                                        if proxy.size.height > singleLineheight! {
                                            if TE.digitsInOneLine == 0 {
                                                TE.digitsInOneLine = s.count
                                                print("digitsInOneLine \(TE.digitsInOneLine)")
                                            } else {
                                                if s.count < TE.digitsInOneLine {
                                                    TE.digitsInOneLine = s.count
                                                    print("digitsInOneLine \(TE.digitsInOneLine)")
                                                }
                                            }
                                        }
                                        print("i \(i) \(s.count) digitsInOneLine \(TE.digitsInOneLine) proxy.size.height \(proxy.size.height) \(singleLineheight!) \(s)")
                                    }
                            }
                        )
                }
            }
        }
    }
}


struct SingleLineDisplay_Previews: PreviewProvider {
    static var previews: some View {
        let r = Representation(characters: 6, lineLimit: 1)
        SingleLineDisplay(r: r, t: TE(appFrame: CGSize(width: 414,height: 814), isPad: false, isPortrait: true))
    }
}

