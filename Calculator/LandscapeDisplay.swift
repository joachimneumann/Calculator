//
//  LandscapeDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/25/22.
//

import SwiftUI

struct LandscapeDisplay: View {
    let display: Display
    let screenInfo: ScreenInfo
    let showOrange: Bool
    let disabledScrolling: Bool
    @Binding var scrollViewHasScrolled: Bool
    var scrollViewID: UUID
    
    var body: some View {
        ScrollViewConditionalAnimation(
            text: display.data.left,
            font: display.format.font,
            foregroundColor: showOrange ? .orange : display.format.color,
            backgroundColor: testColors ? .yellow : .black,
            offsetY: screenInfo.offsetToVerticallyAlignTextWithkeyboard,
            disabledScrolling: disabledScrolling,
            scrollViewHasScolled: $scrollViewHasScrolled,
            scrollViewID: scrollViewID,
            preliminary: display.format.showThreeDots,
            digitWidth: screenInfo.lengths.digitWidth)
        if display.data.right != nil {
            Text(display.data.right!)
                .kerning(C.kerning)
                .font(display.format.font)
                .foregroundColor(showOrange ? .orange : display.format.color)
                .padding(.leading, screenInfo.ePadding)
                .offset(y: screenInfo.offsetToVerticallyAlignTextWithkeyboard)
        }
    }
}
