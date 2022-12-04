//
//  OneLineDisplayCalibration.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/1/22.
//

import SwiftUI

struct LengthMeasurementResult {
    let withoutComma: Int
    let withCommaNonScientific: Int
    let withCommaScientific: Int
    let ePadding: CGFloat
}

func lengthMeasurement(size: CGSize, fontSize: CGFloat) -> LengthMeasurementResult {
    let uiFont = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .thin)
    var s = ""
    var w = s.length(for: uiFont)
    while w < size.width {
        s.append("0")
        w = s.length(for: uiFont)
    }
    let withoutComma = s.count - 1
    
    s = ","
    w = s.length(for: uiFont)
    while w < size.width {
        s.append("0")
        w = s.length(for: uiFont)
    }
    let withCommaNonScientific = s.count - 1
    
    let ePadding = fontSize * 2.0
    print("ePadding set to \(ePadding)")
    s = ",e"
    w = s.length(for: uiFont)
    while w < (size.width - ePadding) {
        s.append("0")
        w = s.length(for: uiFont)
    }
    let withCommaScientific = s.count - 1
    
    let result = LengthMeasurementResult(
        withoutComma: withoutComma,
        withCommaNonScientific: withCommaNonScientific,
        withCommaScientific: withCommaScientific,
        ePadding: ePadding)
    print("OneLineDisplayCalibration \(result)")
    return result
}

    
fileprivate extension String {
    func length(for uiFont: UIFont) -> CGFloat {
        let fontAttribute = [NSAttributedString.Key.font: uiFont]
        let size = self.size(withAttributes: fontAttribute)  // for Single Line
        return size.width;
    }
}
