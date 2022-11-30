//
//  keyModel.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import Foundation

class KeyModel : ObservableObject {
    @Published var _rad = false
    @Published var _2ndActive = false
    @Published var isCalculating = false

    let brain = Brain(precision: 1000000)
    var colorsOf: [String: ColorsOf] = [:]
    var enabledDict: [String: Bool] = [:]
    var _AC = true
    var _hasBeenReset = false
    var last: String = "0"
    var precisionDescription = "unknown"

    var oneLineWithoutCommaLength: Int = 4
    var oneLineWithCommaLength: Int = 4

    init() {
        for key in C.allKeys {
            colorsOf[key] = C.getKeyColors(for: key)
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
            }
        } else {
            DispatchQueue.main.async {
                self._AC = false
            }
        }
        let res = brain.last.multipleLines(withoutComma: oneLineWithoutCommaLength, withComma: oneLineWithCommaLength)
        DispatchQueue.main.async {
            self.last = res.oneLine
            self.precisionDescription = self.brain.precision.useWords
        }
    }

    private var previouslyPendingKey: String? = nil
    func pendingOperatorCallback(op: String?) {
        /// In the brain, we already check if the new operator is different from the old one.

        /// Set the previous one back to normal?
        if let previous = previouslyPendingKey {
            DispatchQueue.main.async {
                if C.scientificPendingOperations.contains(previous) {
                    self.colorsOf[previous] = C.scientificColors
                } else {
                    self.colorsOf[previous] = C.operatorColors
                }
            }
        }

        /// Set the colors for the pending operation key
        if let op = op {
            DispatchQueue.main.async {
                if C.scientificPendingOperations.contains(op) {
                    self.colorsOf[op] = C.pendingScientificColors
                } else {
                    self.colorsOf[op] = C.pendingOperatorColors
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
    
    
    func keyUpCallback(_ symbol: String) {
        switch symbol {
        case "2nd":
            if _2ndActive {
                _2ndActive = false
                colorsOf["2nd"] = C._2ndColors
            } else {
                _2ndActive = true
                colorsOf["2nd"] = C._2ndActiveColors
            }
        case "Rad":
            _rad = false
        case "Deg":
            _rad = true
        case "AC":
            _hasBeenReset = true
            brain.asyncOperation("AC")
        default:
            _hasBeenReset = false
            brain.asyncOperation(symbol)
        }
    }
}
