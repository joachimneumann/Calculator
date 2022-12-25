//
//  DisplayData.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/24/22.
//

import SwiftUI

struct DisplayData {
    var left: String
    var right: String?
    var color: Color
    var showThreeDots: Bool
    var dotsWidth: CGFloat
    var canBeInteger: Bool
    var canBeFloat: Bool
    
    func fontSizeFactor(len: Int, maxLength: Int) -> CGFloat {
        let expandMin = 1.0
        let expandMax = 2.3
        
        let notOccupiedLength = CGFloat(len) / CGFloat(maxLength)
        var expand = expandMax - notOccupiedLength * (expandMax - expandMin)
        if expand > 1.5 { expand = 1.5 }
        if expand < 1.0 { expand = 1.0 }
        return expand
    }
    
    func dotsWidth(portraitMaxLength: Int, fontSize: CGFloat) -> CGFloat {
        var len = left.count
        if right != nil { len += right!.count }
        
        let factor = fontSizeFactor(len: len, maxLength: portraitMaxLength)
        let uiFont = UIFont.monospacedDigitSystemFont(ofSize: fontSize * factor, weight: C.fontWeight)
        return "0".textSize(for: uiFont).width
    }

}

extension DisplayData {
    init() {
        left = "0"
        right = nil
        color = .white
        showThreeDots = false
        dotsWidth = 0.0
        canBeInteger = false
        canBeFloat = false
    }
}
