//
//  OneLineDisplayCalibration.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/1/22.
//

import SwiftUI

func oneLineDisplayCalibration(size: CGSize, fontSize: CGFloat) -> [Int] {
    print("OneLineDisplayCalibration init()")
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
    return [with, without]
}

    
fileprivate extension String {
    func length(for uiFont: UIFont) -> CGFloat {
        let fontAttribute = [NSAttributedString.Key.font: uiFont]
        let size = self.size(withAttributes: fontAttribute)  // for Single Line
        return size.width;
    }
}
