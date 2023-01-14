//
//  KeyColor.swift
//  Calculator
//
//  Created by Joachim Neumann on 1/14/23.
//

import SwiftUI

struct KeyColor {
    struct Colors {
        var textColor: Color
        var upColor: Color
        var downColor: Color
        init(_ textColor: Color, _ upColor: Color, _ downColor: Color) {
            self.textColor = textColor
            self.upColor = upColor
            self.downColor = downColor
        }
        init(_ textGrayscale: CGFloat, _ upGrayscale: CGFloat, _ downGrayscale: CGFloat) {
            self.init(Color(white: textGrayscale), Color(white: upGrayscale), Color(white: downGrayscale))
        }
    }
    
    private let digitColors             = Colors(1.00, 0.20, 0.45)
    private let operatorColors          = Colors(1.00, 0.50, 0.70)
    private let pendingOperatorColors   = Colors(0.30, 0.90, 0.80)
    private let scientificColors        = Colors(1.00, 0.12, 0.32)
    private let pendingScientificColors = Colors(0.30, 0.70, 0.60)
    let secondColors            = Colors(1.00, 0.12, 0.12)
    let secondActiveColors      = Colors(0.20, 0.60, 0.60)
    let disabledColor = Color.red
  
    func color(for symbol: String, isPending pending: Bool) -> Colors {
        if ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ","].contains(symbol) {
            return digitColors
        } else if symbol == "2nd" {
            return secondColors
        } else if ["C", "AC", "±", "%", "/", "x", "-", "+", "="].contains(symbol) {
            return pending ? pendingOperatorColors : operatorColors
        } else {
            return pending ? pendingScientificColors : scientificColors
        }
    }

}
