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
    let ePadding: CGFloat
    
    init(withoutComma: Int, withCommaNonScientific: Int, withCommaScientific: Int, ePadding: CGFloat) {
        self.withoutComma = withoutComma
        self.withCommaNonScientific = withCommaNonScientific
        self.withCommaScientific = withCommaScientific
        self.ePadding = ePadding
    }
    init(_ len: Int) {
        self.init(withoutComma: len, withCommaNonScientific: len, withCommaScientific: len, ePadding: 0)
    }
}

// To debug length errors add this in Calculator:
//let fontAttribute = [NSAttributedString.Key.font: screenInfo.uiFont]
//let xxx = model.displayData.longLeft.size(withAttributes: fontAttribute)  // for Single Line
//let xxx = "0".size(withAttributes: fontAttribute)  // for Single Line
//let _ = print("Calculator len \(model.displayData.longLeft) \(xxx.width)")


func lengthMeasurement(width: CGFloat, uiFont: UIFont, ePadding: CGFloat) -> Lengths {
    // print("lengthMeasurement w =\(width)")
    var s = ""
    var w = s.length(for: uiFont)
    while w < width {
        s.append("0")
        w = s.length(for: uiFont)
        // print("measure \(s) \(w)")
    }
    let withoutComma = s.count - 1
    
    s = ","
    w = s.length(for: uiFont)
    while w < width {
        s.append("0")
        w = s.length(for: uiFont)
    }
    let withCommaNonScientific = s.count - 1
    
    //print("ePadding set to \(ePadding)")
    s = ",e"
    w = s.length(for: uiFont)
    while w < (width - ePadding) {
        s.append("0")
        w = s.length(for: uiFont)
    }
    let withCommaScientific = s.count - 1

    let result = Lengths(
        withoutComma: withoutComma,
        withCommaNonScientific: withCommaNonScientific,
        withCommaScientific: withCommaScientific,
        ePadding: ePadding)
    // print("lengthMeasurement \(result)")
    return result
}

    
fileprivate extension String {
    func length(for uiFont: UIFont) -> CGFloat {
        //  attrString.addAttribute(NSAttributedStringKey.kern, value: 2, range: NSMakeRange(0, attrString.length))

        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[.kern] = C.kerning
//        attributes[.strokeWidth] = 300
        attributes[.font] = uiFont
//        let fontAttribute = [NSAttributedString.Key.font: uiFont]
        let size = self.size(withAttributes: attributes)  // for Single Line
        return size.width;
    }
}
