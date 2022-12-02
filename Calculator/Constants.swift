//
//  Constants.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import SwiftUI

class ColorsOf: ObservableObject {
    @Published var textColor: UIColor
    @Published var upColor: UIColor
    @Published var downColor: UIColor
    init(textColor: UIColor, upColor: UIColor, downColor: UIColor) {
        self.textColor = textColor
        self.upColor = upColor
        self.downColor = downColor
    }
}

struct C {
    static let maxDigitsInLongDisplay = 1000
    
    private static let disabled = UIColor.red
    static let digitColors = ColorsOf(
        textColor: UIColor(.white),
        upColor:   UIColor(white: 0.2, alpha: 1.0),
        downColor: UIColor(white: 0.4, alpha: 1.0))
    static let disabledColor = UIColor.red
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
    static let _2ndColors = ColorsOf(
        textColor: UIColor(.white),
        upColor:   UIColor(white: 0.12, alpha: 1.0),
        downColor: UIColor(white: 0.12, alpha: 1.0))
    static let _2ndActiveColors = ColorsOf(
        textColor: UIColor(white: 0.2, alpha: 1.0),
        upColor:   UIColor(white: 0.6, alpha: 1.0),
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
        } else if symbol == "2nd" {
            return _2ndColors
        } else if symbol == "plusKey" {
            return operatorColors
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
    static let iconKeys = ["plusKey"]
    static let allKeys = [digitKeys, operatorKeys, scientificKeys, iconKeys].joined()
    static let requireValidNumber = ["±", "%", "/", "x", "-", "+", "=", "( ", " )", "m+", "m-", "mr", "x^2", "x^3", "x^y", "e^x", "y^x", "2^x", "10^x", "One_x", "√", "3√", "y√", "logy", "ln", "log2", "log10", "x!", "sin", "cos", "tan", "asin", "acos", "atan", "EE", "sinh", "cosh", "tanh", "asinh", "acosh", "atanh", "plusKey"]
    static let scientificPendingOperations = ["y√", "x^y", "y^x", "logy", "x↑↑y", "EE"]
}

extension Int {
    func remainderInWords(_ remainder: String) -> String {
        if remainder == "1" { return "one" }
        if remainder == "10" { return "ten" }
        return remainder
    }
    var useWords: String {
        let ret = "\(self)"
        if ret.hasSuffix("000000000000") {
            let remainder = String(ret.dropLast(12))
            return remainderInWords(remainder) + " trillion"
        }
        if ret.hasSuffix("000000000") {
            let remainder = String(ret.dropLast(9))
            return remainderInWords(remainder) + " billion"
        }
        if ret.hasSuffix("000000") {
            let remainder = String(ret.dropLast(6))
            return remainderInWords(remainder) + " million"
        }
        if ret.hasSuffix("000") {
            let remainder = String(ret.dropLast(3))
            return remainderInWords(remainder) + " thousand"
        }
        return ret
    }
}