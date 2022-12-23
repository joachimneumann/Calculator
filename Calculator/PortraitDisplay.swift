//
//  PortraitDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct PortraitDisplay: View {
    let displayData: DisplayData
    let screenInfo: ScreenInfo
    let lengths: Lengths
    let preliminary: Bool
    let digitWidth: CGFloat

    var body: some View {
        HStack(alignment: .bottom, spacing: 0.0) {
            Spacer(minLength: 0.0)
            let toShow = preliminary && displayData.left.count > 1 ? String(displayData.left.dropLast()) : displayData.left
            if false { //displayData.right == nil {
                Text(toShow)
                    .kerning(C.kerning)
                    .font(Font(screenInfo.uiFontLarge))
                    .minimumScaleFactor(screenInfo.largeFontScaleFactor)
                    .foregroundColor(displayData.preliminary ? .gray : .white)
                    .multilineTextAlignment(.trailing)
                    .background(testColors ? .black : .black).opacity(testColors ? 0.9 : 1.0)
                    .lineLimit(1)
                if preliminary {
                    /// no animated Dots in this case,
                    /// because the text might be larger
                    /// due to minimumScaleFactor and
                    /// I don't know how to get its size
                    Text("…")
                        .kerning(C.kerning)
                        .font(Font(screenInfo.uiFontLarge))
                        .minimumScaleFactor(screenInfo.largeFontScaleFactor)
                        .foregroundColor(displayData.preliminary ? .gray : .white)
                        .multilineTextAlignment(.trailing)
                        .background(testColors ? .black : .black).opacity(testColors ? 0.9 : 1.0)
                        .lineLimit(1)
                }
           } else {
                Text(toShow)
                    .kerning(C.kerning)
                    .font(Font(screenInfo.uiFont))
                    .foregroundColor(displayData.preliminary ? .gray : .white)
                    .multilineTextAlignment(.trailing)
                    .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
                    .lineLimit(1)
               if preliminary {
                    AnimatedDots().frame(width: digitWidth, height: digitWidth / 3)
                        .offset(y: -digitWidth / 6)
               }
               if displayData.right != nil {
                   Text(displayData.right!)
                       .kerning(C.kerning)
                       .font(Font(screenInfo.uiFont))
                       .foregroundColor(displayData.preliminary ? .gray : .white)
                       .multilineTextAlignment(.trailing)
                       .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
                       .lineLimit(1)
                       .padding(.leading, screenInfo.ePadding)
               }
            }
        }
    }
}
