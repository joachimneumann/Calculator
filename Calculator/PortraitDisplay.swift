//
//  PortraitDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct PortraitDisplay: View {
    let display: Display
    let screen: Screen
    
    @ViewBuilder
    var mantissa: some View {
        let toShow = display.preliminary && display.left.count > 1 ? String(display.left.dropLast()) : display.left
        Text(toShow)
            .kerning(screen.kerning)
            .font(Font(screen.uiFont))
            .foregroundColor(display.color)
            .multilineTextAlignment(.trailing)
            .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
    }

    @ViewBuilder
    var threeDots: some View {
        if display.preliminary {
            ThreeDots().frame(width: screen.digitWidth, height: screen.digitWidth / 3)
                .offset(y: -screen.digitWidth / 3)
        }
    }
    
    @ViewBuilder
    var exponent: some View {
        if let exponent = display.right {
            Text(exponent)
                .kerning(screen.kerning)
                .font(Font(screen.uiFont))
                .foregroundColor(display.color)
                .multilineTextAlignment(.trailing)
                .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
                .lineLimit(1)
                .padding(.leading, screen.ePadding)
        }
    }
    
    var body: some View {
        //let _ = print(display.data.left)
        HStack(alignment: .bottom, spacing: 0.0) {
            Spacer(minLength: 0.0)
            mantissa
            threeDots
            exponent
        }
    }
}
