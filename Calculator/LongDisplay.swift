//
//  LongDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct LongDisplay: View {
    let zoomed: Bool
    let mantissa: String
    let exponent: String?
    let ePadding: CGFloat
    let abbreviated: Bool
    let smallFont: Font
    let largeFont: Font
    let scaleFont: Bool
    let isCopyingOrPasting: Bool
    let precisionString: String
    let displayWidth: CGFloat
    
    private let isCopyingOrPastingColor = Color(
        red:    118.0/255.0,
        green:  250.0/255.0,
        blue:   113.0/255.0)
    
    var body: some View {
        if scaleFont {
            VStack(spacing: 0.0) {
                Spacer()
                HStack(spacing: 0.0) {
                    Spacer()
                    Text(mantissa)
                        .foregroundColor(Color.white)
                        .scaledToFit()
                        .font(largeFont)
                        .minimumScaleFactor(1.0 / 1.5)
                }
            }
        } else {
            VStack(spacing: 0.0) {
                HStack(alignment: .top, spacing: 0.0) {
                    if zoomed {
                        HStack(spacing: 0.0) {
                            Spacer(minLength: 0.0)
                            ScrollView(.vertical) {
                                Text(mantissa)
                            }
                            if exponent != nil {
                                VStack(spacing: 0.0) {
                                    Text(exponent!)
                                        .padding(.leading, ePadding)
                                        .padding(.trailing, 0.0)
                                    Spacer(minLength: 0.0)
                                }
                            }
                        }
                        .frame(width: displayWidth, alignment: .trailing)
                        //.background(Color.blue)
                        .font(scaleFont ? largeFont : smallFont)
//                        .minimumScaleFactor(scaleFont ? 1.0/1.5 : 1.0)
                        .foregroundColor(isCopyingOrPasting ? isCopyingOrPastingColor : .white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .multilineTextAlignment(.trailing)
                    } else {
                        HStack(spacing: 0.0) {
                            Spacer(minLength: 0.0)
                            Text(mantissa)
                            if exponent != nil {
                                Text(exponent!)
                                    .padding(.leading, ePadding)
                                    .padding(.trailing, 0.0)
                            }
                        }
                        .frame(width: displayWidth, alignment: .trailing)
                        //.background(Color.blue)
                        .font(scaleFont ? largeFont : smallFont)
//                        .minimumScaleFactor(scaleFont ? 1.0/1.5 : 1.0)
                        .foregroundColor(isCopyingOrPasting ? isCopyingOrPastingColor : .white)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .multilineTextAlignment(.trailing)
                    }
                }
                Spacer()
            }
        }
    }
}
