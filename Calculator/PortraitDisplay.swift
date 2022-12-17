//
//  PortraitDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct PortraitDisplay: View {
    let displayData: DisplayData
    let screenInfo: ScreenInfo
    let lengths: Lengths
    
    var body: some View {
        let forceSmallFont = displayData.short.count == (displayData.short.contains("e") ? -1 : (displayData.short.contains(",") ? lengths.withCommaNonScientific : lengths.withoutComma))
        let _ = print("forceSmallFont \(forceSmallFont)")
        ZStack(alignment: .topTrailing) {
            HStack(alignment: .top, spacing: 0.0) {
//                Spacer(minLength: 0.0)
                if displayData.shortRight == nil {
                    Text(displayData.shortLeft)
                        .kerning(C.kerning)
                        .font(Font(screenInfo.uiFontLarge))
                        .minimumScaleFactor(screenInfo.largeFontScaleFactor)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .background(testColors ? .black : .black).opacity(testColors ? 0.9 : 1.0)
                        .lineLimit(1)
                        .frame(maxHeight: 300, alignment: .bottomTrailing)
                } else {
                    Text(displayData.shortLeft)
                        .kerning(C.kerning)
                        .font(Font(screenInfo.uiFont))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
                        .lineLimit(1)
                    Text(displayData.shortRight!)
                        .kerning(C.kerning)
                        .font(Font(screenInfo.uiFont))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
                        .lineLimit(1)
                        .padding(.leading, screenInfo.ePadding)
                }
            }
        }
//        VStack(spacing: 0.0) {
//            HStack(spacing: 0.0) {
//                Spacer(minLength: 0.0)
//                //let _ = print("displayData.shortLeft \(displayData.shortLeft)")
//                if displayData.shortRight == nil {
//                    Text(displayData.shortLeft)
//                        .fontWidth(C.fontWidth)
//                        .kerning(C.kerning)
//                        .font(Font(forceSmallFont ? screenInfo.uiFont : screenInfo.uiFontLarge))
//                        .minimumScaleFactor(1.0 / (forceSmallFont ? 1.0 : screenInfo.largeFontScaleFactor))
//                } else {
//                    /// exponential is always displayed with the small font
//                    Text(displayData.shortLeft)
//                        .fontWidth(C.fontWidth)
//                        .kerning(C.kerning)
//                        .font(Font(screenInfo.uiFont))
//                        .minimumScaleFactor(0.1)
//                    Text(displayData.shortRight!)
//                        .fontWidth(C.fontWidth)
//                        .kerning(C.kerning)
//                        .font(Font(screenInfo.uiFont))
//                        .padding(.leading, screenInfo.ePadding)
//                        .minimumScaleFactor(0.1)
//                    // todo: the minimumScaleFactor should not be necessary ??!?
//                    // However, without it the mantissa and exponent are sometimes abbreviated with '...'
//                }
//            }
//            .foregroundColor(.white)
//            .lineLimit(1)
//            .frame(maxHeight: .infinity, alignment: .bottomTrailing)
//            .multilineTextAlignment(.trailing)
//            Spacer()
//        }
    }
}
