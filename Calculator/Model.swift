//
//  Model.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import SwiftUI

class Model : ObservableObject {
    class KeyInfo: ObservableObject {
        let symbol: String
        @Published var colors: ColorsOf
        var enabled = true
        init(symbol: String, colors: ColorsOf) {
            self.symbol = symbol
            self.colors = colors
        }
    }
    
    @Published var secondActive = false
    @Published var isCalculating = false
    var hideKeyboard = false

    private let brain: Brain
    @Published var keyInfo: [String: KeyInfo] = [:]
    @Published var showAC = true
    @Published var hasBeenReset = false
    @Published var displayData = DisplayData(shortLeft: "x", shortRight: nil, shortAbbreviated: false, longLeft: "x", longRight: nil, longAbbreviated: false)
    
    var precisionDescription = "unknown"
    
    var lengths = Lengths(0)

    @AppStorage("precision", store: .standard) static private (set) var precision: Int = 1000
    @AppStorage("forceScientific", store: .standard) static var forceScientific: Bool = false
    @AppStorage("memoryValue", store: .standard) static var memoryValue: String = ""
    @AppStorage("rad", store: .standard) static var rad: Bool = false
    static let MAX_DISPLAY_LEN = 10000 // too long strings in Text() crash the app
    
    var isValidNumber: Bool {
        brain.isValidNumber
    }
    
    // the update of the precision in brain can be slow.
    // Therefore, I only want to do that when leaving the settings screen
    func updatePrecision(to newPecision: Int) {
        Model.precision = newPecision
        brain.setPrecision(newPecision)
    }
    
    func toPastBin() {
        UIPasteboard.general.string = brain.last.getDisplayData(Lengths(Model.precision), forceScientific: false, maxDisplayLength: Model.precision).long
    }
    
    func checkIfPasteBinIsValidNumber() -> Bool {
        if UIPasteboard.general.hasStrings {
            if let pasteString = UIPasteboard.general.string {
                if pasteString.count > 0 {
                    if Gmp.isValidGmpString(pasteString, bits: 1000) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func fromPastBin() {
        if UIPasteboard.general.hasStrings {
            if let pasteString = UIPasteboard.general.string {
                if pasteString.count > 0 {
                    brain.n.replaceLast(with: Number(pasteString, precision: brain.precision))
                    haveResultCallback()
                    hasBeenReset = false
                }
            }
        }
    }
    
    func speedTest(precision: Int) async -> Double {
        let testBrain = Brain(precision: precision)
        testBrain.setPrecision(precision)
        
        testBrain.operation("AC")
        //print("testBrain.n.count \(testBrain.n.count)")
        testBrain.operation("Rand")
        
        let timer = ParkBenchTimer()
        testBrain.operation("√")
        testBrain.operation("sin")
        return timer.stop()
    }
    
    init() {
        brain = Brain(precision: Model.precision)
        for key in C.allKeys {
            keyInfo[key] = KeyInfo(symbol: key, colors: C.getKeyColors(for: key))
        }
        brain.haveResultCallback = haveResultCallback
        brain.pendingOperatorCallback = pendingOperatorCallback
        if Model.memoryValue == "" {
            brain.memory = nil
        } else {
            brain.memory = Number(Model.memoryValue, precision: Model.precision)
        }
    }
    
    func updateDisplayData() {
        //print("updateDisplayData()")
        DispatchQueue.main.async {
            self.displayData = DisplayData(shortLeft: "", shortAbbreviated: false, longLeft: "", longAbbreviated: false)
        }
        let temp = self.brain.last.getDisplayData(self.lengths, forceScientific: Model.forceScientific)
        DispatchQueue.main.async {
            self.displayData = temp
        }
    }
    
    func haveResultCallback() {
        //print("haveResultCallback \(lengths.withoutComma)")
        if brain.last.isNull {
            DispatchQueue.main.async {
                self.showAC = true
                self.precisionDescription = Model.precision.useWords
            }
        } else {
            DispatchQueue.main.async {
                self.showAC = false
            }
        }
        
        updateDisplayData()
        
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
        keyInfo["mr"]!.enabled = brain.memory != nil
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
        let symbol = ["sin", "cos", "tan", "asin", "acos", "atan"].contains(_symbol) && !Model.rad ? _symbol+"D" : _symbol
        
        switch symbol {
        case "2nd":
            secondActive.toggle()
            self.keyInfo["2nd"]!.colors = secondActive ? C.secondActiveColors : C.secondColors
        case "Rad":
            hasBeenReset = false
            Model.rad = true
        case "Deg":
            hasBeenReset = false
            Model.rad = false
        case "plusKey":
            break
        default:
            if symbol == "AC" {
                hasBeenReset.toggle()
            } else {
                hasBeenReset = false
            }
            Task {
                DispatchQueue.main.async { self.isCalculating = true }
                await asyncOperation(symbol)
                if ["mc", "m+", "m-"].contains(symbol) {
                    if let memory = brain.memory {
                        DispatchQueue.main.sync {
                            Model.memoryValue = memory.getDisplayData(Lengths(Model.precision), forceScientific: false, maxDisplayLength: Model.precision).long
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
        //print("ParkBenchTimer init()")
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
