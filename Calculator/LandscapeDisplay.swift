//
//  LandscapeDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct LandscapeDisplay: View {
    let zoomed: Bool
    let displayData: DisplayData
//    let mantissa: String
//    let exponent: String?
    let ePadding: CGFloat
//    let abbreviated: Bool
    let font: Font
    let isCopyingOrPasting: Bool
    let precisionString: String
    
    private let isCopyingOrPastingColor = Color(
        red:    118.0/255.0,
        green:  250.0/255.0,
        blue:   113.0/255.0)
    
    var body: some View {
        VStack(spacing: 0.0) {
            HStack(alignment: .top, spacing: 0.0) {
                if zoomed {
                    HStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        ScrollView(.vertical) {
                            Text(displayData.longLeft)
                        }
                        if displayData.longRight != nil {
                            VStack(spacing: 0.0) {
                                Text(displayData.longRight!)
                                    .padding(.leading, ePadding)
                                    .padding(.trailing, 0.0)
                                Spacer(minLength: 0.0)
                            }
                        }
                    }
                    .font(font)
                    .foregroundColor(isCopyingOrPasting ? isCopyingOrPastingColor : .white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .multilineTextAlignment(.trailing)
                } else {
                    HStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        Text(displayData.shortLeft).foregroundColor(Color.white)
                        let exponent = displayData.shortRight
                        if exponent != nil {
                            Text(exponent!)
                                .padding(.leading, ePadding)
                                .padding(.trailing, 0.0)
                        }
                    }
                    .font(font)
                    .foregroundColor(isCopyingOrPasting ? isCopyingOrPastingColor : .white)
                }
            }
            Spacer()
        }
    }
}
