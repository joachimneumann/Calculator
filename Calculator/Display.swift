//
//  Display.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/25/22.
//

import SwiftUI

struct Display {
    let data: DisplayData
    let format: DisplayFormat
    
    init(number: Number,
         isPreliminary: Bool,
         screenInfo: ScreenInfo,
         lengths: Lengths,
         forceScientific: Bool,
         showAsInteger: Bool,
         showAsFloat: Bool
    ) {
        data = number.getDisplayData(
            multipleLines: !isPreliminary && !screenInfo.isPortraitPhone,
            lengths: lengths,
            forceScientific: forceScientific,
            showAsInteger: showAsInteger,
            showAsFloat: showAsFloat)
        format = DisplayFormat(
            for: data.length,
            withMaxLength: data.maxlength,
            fontSize: screenInfo.uiFontSize,
            showThreeDots: isPreliminary)
    }
}

extension Display {
    init() {
        data = DisplayData(left: "0", maxlength: 0, showThreeDots: false, canBeInteger: false, canBeFloat: false)
        format = DisplayFormat(for: 0, withMaxLength: 0, fontSize: 0, showThreeDots: false)
    }
}

struct DisplayData {
    var left: String
    var right: String?
    var maxlength: Int
    var showThreeDots: Bool
    var canBeInteger: Bool
    var canBeFloat: Bool
    
    var oneLine: String {
        left + (right ?? "")
    }
    var length: Int {
        var ret = left.count
        if right != nil { ret += right!.count }
        return ret
    }
}

extension DisplayData {
    init() {
        left = "0"
        right = nil
        maxlength = 0
        showThreeDots = false
        canBeInteger = false
        canBeFloat = false
    }
}

struct DisplayFormat {
    let font: Font
    let color: Color
    let dotsWidth: CGFloat
    let showThreeDots: Bool
    
    init(for length: Int, withMaxLength maxLength: Int, fontSize: CGFloat, showThreeDots: Bool) {
        let factorMin = 1.0
        let factorMax = 2.3
        
        let notOccupiedLength = CGFloat(length) / CGFloat(maxLength)
        var factor = factorMax - notOccupiedLength * (factorMax - factorMin)
        if factor > 1.5 { factor = 1.5 }
        if factor < 1.0 { factor = 1.0 }

        let uiFont = UIFont.monospacedDigitSystemFont(ofSize: fontSize * factor, weight: C.fontWeight)
        
        font = Font(uiFont)
        color = showThreeDots ? .gray : .white
        dotsWidth = "0".textSize(for: uiFont).width
        self.showThreeDots = showThreeDots
    }
}

extension DisplayFormat {
    init() {
        font = Font(UIFont())
        color = Color.white
        dotsWidth = 100
        showThreeDots = false
    }
}
