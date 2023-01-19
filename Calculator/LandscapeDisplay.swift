//
//  LandscapeDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/25/22.
//

import SwiftUI

struct LandscapeDisplay: View {
    let display: Display
    let screen: Screen
    let showOrange: Bool
    let disabledScrolling: Bool
    @Binding var scrollViewHasScrolled: Bool
    let offsetToVerticallyAlignTextWithkeyboard: CGFloat
    var scrollViewID: UUID
    
    var mantissa: some View {
        ScrollViewConditionalAnimation(
            display: display,
            screen: screen,
            foregroundColor: showOrange ? .orange : display.color,
            backgroundColor: testColors ? .yellow : .black,
            offsetY: offsetToVerticallyAlignTextWithkeyboard,
            disabledScrolling: disabledScrolling,
            scrollViewHasScolled: $scrollViewHasScrolled,
            scrollViewID: scrollViewID)
    }
    
    @ViewBuilder
    var exponent: some View {
        if display.right != nil {
            Text(display.right!)
                .kerning(screen.kerning)
                .font(Font(screen.uiFont))
                .foregroundColor(showOrange ? .orange : display.color)
                .padding(.leading, screen.ePadding)
                .offset(y: offsetToVerticallyAlignTextWithkeyboard)
        }
    }
    
    var body: some View {
        //let _ = print("LandscapeDisplay", display.data.left)
        HStack(alignment: .top, spacing: 0.0) {
            mantissa
            exponent
        }
    }
}
