//
//  Constants.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import UIKit

struct ColorsOf {
    var textColor: UIColor
    var upColor: UIColor
    var downColor: UIColor
}

struct C {
    private static let disabled = UIColor(red: 0.4, green: 0.2, blue: 0.2, alpha: 1.0)
    static let digitColors = ColorsOf(
        textColor: UIColor(.white),
        upColor:   UIColor(white: 0.2, alpha: 1.0),
        downColor: UIColor(white: 0.4, alpha: 1.0))
    static let disabledColors = ColorsOf(
        textColor: UIColor(.white),
        upColor:   disabled,
        downColor: disabled)
    static let operatorColors = ColorsOf(
        textColor: UIColor(.white),
        upColor:   UIColor(white: 0.5, alpha: 1.0),
        downColor: UIColor(white: 0.7, alpha: 1.0))
    static let pendingOperatorColors = ColorsOf(
        textColor: UIColor(white: 0.3, alpha: 1.0),
        upColor:   UIColor(white: 0.9, alpha: 1.0),
        downColor: UIColor(white: 0.8, alpha: 1.0))
    static let scientificColors = ColorsOf(
        textColor: UIColor(.white),
        upColor:   UIColor(white: 0.12, alpha: 1.0),
        downColor: UIColor(white: 0.32, alpha: 1.0))
    static let pendingScientificColors = ColorsOf(
        textColor: UIColor(white: 0.3, alpha: 1.0),
        upColor:   UIColor(white: 0.7, alpha: 1.0),
        downColor: UIColor(white: 0.6, alpha: 1.0))
    static func spaceBetweenkeysFraction(withScientificKeys: Bool) -> CGFloat {
        if withScientificKeys {
            return 0.012
        } else {
            return 0.02
        }
    }
    static func getKeyColors(for symbol: String) -> ColorsOf {
        if digitKeys.contains(symbol) {
            return digitColors
        } else if operatorKeys.contains(symbol) {
            return operatorColors
        } else if scientificKeys.contains(symbol) {
            return scientificColors
        }
        return digitColors
    }

    
    static let digitKeys = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ","]
    static let operatorKeys = ["C", "AC", "±", "%", "/", "x", "-", "+", "="]
    static let scientificKeys = [
        "( ", " )", "mc", "m+", "m-", "mr",
        "2nd", "x^2", "x^3", "x^y", "e^x", "y^x", "2^x", "10^x",
        "One_x", "√", "3√", "y√", "logy", "ln", "log2", "log10",
        "x!", "sin", "cos", "tan", "asin", "acos", "atan", "e", "EE",
        "Deg", "Rad", "sinh", "cosh", "tanh", "asinh", "acosh", "atanh", "π", "Rand"]
    static let allKeys = [digitKeys, operatorKeys, scientificKeys].joined()
    static let requireValidNumber = ["±", "%", "/", "x", "-", "+", "=", "( ", " )", "m+", "m-", "mr", "x^2", "x^3", "x^y", "e^x", "y^x", "2^x", "10^x", "One_x", "√", "3√", "y√", "logy", "ln", "log2", "log10", "x!", "sin", "cos", "tan", "asin", "acos", "atan", "EE", "sinh", "cosh", "tanh", "asinh", "acosh", "atanh"]
    static let scientificPendingOperations = ["y√", "x^y", "y^x", "logy", "x↑↑y", "EE"]
    
    static let notificationDictionaryKey = "key"
    static let notificationNameDown      = "keyDownEvent"
    static let notificationNameUp        = "keyUpEvent"
}

extension Int {
    var useWords: String {
        let ret = "\(self)"
        if ret.hasSuffix("000000000000") {
            var substring1 = ret.dropLast(12)
            substring1 = substring1 + " trillion"
            return String(substring1)
        }
        if ret.hasSuffix("000000000") {
            var substring1 = ret.dropLast(9)
            substring1 = substring1 + " billion"
            return String(substring1)
        }
        if ret.hasSuffix("000000") {
            var substring1 = ret.dropLast(6)
            substring1 = substring1 + " million"
            return String(substring1)
        }
        if ret.hasSuffix("000") {
            var substring1 = ret.dropLast(3)
            substring1 = substring1 + " thousand"
            return String(substring1)
        }
        return ret
    }
}
