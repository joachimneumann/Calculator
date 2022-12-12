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

func lengthMeasurement(width: CGFloat, fontSize: CGFloat, ePadding: CGFloat) -> Lengths {
    let uiFont = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .thin)
    var s = ""
    var w = s.length(for: uiFont)
    while w < width {
        s.append("0")
        w = s.length(for: uiFont)
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
        let fontAttribute = [NSAttributedString.Key.font: uiFont]
        let size = self.size(withAttributes: fontAttribute)  // for Single Line
        return size.width;
    }
}
