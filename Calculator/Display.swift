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
         screen: Screen,
         forceScientific: Bool,
         showAsInteger: Bool,
         showAsFloat: Bool
    ) {
        data = number.getDisplayData(
            multipleLines: !isPreliminary && !screen.isPortraitPhone,
            lengths: screen.lengths,
            forceScientific: forceScientific,
            showAsInteger: showAsInteger,
            showAsFloat: showAsFloat)
        format = DisplayFormat(
            for: data.length,
            withMaxLength: data.maxlength,
            showThreeDots: isPreliminary,
            screen: screen)
    }
}

extension Display {
    init(screen: Screen) {
        data = DisplayData(left: "0", maxlength: 0, canBeInteger: false, canBeFloat: false)
        format = DisplayFormat(for: 1, withMaxLength: 1, showThreeDots: false, screen: screen)
    }
}

struct DisplayData {
    var left: String
    var right: String?
    var maxlength: Int
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
        canBeInteger = false
        canBeFloat = false
    }
}

struct DisplayFormat {
    let font: Font
    let color: Color
    let showThreeDots: Bool
    let digitWidth: CGFloat
    let ePadding: CGFloat

    init(for length: Int, withMaxLength maxLength: Int, showThreeDots: Bool, screen: Screen) {
        var factor = 1.0
        
        if screen.isPortraitPhone {
            let factorMin = 1.0
            let factorMax = 2.3
            
            let notOccupiedLength = CGFloat(length) / CGFloat(maxLength)
            factor = factorMax - notOccupiedLength * (factorMax - factorMin)
            if factor > 1.5 { factor = 1.5 }
            if factor < 1.0 { factor = 1.0 }
        }
        
        let uiFont = UIFont.monospacedDigitSystemFont(ofSize: screen.uiFontSize * factor, weight: C.fontWeight)
        
        font = Font(uiFont)
        color = showThreeDots ? .gray : .white
        self.showThreeDots = showThreeDots
        self.digitWidth = screen.lengths.digitWidth
        self.ePadding = screen.lengths.ePadding
    }
}

extension DisplayFormat {
    init() {
        font = Font(UIFont())
        color = Color.white
        showThreeDots = false
        digitWidth = 0.0
        ePadding = 0.0
    }
}
