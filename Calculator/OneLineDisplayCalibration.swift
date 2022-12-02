//
//  OneLineDisplayCalibration.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/1/22.
//

import SwiftUI

func lengthMeasurement(size: CGSize, fontSize: CGFloat) -> [Int] {
    let uiFont = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .thin)
    var w = 0.0
    var s = ""
    while w < size.width {
        s.append("0")
        w = s.length(for: uiFont)
    }
    let without = s.count - 1
    
    w = 0.0
    s = ","
    while w < size.width {
        s.append("0")
        w = s.length(for: uiFont)
    }
    let with = s.count - 1
    print("OneLineDisplayCalibration \([with, without])")
    return [with, without]
}

    
fileprivate extension String {
    func length(for uiFont: UIFont) -> CGFloat {
        let fontAttribute = [NSAttributedString.Key.font: uiFont]
        let size = self.size(withAttributes: fontAttribute)  // for Single Line
        return size.width;
    }
}
