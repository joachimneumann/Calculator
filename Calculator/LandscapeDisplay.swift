//
//  LandscapeDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/25/22.
//

import SwiftUI

struct LandscapeDisplay: View {
    let display: Display
    let showOrange: Bool
    let disabledScrolling: Bool
    @Binding var scrollViewHasScrolled: Bool
    let offsetToVerticallyAlignTextWithkeyboard: CGFloat
    var scrollViewID: UUID
    
    var body: some View {
        //let _ = print("LandscapeDisplay", display.data.left)
        ScrollViewConditionalAnimation(
            text: display.data.left,
            font: display.format.font,
            foregroundColor: showOrange ? .orange : display.format.color,
            backgroundColor: testColors ? .yellow : .black,
            offsetY: offsetToVerticallyAlignTextWithkeyboard,
            disabledScrolling: disabledScrolling,
            scrollViewHasScolled: $scrollViewHasScrolled,
            scrollViewID: scrollViewID,
            preliminary: display.format.showThreeDots,
            digitWidth: display.format.digitWidth)
        if display.data.right != nil {
            Text(display.data.right!)
                .kerning(C.kerning)
                .font(display.format.font)
                .foregroundColor(showOrange ? .orange : display.format.color)
                .padding(.leading, display.format.ePadding)
                .offset(y: offsetToVerticallyAlignTextWithkeyboard)
        }
    }
}
