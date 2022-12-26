//
//  PortraitDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct PortraitDisplay: View {
    let display: Display
        
    var body: some View {
        let toShow = display.format.showThreeDots && display.data.left.count > 1 ? String(display.data.left.dropLast()) : display.data.left
        HStack(alignment: .bottom, spacing: 0.0) {
            Spacer(minLength: 0.0)
            Text(toShow)
                .kerning(C.kerning)
                .font(display.format.font)
                .foregroundColor(display.format.color)
                .multilineTextAlignment(.trailing)
                .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
                .lineLimit(1)
            if display.format.showThreeDots {
                AnimatedDots().frame(width: display.format.digitWidth, height: display.format.digitWidth / 3)
                    .offset(y: -display.format.digitWidth / 3)
            }
            if display.data.right != nil {
                Text(display.data.right!)
                    .kerning(C.kerning)
                    .font(display.format.font)
                    .foregroundColor(display.format.color)
                    .multilineTextAlignment(.trailing)
                    .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
                    .lineLimit(1)
                    .padding(.leading, display.format.ePadding)
            }
        }
    }
}
