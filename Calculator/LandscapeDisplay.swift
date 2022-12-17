//
//  LandscapeDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct LandscapeDisplay: View {
    let isZoomed: Bool
    let displayData: DisplayData
    let displayHeight: CGFloat
    let screenInfo: ScreenInfo
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(alignment: .top, spacing: 0.0) {
                Spacer(minLength: 0.0)
                Text(displayData.longLeft)
                    .kerning(C.kerning)
                    .font(Font(screenInfo.uiFont))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.trailing)
                    .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
                    .lineLimit(nil)
                if displayData.longRight != nil {
                    Text(displayData.longRight!)
                        .kerning(C.kerning)
                        .font(Font(screenInfo.uiFont))
                        .foregroundColor(.white)
                        .padding(.leading, screenInfo.ePadding)
                }
            }
            Rectangle()
            // the rectangle is needed for integers that are too large for a single line, but small enough to be displayed as Integer when zoomed
            // Text().background does not cover the ePadding
                .foregroundColor(.black)
                .frame(width: screenInfo.calculatorSize.width - screenInfo.plusIconSize - screenInfo.plusIconLeftPadding, height: displayHeight)
                .opacity(isZoomed ? 0.0 : 1.0)
            HStack(alignment: .top, spacing: 0.0) {
                Text(displayData.shortLeft)
                    .kerning(C.kerning)
                    .font(Font(screenInfo.uiFont))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .opacity(isZoomed ? 0.0 : 1.0)
                if displayData.shortRight != nil {
                    Text(displayData.shortRight!)
                        .kerning(C.kerning)
                        .font(Font(screenInfo.uiFont))
                        .foregroundColor(.white)
                        .padding(.leading, screenInfo.ePadding)
                        .opacity(isZoomed ? 0.0 : 1.0)
                }
            }
        }
    }
    /*
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
     */
}
