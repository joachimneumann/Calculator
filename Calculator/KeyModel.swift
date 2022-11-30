//
//  keyModel.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import Foundation

class KeyModel : ObservableObject {
    let brain = Brain(precision: 1000000)
    @Published var colorsOf: [String: ColorsOf] = [:]
    var enabledDict: [String: Bool] = [:]
    @Published var _AC = true
    @Published var _2ndActive = false
    @Published var _rad = false
    @Published var last: String = "0"
    @Published var precisionDescription = "unknown"
    @Published var isCalculating = false

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
        print("enabled: \(!calculating)")
        for key in C.allKeys {
            if calculating {
                enabledDict[key] = false
            } else {
                enabledDict[key] = true
            }
        }
    }
    
    
    func keyUpCallback(_ symbol: String) {
        switch symbol {
        case "2nd":
            if _2ndActive {
                _2ndActive = false
                colorsOf["2nd"] = C.scientificColors
            } else {
                _2ndActive = true
                colorsOf["2nd"] = C.pendingScientificColors
            }
        case "Rad":
            _rad = false
        case "Deg":
            _rad = true
        case "=":
            brain.execute(priority: Operator.equalPriority)
            brain.haveResultCallback()
        default:
            brain.asyncOperation(symbol)
        }
    }
}
