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
    let digitWidth: CGFloat
        
    var body: some View {
        HStack(alignment: .bottom, spacing: 0.0) {
            Spacer(minLength: 0.0)
            let toShow = displayData.isPreliminary && displayData.left.count > 1 ? String(displayData.left.dropLast()) : displayData.left
            Text(toShow)
                .kerning(C.kerning)
                .font(Font(screenInfo.uiFont))
                .foregroundColor(displayData.isPreliminary ? .gray : .white)
                .multilineTextAlignment(.trailing)
                .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
                .lineLimit(1)
            if displayData.isPreliminary {
                AnimatedDots().frame(width: displayData.digitWidth, height: displayData.digitWidth / 3)
                    .offset(y: -displayData.digitWidth / 3)
            }
            if displayData.right != nil {
                Text(displayData.right!)
                    .kerning(C.kerning)
                    .font(Font(screenInfo.uiFont))
                    .foregroundColor(displayData.isPreliminary ? .gray : .white)
                    .multilineTextAlignment(.trailing)
                    .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
                    .lineLimit(1)
                    .padding(.leading, screenInfo.ePadding)
            }
        }
    }
}
