//
//  KeyModel.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/20/22.
//

import SwiftUI


class CalculatorModel: ObservableObject {
    let brain: Brain
    @Published var _2ndActive = false
    @Published var _rad = false
    @Published var _AC = true
    @Published var _hasBeenReset = false
    @Published var _isCalculating = false
    @Published var last: String = "0"
    @Published var precisionDescription = "unknown"
    var oneLineWithoutCommaLength: Int = 4
    var oneLineWithCommaLength: Int = 4

    init() {
        brain = Brain(precision: 1000000)
        brain.pendingOperatorCallback = pendingOperatorCallback
        brain.haveResultCallback = haveResultCallback
        brain.isCalculatingCallback = isCalculatingCallback

        for key in [digitKeys, operatorKeys, scientificKeys].joined() {
            self.allKeyColors[key] = self.getKeyColors(for: key, enabled: true, pending: false)
        }
        self.precisionDescription = self.brain.precision.useWords
    }

    private func haveResultCallback(n: Number) {
        if n.isNull {
            DispatchQueue.main.async {
                self._AC = true
            }
        } else {
            DispatchQueue.main.async {
                self._AC = false
            }
        }
        let res = n.multipleLines(withoutComma: oneLineWithoutCommaLength, withComma: oneLineWithCommaLength)
        DispatchQueue.main.async {
            self.last = res.oneLine
            self.precisionDescription = self.brain.precision.useWords
        }
    }

    private func isCalculatingCallback(calculating: Bool) {
        if calculating {
            DispatchQueue.main.async {
                self._isCalculating = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    for key in [self.digitKeys, self.operatorKeys, self.scientificKeys].joined() {
                        if self._isCalculating {
                            self.allKeyColors[key] = self.getKeyColors(for: key, enabled: false, pending: false)
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self._isCalculating = false
                for key in [self.digitKeys, self.operatorKeys, self.scientificKeys].joined() {
                    if self.brain.isValidNumber {
                        self.allKeyColors[key] = self.getKeyColors(for: key, enabled: true, pending: self.lastPending == key )
                    } else {
                        if self.requireValidNumber.contains(key) {
                            /// TODO: also disable the button!!! combine color and status!!!
                            self.allKeyColors[key] = self.getKeyColors(for: key, enabled: false, pending: self.lastPending == key )
                        } else {
                            self.allKeyColors[key] = self.getKeyColors(for: key, enabled: true, pending: self.lastPending == key )
                        }
                    }
                }
            }
        }
    }
    func pressed(symbol: String) {
        if symbol == "2nd" {
            _2ndActive.toggle()
            if _2ndActive {
                withAnimation() {
                    allKeyColors["2nd"] = getKeyColors(for: "2nd", enabled: true, pending: _2ndActive)
                }
            } else {
                withAnimation() {
                    allKeyColors["2nd"] = getKeyColors(for: "2nd", enabled: true, pending: _2ndActive)
                }
            }
            return
        }
        if symbol == "Deg" {
            withAnimation() {
                _rad = true
            }
            return
        }
        if symbol == "Rad" {
            withAnimation() {
                _rad = false
            }
            return
        }
        if !_isCalculating {
            if symbol == "AC" {
                _hasBeenReset = true
                brain.asyncOperation("AC")
            } else {
                _hasBeenReset = false
                brain.asyncOperation(symbol)
            }
        }
    }



    /// color stuff
    @Published var allKeyColors: [String: KeyColors] = [:]
    private let digitKeys = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ","]
    private let operatorKeys = ["C", "AC", "±", "%", "/", "x", "-", "+", "="]
    private let scientificKeys = [
        "( ", " )", "mc", "m+", "m-", "mr",
        "2nd", "x^2", "x^3", "x^y", "e^x", "y^x", "2^x", "10^x",
        "One_x", "√", "3√", "y√", "logy", "ln", "log2", "log10",
        "x!", "sin", "cos", "tan", "asin", "acos", "atan", "e", "EE",
        "Deg", "Rad", "sinh", "cosh", "tanh", "asinh", "acosh", "atanh", "π", "Rand"]
    private let requireValidNumber = ["±", "%", "/", "x", "-", "+", "=", "( ", " )", "m+", "m-", "mr", "x^2", "x^3", "x^y", "e^x", "y^x", "2^x", "10^x", "One_x", "√", "3√", "y√", "logy", "ln", "log2", "log10", "x!", "sin", "cos", "tan", "asin", "acos", "atan", "EE", "sinh", "cosh", "tanh", "asinh", "acosh", "atanh"]
    private let digitColors = KeyColors(
        textColor: UIColor(.white),
        upColor:   UIColor(white: 0.2, alpha: 1.0),
        downColor: UIColor(white: 0.4, alpha: 1.0))
    private let disabledDigitColors = KeyColors(
        textColor: UIColor(.white),
        upColor:   UIColor(red: 0.4, green: 0.2, blue: 0.2, alpha: 1.0),
        downColor: UIColor(red: 0.4, green: 0.2, blue: 0.2, alpha: 1.0))
    private let operatorColors = KeyColors(
        textColor: UIColor(.white),
        upColor:   UIColor(white: 0.5, alpha: 1.0),
        downColor: UIColor(white: 0.7, alpha: 1.0))
    private let pendingOperatorColors = KeyColors(
        textColor: UIColor(white: 0.5, alpha: 1.0),
        upColor:   UIColor(white: 0.9, alpha: 1.0),
        downColor: UIColor(white: 0.8, alpha: 1.0))
    private let scientificColors = KeyColors(
        textColor: UIColor(.white),
        upColor:   UIColor(white: 0.12, alpha: 1.0),
        downColor: UIColor(white: 0.32, alpha: 1.0))
    private let pendingScientificColors = KeyColors(
        textColor: UIColor(white: 0.3, alpha: 1.0),
        upColor:   UIColor(white: 0.7, alpha: 1.0),
        downColor: UIColor(white: 0.6, alpha: 1.0))

    
    private var lastPending: String? = nil
    private func pendingOperatorCallback(symbol: String?) {
        guard lastPending != symbol else { return }
        
        if let last = lastPending {
            DispatchQueue.main.async {
                withAnimation(.easeIn(duration: 0.1)) {
                    self.allKeyColors[last] = self.getKeyColors(for: last, enabled: false, pending: false)
                }
            }
        }
        if let s = symbol {
            DispatchQueue.main.async {
                withAnimation(.easeIn(duration: 0.1)) {
                    self.allKeyColors[s] = self.getKeyColors(for: s, enabled: false, pending: true)
                }
            }
        }
        lastPending = symbol
    }
    static func spaceBetweenkeysFraction(withScientificKeys: Bool) -> CGFloat {
        if withScientificKeys {
            return 0.012
        } else {
            return 0.02
        }
    }
    
    private func getKeyColors(for symbol: String, enabled: Bool, pending: Bool) -> KeyColors {
        if digitKeys.contains(symbol) {
            if !enabled {
                return disabledDigitColors
            } else {
                return digitColors
            }
        } else if operatorKeys.contains(symbol) {
            if !enabled {
                return disabledDigitColors
            } else if pending {
                return pendingOperatorColors
            } else {
                /// not pending
                return operatorColors
            }
        } else if scientificKeys.contains(symbol) {
            if !enabled {
                return disabledDigitColors
            } else if pending {
                return pendingScientificColors
            } else {
                /// not pending
                return scientificColors
            }
        }
        return KeyColors(textColor: UIColor.red, upColor: UIColor.red, downColor: UIColor.red)
    }
}

class KeyColors: ObservableObject {
    var textColor: UIColor
    var upColor: UIColor
    var downColor: UIColor
    init(textColor: UIColor, upColor: UIColor, downColor: UIColor) {
        self.textColor = textColor
        self.upColor = upColor
        self.downColor = downColor
    }
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
