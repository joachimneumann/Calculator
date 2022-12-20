//
//  ScrollViewConditionalAnimation.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/20/22.
//

import SwiftUI

struct ScrollViewConditionalAnimation: View {
    let text: String
    let font: Font
    let foregroundColor: Color
    let backgroundColor: Color
    let offsetY: CGFloat
    let disabled: Bool
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
            ScrollView(.vertical) {
                HStack(alignment: .top, spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    Text(text)
                        .kerning(C.kerning)
                        .font(font)
                        .foregroundColor(foregroundColor)
                        .multilineTextAlignment(.trailing)
                        .background(backgroundColor)
                        .lineLimit(nil)
                        .offset(y: offsetY)
                        .anchorPreference(key: OffsetKey.self, value: .top) {
                            g[$0].y
                        }
                }
            }
            .id(scrollViewID)
            .disabled(disabled)
        }
    }
    
    var body: some View {
        scrollView
            .onPreferenceChange(OffsetKey.self) { verticalScrollPosition in
                // print("verticalScrollPosition \(verticalScrollPosition)")
                if abs(verticalScrollPosition) > 0.01 {
                    scrollViewHasScolled = true
                } else {
                    scrollViewHasScolled = false
                }
            }
    }
}