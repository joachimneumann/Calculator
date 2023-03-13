//
//  KeyColor.swift
//  Calculator
//
//  Created by Joachim Neumann on 1/14/23.
//

import SwiftUI

struct KeyColor {
    private struct ThreeColors {
        var textColor: Color
        var upColor: Color
        var downColor: Color
        private init(textColor: Color, upColor: Color, downColor: Color) {
            self.textColor = textColor
            self.upColor = upColor
            self.downColor = downColor
        }
        init(_ textGrayscale: CGFloat, _ upGrayscale: CGFloat, _ downGrayscale: CGFloat) {
            self.init(textColor: Color(white: textGrayscale),
                      upColor:   Color(white: upGrayscale),
                      downColor: Color(white: downGrayscale))
        }
    }
    
#if os(macOS)
//    private let digitColors             = ThreeColors(0.90, 0.80, 0.45)
//    private let operatorColors          = ThreeColors(0.90, 0.40, 0.70)
//    private let pendingOperatorColors   = ThreeColors(0.30, 0.90, 0.80)
//    private let scientificColors        = ThreeColors(0.90, 0.30, 0.32)
//    private let pendingScientificColors = ThreeColors(0.30, 0.70, 0.60)
//    private let secondColors            = ThreeColors(0.90, 0.30, 0.12)
//    private let secondActiveColors      = ThreeColors(0.20, 0.60, 0.60)
    private let digitColors             = ThreeColors(1.000, 0.490, 0.690)
    private let operatorColors          = ThreeColors(0.925, 0.396, 0.498)
    private let pendingOperatorColors   = ThreeColors(0.300, 0.900, 0.800)
    private let scientificColors        = ThreeColors(0.925, 0.396, 0.498)
    private let pendingScientificColors = ThreeColors(0.300, 0.700, 0.600)
    private let secondColors            = ThreeColors(0.925, 0.396, 0.498)
    private let secondActiveColors      = ThreeColors(0.925, 0.300, 0.498)
#else
    private let digitColors             = ThreeColors(1.00, 0.20, 0.45)
    private let operatorColors          = ThreeColors(1.00, 0.50, 0.70)
    private let pendingOperatorColors   = ThreeColors(0.30, 0.90, 0.80)
    private let scientificColors        = ThreeColors(1.00, 0.12, 0.32)
    private let pendingScientificColors = ThreeColors(0.30, 0.70, 0.60)
    private let secondColors            = ThreeColors(1.00, 0.12, 0.12)
    private let secondActiveColors      = ThreeColors(0.20, 0.60, 0.60)
#endif
  
    private func color(for symbol: String, isPending pending: Bool) -> ThreeColors {
        if ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ",", "."].contains(symbol) {
            return digitColors
        } else if symbol == "2nd" {
            return secondColors
        } else if ["C", "AC", "±", "%", "/", "x", "-", "+", "="].contains(symbol) {
            return pending ? pendingOperatorColors : operatorColors
        } else {
            return pending ? pendingScientificColors : scientificColors
        }
    }

    func textColor(for symbol: String, isPending pending: Bool) -> Color {
        color(for: symbol, isPending: pending).textColor
    }
    func upColor(for symbol: String, isPending pending: Bool) -> Color {
        color(for: symbol, isPending: pending).upColor
    }
    func downColor(for symbol: String, isPending pending: Bool) -> Color {
        color(for: symbol, isPending: pending).downColor
    }
    func secondColor(active: Bool) -> Color {
        active ? secondActiveColors.upColor : secondColors.upColor
    }
    let disabledColor = Color.red
}
