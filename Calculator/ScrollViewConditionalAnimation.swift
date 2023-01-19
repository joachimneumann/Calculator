//
//  ScrollViewConditionalAnimation.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/20/22.
//

import SwiftUI

struct ScrollViewConditionalAnimation: View {
    let display: Display
    let foregroundColor: Color
    let backgroundColor: Color
    let offsetY: CGFloat
    let disabledScrolling: Bool
    @Binding var scrollViewHasScolled: Bool
    var scrollViewID: UUID
    let preliminary: Bool
    let digitWidth: CGFloat
    
    private struct OffsetKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
    
    private var scrollView: some View {
        GeometryReader { g in
            ScrollView(.vertical) {
                HStack(alignment: .bottom, spacing: 0.0) {
                    let toShow = preliminary && display.left.count > 1 ? String(display.left.dropLast()) : display.left
                    Spacer(minLength: 0.0)
                    Text(toShow)
                        .kerning(display.format.kerning)
                        .font(display.format.font)
                        .foregroundColor(foregroundColor)
                        .multilineTextAlignment(.trailing)
                        .background(backgroundColor)
                        .lineLimit(nil)
                        .offset(y: offsetY)
                        .anchorPreference(key: OffsetKey.self, value: .top) {
                            g[$0].y
                        }
                        .accessibilityIdentifier("landscapeDisplayText")
                        //.animation(Animation.easeInOut(duration: 0.2), value: foregroundColor)
                    if preliminary {
                        ThreeDots().frame(width: digitWidth, height: digitWidth / 3)
                            .offset(y: -digitWidth / 6)
                    }
                }
            }
            .id(scrollViewID)
            .disabled(disabledScrolling)
        }
    }
    
    var body: some View {
        scrollView
            .onPreferenceChange(OffsetKey.self) { verticalScrollPosition in
                //print("verticalScrollPosition \(verticalScrollPosition)")
                if abs(verticalScrollPosition) > 0.01 {
                    scrollViewHasScolled = true
                } else {
                    scrollViewHasScolled = false
                }
            }
    }
}
