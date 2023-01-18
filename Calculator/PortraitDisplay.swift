//
//  PortraitDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct PortraitDisplay: View {
    let display: Display
    
    @ViewBuilder
    var mantissa: some View {
        let toShow = display.format.showThreeDots && display.data.left.count > 1 ? String(display.data.left.dropLast()) : display.data.left
        Text(toShow)
            .kerning(display.format.kerning)
            .font(display.format.font)
            .foregroundColor(display.format.color)
            .multilineTextAlignment(.trailing)
            .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
    }

    @ViewBuilder
    var threeDots: some View {
        if display.format.showThreeDots {
            ThreeDots().frame(width: display.format.digitWidth, height: display.format.digitWidth / 3)
                .offset(y: -display.format.digitWidth / 3)
        }
    }
    
    @ViewBuilder
    var exponent: some View {
        if let exponent = display.data.right {
            Text(exponent)
                .kerning(display.format.kerning)
                .font(display.format.font)
                .foregroundColor(display.format.color)
                .multilineTextAlignment(.trailing)
                .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
                .lineLimit(1)
                .padding(.leading, display.format.ePadding)
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
