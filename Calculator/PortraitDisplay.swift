//
//  PortraitDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct PortraitDisplay: View {
    let text: String
    let isAbbreviated: Bool
    let smallFont: Font
    let largeFont: Font
    let fontScaleFactor: CGFloat
    let displayWidth: CGFloat
    
    var body: some View {
        VStack(spacing: 0.0) {
            HStack(alignment: .top, spacing: 0.0) {
                HStack(spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    Text(text)
                }
                .font(isAbbreviated ? smallFont : largeFont)
                .minimumScaleFactor(1.0 / (isAbbreviated ? 1.0 : fontScaleFactor))
                .foregroundColor(.white)
                .lineLimit(1)
                .frame(maxHeight: .infinity, alignment: .bottomTrailing)
                .multilineTextAlignment(.trailing)
            }
            Spacer()
        }
    }
}
