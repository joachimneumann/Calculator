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
    let foregroundColor: Color
    let backgroundColor: Color
    let disabledScrolling: Bool
    @Binding var scrollViewHasScrolled: Bool
    let offsetToVerticallyAlignTextWithkeyboard: CGFloat
    var scrollViewID: UUID
    
    var mantissa: some View {
        ScrollViewConditionalAnimation(
            display: display,
            screen: screen,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
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
                .font(Font(screen.appleFont))
                .foregroundColor(foregroundColor)
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
