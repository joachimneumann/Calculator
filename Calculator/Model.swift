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
        var enabled = true
        init(symbol: String, colors: ColorsOf) {
            self.symbol = symbol
            self.colors = colors
        }
    }
    
    @Published var _2ndActive = false
    @Published var isCalculating = false
    
    private let brain: Brain
    @Published var keyInfo: [String: KeyInfo] = [:]
    var _AC = true
    @Published var _hasBeenReset = false
    @Published var displayData: DisplayData
    
    var precisionDescription = "unknown"
    
    var lengths = Lengths(withoutComma: 0, withCommaNonScientific: 0, withCommaScientific: 0, ePadding: 0)
    @AppStorage("precision", store: .standard) static var precision: Int = 100
    @AppStorage("forceScientific", store: .standard) static var forceScientific: Bool = false
    @AppStorage("trigonometricToZero", store: .standard) static var trigonometricToZero: Bool = true
    @AppStorage("memoryValue", store: .standard) static var memoryValue: String = ""
    @AppStorage("_rad", store: .standard) static var _rad: Bool = false
    static let MAX_DISPLAY_LEN = 10000 // too long strings in Text() crash the app

    // the update of the precision in brain can be slow.
    // Therefore, I only want to do that when leaving the settings screen
    func updatePrecision() {
        brain.setPrecision(Model.precision)
    }
    
    func speedTest(precision: Int) async -> Double {
        let testBrain = Brain(precision: precision)
        testBrain.setPrecision(precision)
        
        testBrain.operation("AC")
        print("testBrain.n.count \(testBrain.n.count)")
        testBrain.operation("Rand")
        
        let timer = ParkBenchTimer()
        testBrain.operation("√")
        testBrain.operation("sin")
        return timer.stop()
    }
    
    init() {
        brain = Brain(precision: Model.precision)
        displayData = DisplayData(shortLeft: "0", shortRight: nil, shortAbbreviated: false, longLeft: "0", longRight: nil, longAbbreviated: false)
        for key in C.allKeys {
            keyInfo[key] = KeyInfo(symbol: key, colors: C.getKeyColors(for: key))
        }
        brain.haveResultCallback = haveResultCallback
        brain.pendingOperatorCallback = pendingOperatorCallback
        if Model.memoryValue == "" {
            brain.memory = nil
        } else {
            brain.memory = Gmp(Model.memoryValue, precision: Model.precision)
        }
    }
    
    func haveResultCallback() {
        print("haveResultCallback \(lengths.withoutComma)")
        if brain.last.isNull {
            DispatchQueue.main.async {
                self._AC = true
                self.precisionDescription = Model.precision.useWords
            }
        } else {
            DispatchQueue.main.async {
                self._AC = false
            }
        }
        DispatchQueue.main.async {
            self.displayData = DisplayData(shortLeft: "0", shortAbbreviated: false, longLeft: "0", longAbbreviated: false)
        }
        let temp = self.brain.last.getDisplayData(self.lengths, forceScientific: Model.forceScientific)
        DispatchQueue.main.async {
            self.displayData = temp
        }
        
        for key in C.allKeys {
            if brain.isValidNumber {
                keyInfo[key]!.enabled = true
            } else {
                if C.requireValidNumber.contains(key) {
                    keyInfo[key]!.enabled = false
                } else {
                    keyInfo[key]!.enabled = true
                }
            }
        }

        // check mr
        keyInfo["mr"]!.enabled = Model.memoryValue == ""
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
//        DispatchQueue.main.async {
//            print("p color / \(self.keyInfo["/"]!.colors.upColor)")
//            print("p color x \(self.keyInfo["x"]!.colors.upColor)")
//            print("p color - \(self.keyInfo["-"]!.colors.upColor)")
//            print("p color + \(self.keyInfo["+"]!.colors.upColor)")
//        }
    }
    
    func pressed(_ _symbol: String) {
//        print("color / \(keyInfo["/"]!.colors.upColor)")
//        print("color x \(keyInfo["x"]!.colors.upColor)")
//        print("color - \(keyInfo["-"]!.colors.upColor)")
//        print("color + \(keyInfo["+"]!.colors.upColor)")
        let symbol = ["sin", "cos", "tan", "asin", "acos", "atan"].contains(_symbol) && !Model._rad ? _symbol+"D" : _symbol
        
        switch symbol {
        case "AC":
            _hasBeenReset.toggle()
        case "2nd":
            _2ndActive.toggle()
            self.keyInfo["2nd"]!.colors = _2ndActive ? C._2ndActiveColors : C._2ndColors
        case "Rad":
            _hasBeenReset = false
            Model._rad = true
        case "Deg":
            _hasBeenReset = false
            Model._rad = false
        case "plusKey":
            break
        default:
            _hasBeenReset = false
            Task {
                DispatchQueue.main.async { self.isCalculating = true }
                await asyncOperation(symbol)
                if ["mc", "m+", "m-"].contains(symbol) {
                    if let memory = brain.memory {
                        let lengths = Lengths(withoutComma: Model.precision, withCommaNonScientific: Model.precision, withCommaScientific: Model.precision, ePadding: 0)
                        DispatchQueue.main.sync {
                            Model.memoryValue = Number(memory, precision: Model.precision).getDisplayData(lengths, forceScientific: false).long
                        }
                    } else {
                        DispatchQueue.main.sync {
                            Model.memoryValue = ""
                        }
                    }
                }
            }
        }
    }
    
    func asyncOperation(_ symbol: String) async {
        brain.operation(symbol)
        DispatchQueue.main.async { self.isCalculating = false }
    }
}



class ParkBenchTimer {
    let startTime: CFAbsoluteTime
    var endTime: CFAbsoluteTime?

    init() {
        print("ParkBenchTimer init()")
        startTime = CFAbsoluteTimeGetCurrent()
    }

    func stop() -> Double {
        endTime = CFAbsoluteTimeGetCurrent()
        return duration!
    }
    var duration: CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
}
