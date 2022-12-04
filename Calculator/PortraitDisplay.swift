//
//  PortraitDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct PortraitDisplay: View {
    let mantissa: String
    let exponent: String?
    let ePadding: CGFloat
    let fontSize: CGFloat
    let fontScaleFactor: CGFloat
    let displayWidth: CGFloat
    
    var body: some View {
        VStack(spacing: 0.0) {
            HStack(alignment: .top, spacing: 0.0) {
                HStack(spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    Text(mantissa + (fontScaleFactor != 1.0 && exponent != nil ? exponent! : ""))
                    if fontScaleFactor != 1.0 && exponent != nil {
                        Text(exponent!)
                            .padding(.leading, ePadding)
                            .padding(.trailing, 0.0)
                    }
                }
                .frame(width: displayWidth, alignment: .trailing)
                //.background(Color.blue)
                .font(Font(UIFont.monospacedDigitSystemFont(ofSize: fontSize * fontScaleFactor, weight: .thin)))
                .minimumScaleFactor(1.0/fontScaleFactor)
                .foregroundColor(.white)
                .lineLimit(1)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .multilineTextAlignment(.trailing)
            }
            Spacer()
        }
    }
}
