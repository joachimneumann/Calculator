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
    
    @Published var showAsInteger = false
    @Published var showAsFloat = false
    @Published var scrollViewID = UUID()
    var scrollViewHasScrolled = false
    @Published var isZoomed: Bool {
        didSet {
            if scrollViewHasScrolled {
                scrollViewID = UUID()
            }
        }
    }
    
    private var displayDataIsOld = false
    private let timerDefaultText = "click to measure"
    private var timer: Timer?
    private var timerCounter = 0
    private var isPreliminary: Bool = false
    @Published var timerInfo: String
    
    @Published var screenInfo: ScreenInfo = ScreenInfo(hardwareSize: CGSize(), insets: UIEdgeInsets(), appOrientation: .unknown)
    @Published var secondActive = false
    @Published var isCalculating = false {
        didSet {
            //print("isCalculating -> \(isCalculating)")
            DispatchQueue.main.async {
                for key in C.keysAll {
                    if !C.keysThatDoNotNeedToBeDisabled.contains(key) {
                        self.keyInfo[key]!.enabled = !self.isCalculating
                    }
                }
            }
        }
    }
    
    var hideKeyboard = false
    @Published var isCopying: Bool = false
    @Published var isPasting: Bool = false
    var copyAnimationDone = false
    
    private let brain: Brain
    private let stupidBrain: Brain
    private let stupidBrainPrecision = 100
    @Published var keyInfo: [String: KeyInfo] = [:]
    @Published var showAC = true
    @Published var hasBeenReset = false
    @Published var display: Display
    
    var precisionDescription = "unknown"
    
    @AppStorage("precision", store: .standard) private (set) var precision: Int = 1000
    @AppStorage("forceScientific", store: .standard) var forceScientific: Bool = false
    @AppStorage("memoryValue", store: .standard) var memoryValue: String = ""
    @AppStorage("rad", store: .standard) var rad: Bool = false
    static let MAX_DISPLAY_LEN = 10000 // too long strings in Text() crash the app
    
    var isValidNumber: Bool {
        brain.isValidNumber
    }
    
    init(isZoomed: Bool) {
        timerInfo = timerDefaultText
        // print("Model init isPortraitPhone \(screenInfo.isPortraitPhone)")
        self.isZoomed = isZoomed
        
        // the later assignment of precision is a a bit strange, but a work-around for the error
        // "'self' used in property access 'precision' before all stored properties are initialized"
        // At init, not much is happening in the brain
        brain = Brain()
        stupidBrain = Brain()
        display = Display()
        brain.setPrecision(precision)
        brain.haveResultCallback = haveResultCallback
        brain.pendingOperatorCallback = pendingOperatorCallback
        
        stupidBrain.setPrecision(stupidBrainPrecision)
        stupidBrain.haveResultCallback = haveStupidBrainResultCallback
        /// no pendingOperatorCallback
        
        if memoryValue == "" {
            brain.memory = nil
            stupidBrain.memory = nil
        } else {
            brain.memory = Number(memoryValue, precision: precision)
            stupidBrain.memory = Number(memoryValue, precision: stupidBrainPrecision)
        }
        
        for key in C.keysAll {
            keyInfo[key] = KeyInfo(symbol: key, colors: C.getKeyColors(for: key))
        }
    }
    
    var timerIsRunning: Bool { timer != nil }
    
    func timerStart() {
        timerCounter = 0
        DispatchQueue.main.async {
            self.timerInfo = "0"
        }
        timer = Timer.scheduledTimer(withTimeInterval:1.0, repeats: true) { _ in
            self.timerCounter += 1
            DispatchQueue.main.async {
                self.timerInfo = "\(self.timerCounter)"
            }
        }
    }
    
    func timerStop(with executionTime: Double) {
        timerCounter = 0
        timer?.invalidate()
        timer = nil
        DispatchQueue.main.async {
            self.timerInfo = executionTime.asTime
        }
    }
    
    func timerReset() {
        timerCounter = 0
        timer?.invalidate()
        timer = nil
        DispatchQueue.main.async {
            self.timerInfo = self.timerDefaultText
        }
    }
    
    func initiateScreenInfo(to screenInfo: ScreenInfo) {
        DispatchQueue.main.async { [self] in
            self.screenInfo = screenInfo
            self.updateDisplayData()
        }
    }
    
    // the update of the precision in brain can be slow.
    // Therefore, I only want to do that when leaving the settings screen
    func updatePrecision(to newPecision: Int) {
        precision = newPecision
        brain.setPrecision(newPecision)
    }
    
    func copyToPastBin() async {
        let displayData = brain.last.getDisplayData(
            multipleLines: true,
            lengths: Lengths(precision),
            forceScientific: false,
            showAsInteger: showAsInteger,
            showAsFloat: showAsFloat,
            maxDisplayLength: precision)
        UIPasteboard.general.string = displayData.oneLine
    }
    func copyFromPastBin() async {
        if UIPasteboard.general.hasStrings {
            if let pasteString = UIPasteboard.general.string {
                var ok = false
                if pasteString.count > 0 {
                    if Gmp.isValidGmpString(pasteString, bits: 1000) {
                        ok = true
                    }
                }
                if ok {
                    brain.replaceLast(with: Number(pasteString, precision: brain.precision))
                    haveResultCallback() // TODO: make sure that forLong is true here!!!!
                }
            }
        }
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
        
    func speedTest(precision: Int) async -> Double {
        let testBrain = Brain()
        testBrain.setPrecision(precision)
        
        testBrain.operation("AC")
        //print("testBrain.n.count \(testBrain.n.count)")
        testBrain.operation("Rand")
        
        let parkBenchTimer = ParkBenchTimer()
        testBrain.operation("√")
        testBrain.operation("sin")
        let result = parkBenchTimer.stop()
        // print("speedTest done \(result.asTime)")
        return result
    }
    
    func updateDisplayData() {
        /// called after rotating the device and when I have a result
        let temp = Display(
            number: isPreliminary ? stupidBrain.last : brain.last,
            isPreliminary: isPreliminary,
            screenInfo: screenInfo,
            forceScientific: forceScientific,
            showAsInteger: showAsInteger,
            showAsFloat: showAsFloat)
        DispatchQueue.main.async {
            self.display = temp
        }
        
    }
    
    func haveStupidBrainResultCallback() {
        /// only show this if the high precision result isOld
        if displayDataIsOld {
            isPreliminary = true
            let temp = Display(
                number: stupidBrain.last,
                isPreliminary: isPreliminary,
                screenInfo: screenInfo,
                forceScientific: forceScientific,
                showAsInteger: showAsInteger,
                showAsFloat: showAsFloat)
            DispatchQueue.main.asyncAfter(deadline: .now() + C.preliminaryDelay) {
                if self.displayDataIsOld {
                    self.display = temp
                }
            }
        }
    }
    
    func haveResultCallback() {
        if brain.last.isNull {
            DispatchQueue.main.async {
                self.showAC = true
                self.precisionDescription = self.precision.useWords
            }
        } else {
            DispatchQueue.main.async {
                self.showAC = false
            }
        }
        
        isPreliminary = false
        let temp = Display(
            number: brain.last,
            isPreliminary: isPreliminary,
            screenInfo: screenInfo,
            forceScientific: forceScientific,
            showAsInteger: showAsInteger,
            showAsFloat: showAsFloat)
        self.displayDataIsOld = false
        DispatchQueue.main.async {
            self.display = temp
        }
        
        for key in C.keysAll {
            if brain.isValidNumber {
                keyInfo[key]!.enabled = true
            } else {
                if C.keysThatRequireValidNumber.contains(key) {
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
                if C.keysWithPendingOperations.contains(previous) {
                    self.keyInfo[previous]!.colors = C.scientificColors
                } else {
                    self.keyInfo[previous]!.colors = C.operatorColors
                }
            }
        }
        
        /// Set the colors for the pending operation key
        if let op = op {
            DispatchQueue.main.async {
                if C.keysWithPendingOperations.contains(op) {
                    self.keyInfo[op]!.colors = C.pendingScientificColors
                } else {
                    self.keyInfo[op]!.colors = C.pendingOperatorColors
                }
            }
        }
        previous = op
    }
    
    func pressed(_ _symbol: String) {
        let symbol = ["sin", "cos", "tan", "asin", "acos", "atan"].contains(_symbol) && !rad ? _symbol+"D" : _symbol
        
        switch symbol {
        case "2nd":
            secondActive.toggle()
            self.keyInfo["2nd"]!.colors = secondActive ? C.secondActiveColors : C.secondColors
        case "Rad":
            hasBeenReset = false
            rad = true
        case "Deg":
            hasBeenReset = false
            rad = false
        case "plusKey":
            break
        default:
            if !isCalculating {
                if symbol == "AC" {
                    hasBeenReset.toggle()
                } else {
                    hasBeenReset = false
                }
                
                displayDataIsOld = true
                DispatchQueue.main.async {
                    self.isCalculating = true
                }
                stupidBrain.operation(symbol)
                Task {
                    await asyncOperation(symbol)
                    if ["mc", "m+", "m-"].contains(symbol) {
                        if let memory = brain.memory {
                            let temp = memory.getDisplayData(
                                multipleLines: true,
                                lengths: Lengths(precision),
                                forceScientific: false,
                                showAsInteger: showAsInteger,
                                showAsFloat: showAsFloat,
                                maxDisplayLength: precision)
                            DispatchQueue.main.sync {
                                memoryValue = temp.left + (temp.right ?? "")
                            }
                        } else {
                            DispatchQueue.main.sync {
                                memoryValue = ""
                            }
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
