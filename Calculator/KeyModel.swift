//
//  keyModel.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import UIKit


class KeyModel : ObservableObject {
    class KeyInfo {
        let symbol: String
        var colors: ColorsOf
        var _enabled = true
        var textColor: UIColor {
            colors.textColor
        }
        var upColor: UIColor{
            colors.upColor
        }
        var downColor: UIColor{
            colors.downColor
        }
        init(symbol: String, colors: ColorsOf) {
            self.symbol = symbol
            self.colors = colors
        }
        func enabled() -> Bool {
            return _enabled
        }
    }
    
    @Published var _rad = false
    @Published var _2ndActive = false
    @Published var isCalculating = false
    @Published var zoomed = false

    let precision = 1000000
    let brain: Brain
    var keyInfo: [String: KeyInfo] = [:]
    var enabledDict: [String: Bool] = [:]
    var _AC = true
    var _hasBeenReset = false
    var oneLine: String {
        brain.last.multipleLines(withoutComma: oneLineWithoutCommaLength, withComma: oneLineWithCommaLength).oneLine(showAbbreviation: false)
    }
    var multipleLines: MultipleLiner {
        let len = min(precision, C.maxDigitsInLongDisplay)
        let ret = brain.last.multipleLines(withoutComma: len, withComma: len)
        return ret
    }
    
    var precisionDescription = "unknown"

    var oneLineWithoutCommaLength: Int = 4
    var oneLineWithCommaLength: Int = 4

    init() {
        print("KeyModel init()")
        brain = Brain(precision: precision)
        for key in C.allKeys {
            keyInfo[key] = KeyInfo(symbol: key, colors: C.getKeyColors(for: key))
        }
        brain.haveResultCallback = haveResultCallback
        brain.pendingOperatorCallback = pendingOperatorCallback
        brain.isCalculatingCallback = isCalculatingCallback
        for key in C.allKeys {
            enabledDict[key] = true
        }
    }
    
    private func haveResultCallback() {
        if brain.last.isNull {
            DispatchQueue.main.async {
                self._AC = true
                self.precisionDescription = self.brain.precision.useWords
            }
        } else {
            DispatchQueue.main.async {
                self._AC = false
            }
        }
////        let res = brain.last.multipleLines(withoutComma: oneLineWithoutCommaLength, withComma: oneLineWithCommaLength)
//        DispatchQueue.main.async {
////            self.last = res.oneLine
//        }
    }

    private var previouslyPendingKey: String? = nil
    func pendingOperatorCallback(op: String?) {
        /// In the brain, we already check if the new operator is different from the old one.

        /// Set the previous one back to normal?
        if let previous = previouslyPendingKey {
            DispatchQueue.main.async {
                if C.scientificPendingOperations.contains(previous) {
                    self.keyInfo[previous]!.colors = C.scientificColors
                } else {
                    self.keyInfo[previous]!.colors = C.operatorColors
                }
            }
        }

        /// Set the colors for the pending operation key
        if let op = op {
            DispatchQueue.main.async {
                if C.scientificPendingOperations.contains(op) {
                    self.keyInfo[op]!.colors = C.pendingScientificColors
                } else {
                    self.keyInfo[op]!.colors = C.pendingOperatorColors
                }
            }
        }
        previouslyPendingKey = op
    }

    
    func isCalculatingCallback(calculating: Bool) {
        DispatchQueue.main.async { self.isCalculating = calculating }
        /// print("enabled: \(!calculating)")
        for key in C.allKeys {
            if calculating {
                enabledDict[key] = false
            } else {
                if brain.isValidNumber {
                    enabledDict[key] = true
                } else {
                    if C.requireValidNumber.contains(key) {
                        enabledDict[key] = false
                    } else {
                        enabledDict[key] = true
                    }
                }
            }
        }
    }
    
    
    func keyDownCallback(_ symbol: String) {
        let radOrDegOperators = ["sin", "cos", "tan", "asin", "acos", "atan"]
        switch symbol {
        case "2nd":
            if _2ndActive {
                _2ndActive = false
                self.keyInfo["2nd"]!.colors = C._2ndColors
            } else {
                _2ndActive = true
                self.keyInfo["2nd"]!.colors = C._2ndActiveColors
            }
        case "Rad":
            _rad = true
        case "Deg":
            _rad = false
        case "AC":
            _hasBeenReset = true
            brain.asyncOperation("AC")
        case "plusKey":
            zoomed.toggle()
        default:
            _hasBeenReset = false
            if _rad == false && radOrDegOperators.contains(symbol) {
                brain.asyncOperation(symbol+"D")
            } else {
                brain.asyncOperation(symbol)
            }
        }
    }
}
