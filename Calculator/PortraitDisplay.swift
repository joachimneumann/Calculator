//
//  PortraitDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct PortraitDisplay: View {
    let display: Display
    let screenInfo: ScreenInfo
        
    var body: some View {
        HStack(alignment: .bottom, spacing: 0.0) {
            Spacer(minLength: 0.0)
            Text(display.data.left)
                .kerning(C.kerning)
                .font(Font(screenInfo.uiFont))
                .foregroundColor(display.format.color)
                .multilineTextAlignment(.trailing)
                .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
                .lineLimit(1)
            if display.data.showThreeDots {
                AnimatedDots().frame(width: screenInfo.lengths.digitWidth, height: screenInfo.lengths.digitWidth / 3)
                    .offset(y: -screenInfo.lengths.digitWidth / 3)
            }
            if display.data.right != nil {
                Text(display.data.right!)
                    .kerning(C.kerning)
                    .font(Font(screenInfo.uiFont))
                    .foregroundColor(display.format.color)
                    .multilineTextAlignment(.trailing)
                    .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
                    .lineLimit(1)
                    .padding(.leading, screenInfo.ePadding)
            }
        }
    }
}
