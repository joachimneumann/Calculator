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
    let backgroundColor: Color
    private let font: Font
    
    init(display: Display, screen: Screen, backgroundColor: Color) {
        self.display = display
        self.screen = screen
        self.backgroundColor = backgroundColor
        
        /// calculate possibly expanded font
        var availableDisplayWidth = screen.displayWidth
        if display.right != nil {
            availableDisplayWidth -= screen.ePadding
        }
        let text = display.left + (display.right ?? "")
        let n = CGFloat(text.count)
        let lengthOfNulls = n * screen.digitWidth
        
        var factor: CGFloat = 1.0
        let expandLimit = screen.displayWidth - screen.digitWidth * 0.9
        if lengthOfNulls < expandLimit {
            /// scale up
            factor = expandLimit / lengthOfNulls
            if factor > 1.5 { factor = 1.5 }
            if factor < 1.0 { factor = 1.0 }
        }
        let uiFont = Screen.appleFont(ofSize: screen.uiFontSize * factor)
        font = Font(uiFont)
    }
    
    @ViewBuilder
    var mantissa: some View {
        let toShow = display.preliminary && display.left.count > 1 ? String(display.left.dropLast()) : display.left
        Text(toShow)
            .kerning(screen.kerning)
            .font(font)
            .foregroundColor(display.preliminary ? .gray : display.color)
            .multilineTextAlignment(.trailing)
            .background(testColors ? .yellow : backgroundColor).opacity(testColors ? 0.9 : 1.0)
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
                .font(font)
                .foregroundColor(display.preliminary ? .gray : display.color)
                .multilineTextAlignment(.trailing)
                .background(testColors ? .yellow : backgroundColor).opacity(testColors ? 0.9 : 1.0)
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
