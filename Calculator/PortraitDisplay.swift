//
//  PortraitDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct PortraitDisplay: View {
    let highprecisionDisplayData: DisplayData?
    let lowPrecisionDisplayData: DisplayData?
    let screenInfo: ScreenInfo
    let digitWidth: CGFloat
    
    struct PortraitFontInfo {
        let font: Font
        let digitWidth: CGFloat
    }
    
    func fontSizeFactor(len: Int, maxLength: Int) -> CGFloat {
        let expandMin = 1.0
        let expandMax = 2.3
        
        let notOccupiedLength = CGFloat(len) / CGFloat(maxLength)
        var expand = expandMax - notOccupiedLength * (expandMax - expandMin)
        if expand > 1.5 { expand = 1.5 }
        if expand < 1.0 { expand = 1.0 }
        return expand
    }
    
    func portraitFontInfo(for displayData: DisplayData) -> PortraitFontInfo {
        var len = displayData.left.count
        if displayData.right != nil { len += displayData.right!.count }
        
        let factor = fontSizeFactor(len: len, maxLength: displayData.portraitMaxLength)
        if factor == 1.0 {
            return PortraitFontInfo(
                font: Font(screenInfo.uiFont),
                digitWidth: digitWidth)
        } else {
            let uiFont = UIFont.monospacedDigitSystemFont(ofSize: screenInfo.uiFontSize * factor, weight: C.fontWeight)
            let digitSize = "0".textSize(for: uiFont)
            return PortraitFontInfo(
                font: Font(uiFont),
                digitWidth: digitSize.width)
        }
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0.0) {
            Spacer(minLength: 0.0)
            let displayData = highprecisionDisplayData ?? (lowPrecisionDisplayData ?? DisplayData())
            let preliminary = highprecisionDisplayData == nil && lowPrecisionDisplayData != nil

            let toShow = preliminary && displayData.left.count > 1 ? String(displayData.left.dropLast()) : displayData.left
            let portraitFontInfo = portraitFontInfo(for: displayData)
            Text(toShow)
                .kerning(C.kerning)
                .font(portraitFontInfo.font)
                .foregroundColor(preliminary ? .gray : .white)
                .multilineTextAlignment(.trailing)
                .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
                .lineLimit(1)
            if preliminary {
                AnimatedDots().frame(width: portraitFontInfo.digitWidth, height: portraitFontInfo.digitWidth / 3)
                    .offset(y: -portraitFontInfo.digitWidth / 3)
            }
            if displayData.right != nil {
                Text(displayData.right!)
                    .kerning(C.kerning)
                    .font(portraitFontInfo.font)
                    .foregroundColor(preliminary ? .gray : .white)
                    .multilineTextAlignment(.trailing)
                    .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
                    .lineLimit(1)
                    .padding(.leading, screenInfo.ePadding)
            }
        }
    }
}
