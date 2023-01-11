//
//  BrainModel.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import SwiftUI

protocol KeyPressResponder {
    var forceScientific: Bool { get set }
    var showAsInteger: Bool { get set }
    var showAsFloat: Bool { get set }
    var isNull: Bool { get set }
    func keyPress(_ symbol: String) async -> CalculationResult
}

class BrainModel : KeyPressResponder, ObservableObject {
    @Published internal var showAsInteger = false /// This will update the "-> Int or -> sci button texts
    @Published internal var showAsFloat = false
    @Published internal var isNull = false
    private var displayDataIsOld = false
    private let timerDefaultText = "click to measure"
    private var timer: Timer? = nil
    private var timerCounter = 0
    private var timerInfo: String = ""
    //
    //    var hideKeyboard = false
    @Published var isCopying: Bool = false
    @Published var isPasting: Bool = false
    //
    private let brain: Brain
    //    private let stupidBrain: Brain
    //    private let stupidBrainPrecision = 100
    
    var precisionDescription = "unknown"
    
    @AppStorage("precision", store: .standard) private (set) var precision: Int = 1000
    @AppStorage("forceScientific", store: .standard) var forceScientific: Bool = false
    @AppStorage("memoryValue", store: .standard) var memoryValue: String = ""
    static let MAX_DISPLAY_LEN = 10_000 // too long strings in Text() crash the app
    
    init() {
        brain = Brain(precision: _precision.wrappedValue)
        precisionDescription = _precision.wrappedValue.useWords
    }
    
    func keyPress(_ symbol: String) async -> CalculationResult {
        displayDataIsOld = true
        //stupidBrain.operation(symbol)
        
        //            let preliminaryResultTask = Task {
        // sleep(300 ms)
        //                if not self.cancelled { stupidBrain.operation(symbol) }
        //                if not self.cancelled { let tempDisplay = stupidBrain.getDisplay }
        //                if not self.cancelled { display = temp }
        //            }
        return await brain.operation(symbol)
    }
    
    // the update of the precision in brain can be slow.
    // Therefore, I only want to do that when leaving the settings screen
    func updatePrecision(to newPecision: Int) async {
        await MainActor.run {
            precision = newPecision
            precisionDescription = self.precision.useWords
        }
        let _ = await brain.setPrecision(newPecision)
    }
    
    func copyToPastBin() async {
        //        if let number = calculationResult.number {
        //            let copyData = await number.getDisplayData(
        //                multipleLines: true,
        //                lengths: Lengths(precision),
        //                forceScientific: false,
        //                showAsInteger: showAsInteger,
        //                showAsFloat: showAsFloat,
        //                maxDisplayLength: precision)
        //            UIPasteboard.general.string = copyData.oneLine
        //        }
    }
    func copyFromPastBin() async -> Bool {
        var ok = false
        if UIPasteboard.general.hasStrings {
            if let pasteString = UIPasteboard.general.string {
                if pasteString.count > 0 {
                    if Gmp.isValidGmpString(pasteString, bits: 1000) {
                        ok = true
                    }
                }
                if ok {
                    await brain.replaceLast(with: Number(pasteString, precision: brain.precision))
                    //                    haveResultCallback() // TODO: make sure that forLong is true here!!!!
                }
            }
        }
        return ok
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
    
    
    
        //        self.screen = screen
        
        //        timerInfo = timerDefaultText
        // print("Model init isPortraitPhone \(screenInfo.isPortraitPhone)")
        
        // the later assignment of precision is a a bit strange, but a work-around for the error
        // "'self' used in property access 'precision' before all stored properties are initialized"
        // At init, not much is happening in the brain
        //        stupidBrain = Brain(precision: stupidBrainPrecision)
        //        display = Display(screen: screen)
        //        Task {
        //            calculationResult = await brain.operation("AC")
        //            display = await calculationResult.display(isPreliminary: false, screen: screen, forceScientific: forceScientific, showAsInteger: showAsInteger, showAsFloat: showAsFloat)
        
        //            if let number = calculationResult.number {
        //                let temp = Display(number: number, isPreliminary: false, screen: screen, forceScientific: forceScientific, showAsInteger: showAsInteger, showAsFloat: showAsFloat)
        //                Task { @MainActor in
        //                    display = temp
        //                }
        //            }
        //        }
        //        if memoryValue.isEmpty {
        ////                await brain.setMemory(nil)
        ////                await stupidBrain.setMemory(nil)
        //        } else {
        ////                await brain.setMemory(Number(memoryValue, precision: precision))
        ////                await stupidBrain.setMemory(Number(memoryValue, precision: stupidBrainPrecision))
        //        }
//    }
    
    //    var timerIsRunning: Bool { timer != nil }
    
    //    func timerStart() {
    //        timerCounter = 0
    //        DispatchQueue.main.async {
    //            self.timerInfo = "0"
    //        }
    //        timer = Timer.scheduledTimer(withTimeInterval:1.0, repeats: true) { _ in
    //            self.timerCounter += 1
    //            DispatchQueue.main.async {
    //                self.timerInfo = "\(self.timerCounter)"
    //            }
    //        }
    //    }
    //
    //    func timerStop(with executionTime: Double) {
    //        timerCounter = 0
    //        timer?.invalidate()
    //        timer = nil
    //        DispatchQueue.main.async {
    //            self.timerInfo = executionTime.asTime
    //        }
    //    }
    //
    //    func timerReset() {
    //        timerCounter = 0
    //        timer?.invalidate()
    //        timer = nil
    //        DispatchQueue.main.async {
    //            self.timerInfo = self.timerDefaultText
    //        }
    //    }
    

    //    func speedTest(precision: Int) async -> Double {
    //        let testBrain = Brain()
    //        await testBrain.setPrecision(precision)
    //
    //        await testBrain.operation("AC")
    //        //print("testBrain.n.count \(testBrain.n.count)")
    //        await testBrain.operation("Rand")
    //
    //        let parkBenchTimer = ParkBenchTimer()
    //        await testBrain.operation("√")
    //        await testBrain.operation("sin")
    //        let result = parkBenchTimer.stop()
    //        // print("speedTest done \(result.asTime)")
    //        return result
    //    }
    
    //    func updateDisplayData() {
    //        /// called after rotating the device and when I have a result
    //        let temp = Display(
    //            number: isPreliminary ? stupidBrain.last : brain.last,
    //            isPreliminary: isPreliminary,
    //            screen: screen,
    //            forceScientific: forceScientific,
    //            showAsInteger: showAsInteger,
    //            showAsFloat: showAsFloat)
    //        DispatchQueue.main.async {
    //            self.display = temp
    //        }
    //
    //    }
    //
    //    func haveStupidBrainResultCallback() {
    //        /// only show this if the high precision result isOld
    //        if displayDataIsOld {
    //            isPreliminary = true
    //            let temp = Display(
    //                number: stupidBrain.last,
    //                isPreliminary: isPreliminary,
    //                screen: screen,
    //                forceScientific: forceScientific,
    //                showAsInteger: showAsInteger,
    //                showAsFloat: showAsFloat)
    //            DispatchQueue.main.asyncAfter(deadline: .now() + C.preliminaryDelay) {
    //                if self.displayDataIsOld {
    //                    self.display = temp
    //                }
    //            }
    //        }
    //    }
    //
    //    func haveResultCallback() {
    //        if brain.last.isNull {
    //            DispatchQueue.main.async {
    //                self.showAC = true
    //                self.precisionDescription = self.precision.useWords
    //            }
    //        } else {
    //            DispatchQueue.main.async {
    //                self.showAC = false
    //            }
    //        }
    //
    //        isPreliminary = false
    //        let temp = Display(
    //            number: brain.last,
    //            isPreliminary: isPreliminary,
    //            screen: screen,
    //            forceScientific: forceScientific,
    //            showAsInteger: showAsInteger,
    //            showAsFloat: showAsFloat)
    //        self.displayDataIsOld = false
    //        DispatchQueue.main.async {
    //            self.display = temp
    //        }
    //
    //        if brain.isValidNumber {
    //            for key in C.keysAll {
    //                keyInfo[key]!.enabled = true
    //            }
    //        } else {
    //            for key in C.keysAll {
    //                if C.keysThatRequireValidNumber.contains(key) {
    //                    keyInfo[key]!.enabled = false
    //                } else {
    //                    keyInfo[key]!.enabled = true
    //                }
    //            }
    //        }
    //        print("haveResultCallback: keyInfo[10^x] \( keyInfo["10^x"]!.enabled)")
    //
    //        // check mr
    //        keyInfo["mr"]!.enabled = brain.memory != nil
    //    }
    
    
//    func keyPress(_ symbol: String) async -> CalculationResult {
        //        isCalculating = true
        //        for key in C.keysToDisable {
        //            keyInfo[key]!.enabled = false
        //        }
        
//        displayDataIsOld = true
        //stupidBrain.operation(symbol)
        
        //            let preliminaryResultTask = Task {
        // sleep(300 ms)
        //                if not self.cancelled { stupidBrain.operation(symbol) }
        //                if not self.cancelled { let tempDisplay = stupidBrain.getDisplay }
        //                if not self.cancelled { display = temp }
        //            }
//        return await brain.operation(symbol)
        //            isCalculating = false
        //            if brain.isValidNumber {
        //                for key in C.keysAll {
        //                    keyInfo[key]!.enabled = true
        //                }
        //            } else {
        //                for key in C.keysThatRequireValidNumber {
        //                    if C.keysThatRequireValidNumber.contains(key) {
        //                        keyInfo[key]!.enabled = false
        //                    } else {
        //                        keyInfo[key]!.enabled = true
        //                    }
        //                }
        //            }
        //            print("key ± ", keyInfo["±"]!.enabled)
        //            objectWillChange.send()
        
        //            if ["mc", "m+", "m-"].contains(symbol) {
        //                if let memory = brain.memory {
        //                    let temp = memory.getDisplayData(
        //                        multipleLines: true,
        //                        lengths: Lengths(precision),
        //                        forceScientific: false,
        //                        showAsInteger: showAsInteger,
        //                        showAsFloat: showAsFloat,
        //                        maxDisplayLength: precision)
        //                    DispatchQueue.main.sync {
        //                        memoryValue = temp.left + (temp.right ?? "")
        //                    }
        //                } else {
        //                    DispatchQueue.main.sync {
        //                        memoryValue = ""
        //                    }
        //                }
//    }
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
