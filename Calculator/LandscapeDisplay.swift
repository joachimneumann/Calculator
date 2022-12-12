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
    let width: CGFloat
    let ePadding: CGFloat
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
                                .fontWidth(C.fontWidth)
                                .kerning(C.kerning)
                        }
                        if displayData.longRight != nil {
                            VStack(spacing: 0.0) {
                                Text(displayData.longRight!)
                                    .fontWidth(C.fontWidth)
                                    .kerning(C.kerning)
                                    .padding(.leading, ePadding)
                                    .padding(.trailing, 0.0)
                                Spacer(minLength: 0.0)
                            }
                        }
                    }
                    .font(font)
                    .foregroundColor(isCopyingOrPasting ? isCopyingOrPastingColor : .white)
                    .multilineTextAlignment(.trailing)
                } else {
                    HStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        Text(displayData.shortLeft).foregroundColor(Color.white)
                            .fontWidth(C.fontWidth)
                            .kerning(C.kerning)
                        let exponent = displayData.shortRight
                        if exponent != nil {
                            Text(exponent!)
                                .fontWidth(C.fontWidth)
                                .kerning(C.kerning)
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
