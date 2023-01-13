//
//  LengthMeasurement.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/1/22.
//

import SwiftUI

struct Lengths {
    let withoutComma: Int
    let withCommaNonScientific: Int
    let withCommaScientific: Int
    let height: CGFloat
    let digitWidth: CGFloat
    let infoHeight: CGFloat
    let ePadding: CGFloat
    
    init(withoutComma: Int, withCommaNonScientific: Int, withCommaScientific: Int, height: CGFloat, digitWidth: CGFloat, infoHeight: CGFloat, ePadding: CGFloat) {
        self.withoutComma = withoutComma
        self.withCommaNonScientific = withCommaNonScientific
        self.withCommaScientific = withCommaScientific
        self.height = height
        self.digitWidth = digitWidth
        self.infoHeight = infoHeight
        self.ePadding = ePadding
    }
    init(_ len: Int) {
        self.init(withoutComma: len, withCommaNonScientific: len, withCommaScientific: len, height: 0.0, digitWidth: 0.0, infoHeight: 0.0, ePadding: 0.0)
    }
}

// To debug length errors add this in Calculator:
//let fontAttribute = [NSAttributedString.Key.font: screenInfo.uiFont]
//let xxx = model.displayData.longLeft.size(withAttributes: fontAttribute)  // for Single Line
//let xxx = "0".size(withAttributes: fontAttribute)  // for Single Line
//let _ = print("Calculator len \(model.displayData.longLeft) \(xxx.width)")


func lengthMeasurement(width: CGFloat, uiFont: UIFont, infoUiFont: UIFont, ePadding: CGFloat, kerning: CGFloat) -> Lengths {
    let digitWidth = "0".textSize(for: uiFont, kerning: kerning).width
    let height     = "0".textSize(for: uiFont, kerning: kerning).height
    let commaWidth = ",".textSize(for: uiFont, kerning: kerning).width
    let eWidth     = "e".textSize(for: uiFont, kerning: kerning).width

    let withoutComma           = Int(  width                                   / digitWidth)
    let withCommaNonScientific = Int( (width - commaWidth)                     / digitWidth) + 1
    let withCommaScientific    = Int( (width - commaWidth - eWidth - ePadding) / digitWidth) + 2

    //print("measurement: ePadding = \(ePadding)")
    let result = Lengths(
        withoutComma: withoutComma,
        withCommaNonScientific: withCommaNonScientific,
        withCommaScientific: withCommaScientific,
        height: height,
        digitWidth: digitWidth,
        infoHeight: "info".textSize(for: infoUiFont, kerning: kerning).height,
        ePadding: ePadding)
    // print("lengthMeasurement \(result)")
    return result
}

    
extension String {
    func textSize(for uiFont: UIFont, kerning: CGFloat) -> CGSize {
        //  attrString.addAttribute(NSAttributedStringKey.kern, value: 2, range: NSMakeRange(0, attrString.length))

        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[.kern] = kerning
//        attributes[.strokeWidth] = 300
        attributes[.font] = uiFont
//        let fontAttribute = [NSAttributedString.Key.font: uiFont]
        let size = self.size(withAttributes: attributes)  // for Single Line
        return size;
    }
}
