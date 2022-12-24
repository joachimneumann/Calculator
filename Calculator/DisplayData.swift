//
//  DisplayData.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/24/22.
//

import UIKit

struct DisplayData {
    var left: String = "0"
    var portraitMaxLength = 1000
    var right: String? = nil
    var isInteger = false
    var isFloat = false
    var isAbbreviated = false // show a message that there is more?
    var isPreliminary = false
    var isOld = true
    var digitWidth: CGFloat = 0.0
    var uiFont: UIFont = UIFont()
}
