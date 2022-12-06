//
//  Model.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import SwiftUI

class Model : ObservableObject {
    var displayWidth: CGFloat = 0
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

    var bits: Int {
        brain.bits
    }

    
    private let brain: Brain
    @Published var keyInfo: [String: KeyInfo] = [:]
    var enabledDict: [String: Bool] = [:]
    var _AC = true
    var _hasBeenReset = false
    @Published var oneLineP: MultipleLiner

    var multipleLines: MultipleLiner {
        let len = min(precision, longDisplayMax)
        let lengthMeasurementResult = LengthMeasurementResult(
            withoutComma: len, withCommaNonScientific: len, withCommaScientific: len, ePadding: 0)
        return brain.last.multipleLines(lengthMeasurementResult, forceScientific: forceScientific)
    }
    
    var precisionDescription = "unknown"

    var lengthMeasurementResult = LengthMeasurementResult(withoutComma: 0, withCommaNonScientific: 0, withCommaScientific: 0, ePadding: 0)
    
    @AppStorage("precision", store: .standard) var precision: Int = 100 {
        didSet {
            print("precision -> \(precision)")
        }
    }
    @AppStorage("longDisplayMax", store: .standard) var longDisplayMax: Int = 100
    @AppStorage("forceScientific", store: .standard) var forceScientific: Bool = false
 
    func updatePrecision() {
        brain.setPrecision(precision)
    }

    init() {
        brain = Brain()
        oneLineP = MultipleLiner(left: "0", abbreviated: false)
        for key in C.allKeys {
            keyInfo[key] = KeyInfo(symbol: key, colors: C.getKeyColors(for: key))
        }
        brain.haveResultCallback = haveResultCallback
        brain.pendingOperatorCallback = pendingOperatorCallback
        brain.isCalculatingCallback = isCalculatingCallback

        isCalculatingCallback(false) // sets enabledDict
    }
    
    func haveResultCallback() {
        if brain.last.isNull {
            DispatchQueue.main.async {
                self._AC = true
                self.precisionDescription = self.precision.useWords
            }
        } else {
            DispatchQueue.main.async {
                self._AC = false
            }
        }
        DispatchQueue.main.async {
            self.oneLineP = self.brain.last.multipleLines(self.lengthMeasurementResult, forceScientific: self.forceScientific)
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

    
    func isCalculatingCallback(_ calculating: Bool) {
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
                // check mr
                enabledDict["mr"] = brain.memory != nil
            }
        }
    }
    
    
    func pressed(_ symbol: String) {
        let s = ["sin", "cos", "tan", "asin", "acos", "atan"].contains(symbol) && !_rad ? symbol+"D" : symbol
        
        if s == "AC" {
            _hasBeenReset.toggle()
        } else {
            _hasBeenReset = false
        }

        switch s {
        case "2nd":
            _2ndActive.toggle()
            self.keyInfo["2nd"]!.colors = _2ndActive ? C._2ndActiveColors : C._2ndColors
        case "Rad":
            _rad = true
        case "Deg":
            _rad = false
        case "plusKey":
                zoomed.toggle()
        default:
                brain.asyncOperation(s)
        }
    }
}
