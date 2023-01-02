//
//  Constants.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import SwiftUI

class ColorsOf {
    var textColor: Color
    var upColor: Color
    var downColor: Color
    init(textColor: Color, upColor: Color, downColor: Color) {
        self.textColor = textColor
        self.upColor = upColor
        self.downColor = downColor
    }
}

struct C {    
    static let appBackground: Color = .black
    static let digitColors = ColorsOf(
        textColor: .white,
        upColor:   Color(white: 0.3),
        downColor: Color(white: 0.4))
    static let disabledColor = Color.red
    static let operatorColors = ColorsOf(
        textColor: Color(.white),
        upColor:   Color(white: 0.5),
        downColor: Color(white: 0.7))
    static let pendingOperatorColors = ColorsOf(
        textColor: Color(white: 0.3),
        upColor:   Color(white: 0.9),
        downColor: Color(white: 0.8))
    static let scientificColors = ColorsOf(
        textColor: Color(.white),
        upColor:   Color(white: 0.12),
        downColor: Color(white: 0.32))
    static let pendingScientificColors = ColorsOf(
        textColor: Color(white: 0.3),
        upColor:   Color(white: 0.7),
        downColor: Color(white: 0.6))
    static let secondColors = ColorsOf(
        textColor: Color(.white),
        upColor:   Color(white: 0.12),
        downColor: Color(white: 0.12))
    static let secondActiveColors = ColorsOf(
        textColor: Color(white: 0.2),
        upColor:   Color(white: 0.6),
        downColor: Color(white: 0.6))
    
    static func spaceBetween(keyWidth: CGFloat) -> CGFloat {
        0.1 * keyWidth
    }

    static func doubleKeyWidth(keyWidth : CGFloat) -> CGFloat {
        2 * keyWidth + spaceBetween(keyWidth: keyWidth)
    }

    static let keysForDigits: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    static let keysOfOperator = ["C", "AC", "±", "%", "/", "x", "-", "+", "="]
    static let keysOfScientificOperators = [
        "( ", " )", "mc", "m+", "m-", "mr",
        "2nd", "x^2", "x^3", "x^y", "e^x", "y^x", "2^x", "10^x",
        "One_x", "√", "3√", "y√", "logy", "ln", "log2", "log10",
        "x!", "sin", "cos", "tan", "asin", "acos", "atan", "e", "EE",
        "Deg", "Rad", "sinh", "cosh", "tanh", "asinh", "acosh", "atanh", "π", "Rand"]
    static let keysAll = [keysForDigits, [","], keysOfOperator, keysOfScientificOperators].joined()
    static let keysThatHavePendingOperation = ["/", "x", "-", "+", "x^y", "y^x"]
    static let keysThatRequireValidNumber = ["±", "%", "/", "x", "-", "+", "=", "( ", " )", "m+", "m-", "mr", "x^2", "x^3", "x^y", "e^x", "y^x", "2^x", "10^x", "One_x", "√", "3√", "y√", "logy", "ln", "log2", "log10", "x!", "sin", "cos", "tan", "asin", "acos", "atan", "EE", "sinh", "cosh", "tanh", "asinh", "acosh", "atanh"]
    static let keysThatDoNotNeedToBeDisabled = ["2nd", "Rad", "Deg"]
    static let keysToDisable = C.keysAll.filter {!C.keysThatDoNotNeedToBeDisabled.contains($0)}

    static let fontWeight: UIFont.Weight = .thin // UIFont.Weight(rawValue: -4.02) is not continuous
    static var kerning: CGFloat = 0.0
    static let preliminaryDelay = 0.3 /// seconds
    static let sfImageforKey: [String: String] = [
        "+": "plus",
        "-": "minus",
        "x": "multiply",
        "/": "divide",
        "±": "plus.slash.minus",
        "=": "equal",
        "%": "percent",
    ]

}

extension Int {
    func remainderInWords(_ remainder: String) -> String {
        if remainder == "1" { return "one" }
        if remainder == "10" { return "ten" }
        return remainder
    }
    var useWords: String {
        let asString = "\(self)"
        if asString.hasSuffix("000000000000") {
            let remainder = String(asString.dropLast(12))
            if remainder.count < 4 {
                return remainderInWords(remainder) + " trillion"
            } else {
                return "\(self)"
            }
        }
        if asString.hasSuffix("000000000") {
            let remainder = String(asString.dropLast(9))
            if remainder.count < 4 {
                return remainderInWords(remainder) + " billion"
            } else {
                return "\(self)"
            }
        }
        if asString.hasSuffix("000000") {
            let remainder = String(asString.dropLast(6))
            if remainder.count < 4 {
                return remainderInWords(remainder) + " million"
            } else {
                return "\(self)"
            }
        }
        if asString.hasSuffix("000") {
            let remainder = String(asString.dropLast(3))
            if remainder.count < 4 {
                return remainderInWords(remainder) + " thousand"
            } else {
                return "\(self)"
            }
        }
        return "\(self)"
    }
    var asMemorySize: String {
        let d = Double(self)
        if d > 1e9 {
            return String(format: "%.1fGB", d / 1e9)
        }
        if d > 1e6 {
            return String(format: "%.1fMB", d / 1e6)
        }
        if d > 1e3 {
            return String(format: "%.1fKB", d / 1e3)
        }
        return String(format: "%.0f bytes", d)
    }}

extension Double {
    var asTime: String {
        if self < 1e-6 {
            return String(format: "%.1f microseconds", 1e6 * self)
        }
        if self < 1e-4 {
            return String(format: "%.1f microseconds", 1e6 * self)
        }
        if self < 0.1 {
            return String(format: "%.1f milliseconds", 1e3 * self)
        }
        if self < 0 {
            return String(format: "%.3f seconds", self)
        }
        if self < 10 {
            return String(format: "%.1f seconds", self)
        }
        if self < 60 {
            return String(format: "%.0f seconds", self)
        }
        return String(format: "%.1f hours", self/3600.0)
    }
}
