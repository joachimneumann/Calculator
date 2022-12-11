//
//  PortraitDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct PortraitDisplay: View {
    let displayData: DisplayData
    let fullLength: Bool
    let ePadding: CGFloat
    let smallFont: Font
    let largeFont: Font
    let fontScaleFactor: CGFloat
    let displayWidth: CGFloat
    
    var body: some View {
        VStack(spacing: 0.0) {
            HStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                //let _ = print("displayData.shortLeft \(displayData.shortLeft)")
                if displayData.shortRight == nil {
                    Text(displayData.shortLeft)
                        .font(fullLength ? smallFont : largeFont)
                        .minimumScaleFactor(1.0 / (fullLength ? 1.0 : fontScaleFactor))
                } else {
                    Text(displayData.shortLeft)
                        .font(smallFont)
                    Text(displayData.shortRight!)
                        .font(smallFont)
                        .padding(.leading, ePadding)
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
