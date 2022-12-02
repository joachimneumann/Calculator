//
//  keyModel.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import SwiftUI


class KeyModel : ObservableObject {
    class KeyInfo: ObservableObject {
        let symbol: String
        @Published var colors: ColorsOf
        @Published var enabled = true
        init(symbol: String, colors: ColorsOf) {
            self.symbol = symbol
            self.colors = colors
        }
    }
    
    @Published var _rad = false
    @Published var _2ndActive = false
    @Published var isCalculating = false
    @Published var zoomed = false

    let precision = 1000000
    let brain: Brain
    @Published var keyInfo: [String: KeyInfo] = [:]
    var enabledDict: [String: Bool] = [:]
    var _AC = true
    var _hasBeenReset = false
    @Published var oneLineP: String

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
        oneLineP = "0"
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
        DispatchQueue.main.async {
            self.oneLineP = self.brain.last.multipleLines(withoutComma: self.oneLineWithoutCommaLength, withComma: self.oneLineWithCommaLength).oneLine(showAbbreviation: false)
        }
    }

    private var previous: String? = nil
    func pendingOperatorCallback(op: String?) {
        /// In the brain, we have already asserted that the new op is different from previous

        /// Set the previous one back to normal?
        if let previous = previous {
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
        previous = op
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
//        for key in C.allKeys {
//            keyInfo[key] = KeyInfo(symbol: key, colors: ColorsOf(textColor: .white, upColor: C.disabledColor, downColor: C.disabledColor))
//        }
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
