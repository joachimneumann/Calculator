//
//  PortraitDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct PortraitDisplay: View {
    let displayData: DisplayData
    let forceSmallFont: Bool
    let ePadding: CGFloat
    let smallFont: Font
    let largeFont: Font
    let fontScaleFactor: CGFloat
    
    var body: some View {
        VStack(spacing: 0.0) {
            HStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                //let _ = print("displayData.shortLeft \(displayData.shortLeft)")
                if displayData.shortRight == nil {
                    Text(displayData.shortLeft)
                        .font(forceSmallFont ? smallFont : largeFont)
                        .minimumScaleFactor(1.0 / (forceSmallFont ? 1.0 : fontScaleFactor))
                } else {
                    /// exponential is always displayed with the small font
                    Text(displayData.shortLeft)
                        .font(smallFont)
                        .minimumScaleFactor(0.1)
                    Text(displayData.shortRight!)
                        .font(smallFont)
                        .padding(.leading, ePadding)
                        .minimumScaleFactor(0.1)
                    // todo: the minimumScaleFactor should not be necessary ??!?
                    // However, without it the mantissa and exponent are sometimes abbreviated with '...'
                }
            }
            .foregroundColor(.white)
            .lineLimit(1)
            .frame(maxHeight: .infinity, alignment: .bottomTrailing)
            .multilineTextAlignment(.trailing)
            Spacer()
        }
    }
}
