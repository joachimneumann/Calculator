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
    let color: Color
    let disabledScrolling: Bool
    @Binding var scrollViewHasScrolled: Bool
    var scrollViewID: UUID
    
    var body: some View {
        ScrollViewConditionalAnimation(
            text: display.data.left,
            font: Font(screenInfo.uiFont),
            foregroundColor: color,
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
                .font(Font(screenInfo.uiFont))
                .foregroundColor(color)
                .padding(.leading, screenInfo.ePadding)
                .offset(y: screenInfo.offsetToVerticallyAlignTextWithkeyboard)
        }
    }
}
