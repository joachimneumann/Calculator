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
    
    var body: some View {
        HStack(spacing: 0.0) {
            Spacer(minLength: 0.0)
            if displayData.right == nil {
                Text(displayData.left)
                    .kerning(C.kerning)
                    .font(Font(screenInfo.uiFontLarge))
                    .minimumScaleFactor(screenInfo.largeFontScaleFactor)
                    .foregroundColor(displayData.preliminary ? .gray : .white)
                    .multilineTextAlignment(.trailing)
                    .background(testColors ? .black : .black).opacity(testColors ? 0.9 : 1.0)
                    .lineLimit(1)
                    .frame(maxHeight: 300, alignment: .bottomTrailing)
            } else {
                Text(displayData.left)
                    .kerning(C.kerning)
                    .font(Font(screenInfo.uiFont))
                    .foregroundColor(displayData.preliminary ? .gray : .white)
                    .multilineTextAlignment(.trailing)
                    .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
                    .lineLimit(1)
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
