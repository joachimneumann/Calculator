//
//  OneLineDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/21/22.
//

import SwiftUI

struct OneLineDisplay: View {
    let text: String
    let size: CGSize
    let largeFont: Font
    let smallFont: Font
    let maximalTextLength: Int
    var fontScaleFactor = 1.0

    var body: some View {
        let _ = print("OneLineDisplay body \(text)")
        HStack(spacing: 0.0) {
            Spacer(minLength: 0.0)
            if text.count >= maximalTextLength {
                Text(text)
                    .foregroundColor(Color.white)
                    .scaledToFit()
                    .font(smallFont)
            } else {
                Text(text)
                    .foregroundColor(Color.white)
                    .scaledToFit()
                    .font(largeFont)
                    .minimumScaleFactor(1.0 / fontScaleFactor)
            }
        }
    }
}
