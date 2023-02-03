//
//  ScrollViewConditionalAnimation.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/20/22.
//

import SwiftUI

struct ScrollViewConditionalAnimation: View {
    let display: Display
    let screen: Screen
    let foregroundColor: Color
    let backgroundColor: Color
    let offsetY: CGFloat
    let disabledScrolling: Bool
    @Binding var scrollViewHasScolled: Bool
    var scrollViewID: UUID
    
    private struct OffsetKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
    
    private var scrollView: some View {
        GeometryReader { g in
            HStack(alignment: .top, spacing: 0.0) {
                ScrollView(.vertical) {
                    HStack(alignment: .bottom, spacing: 0.0) {
                        let toShow = display.preliminary && display.left.count > 1 ? String(display.left.dropLast()) : display.left
                        Spacer(minLength: 0.0)
                        Text(toShow)
                            .kerning(screen.kerning)
                            .font(Font(screen.appleFont))
                            .foregroundColor(display.preliminary ? .gray : foregroundColor)
                            .multilineTextAlignment(.trailing)
                            .background(backgroundColor)
                            .lineLimit(nil)
                            .offset(y: offsetY)
                            .anchorPreference(key: OffsetKey.self, value: .top) {
                                g[$0].y
                            }
                            .accessibilityIdentifier("landscapeDisplayText")
                        //.animation(Animation.easeInOut(duration: 0.2), value: foregroundColor)
                    }
                }
                .id(scrollViewID)
                .disabled(disabledScrolling)
                if display.preliminary {
                    ThreeDots()
                        .frame(width: screen.digitWidth, height: screen.digitWidth / 3)
                        .offset(y: offsetY + screen.textHeight - screen.digitWidth * 2.0 / 3.0)
                }
            }
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
