//
//  ViewModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 1/14/23.
//

import SwiftUI

protocol ShowAs {
    var showAsInt: Bool   { get }
    var showAsFloat: Bool { get }
}

class ViewModel: ObservableObject, ShowAs {
    @Published var showAsInt = false /// This will update the "-> Int or -> sci button texts
    @Published var showAsFloat = false
    @Published var isCopying: Bool = false
    @Published var isPasting: Bool = false
    @Published var showAC = true
    @Published var backgroundColor: [String: Color] = [:]
    @Published var textColor: [String: Color] = [:]
    @Published var currentDisplay: Display

    var precisionDescription = "unknown"
    var showPrecision: Bool = false
    var secondActive = false
    var keyColor = KeyColor()
    
    @AppStorage("precision", store: .standard) private (set) var precision: Int = 1000
    @AppStorage("showPreliminaryResults", store: .standard) var showPreliminaryResults: Bool = true
    @AppStorage("memoryValue", store: .standard) var memoryValue: String = ""
    @AppStorage("rad", store: .standard) var rad: Bool = false

    private let brain: Brain /// initialized later with _precision.wrappedValue
    private var stupidBrain = BrainEngine(precision: 100) /// I want to call fast sync functions

    private let keysThatRequireValidNumber = ["±", "%", "/", "x", "-", "+", "=", "( ", " )", "m+", "m-", "x^2", "x^3", "x^y", "e^x", "y^x", "2^x", "10^x", "One_x", "√", "3√", "y√", "logy", "ln", "log2", "log10", "x!", "sin", "cos", "tan", "asin", "acos", "atan", "EE", "sinh", "cosh", "tanh", "asinh", "acosh", "atanh"]
    private static let MAX_DISPLAY_LEN = 10_000 /// too long strings in Text() crash the app

    private var upHasHappended = false
    private var downAnimationFinished = false

    private enum KeyState {
        case notPressed
        case pressed
        case highPrecisionProcessing
        case highPrecisionProcessingDisabled
    }

    private var keyState: KeyState = .notPressed
    private let downTime = 0.1
    private let upTime = 0.4
    
    private var displayNumber = Number("0", precision: 10)
    
    private var previouslyPendingOperator: String? = nil

    init() {
        //print("ViewModel INIT")
        
        /// currentDisplay will be updated shortly by refreshDisplay in onAppear() of Calculator
        /// I just set some values here
        currentDisplay = Display(left: "0", right: nil, canBeInteger: false, canBeFloat: false)
        brain = Brain(precision: _precision.wrappedValue)
        precisionDescription = _precision.wrappedValue.useWords
    }
    
    /// the update of the precision in brain can be slow.
    /// Therefore, I only want to do that when leaving the settings screen
    func updatePrecision(to newPrecision: Int) async {
        await MainActor.run {
            precision = newPrecision
            precisionDescription = self.precision.useWords
        }
        let _ = await brain.setPrecision(newPrecision)
        
        /// also change the precision in the displayNumber
        let new = Number("0", precision: newPrecision)
        new.setValue(other: displayNumber)
        await MainActor.run {
            displayNumber = new
        }
    }

    ///  To give a clear visual feedback to the user that the button has been pressed,
    ///  the animation will always wait for the downAnimation to finish
    func showDisabledColors(for symbol: String) async {
        await MainActor.run {
            withAnimation(.easeIn(duration: downTime)) {
                backgroundColor[symbol] = disabledColor
            }
        }
        try? await Task.sleep(nanoseconds: UInt64(downTime * 1_000_000_000))
        await MainActor.run {
            withAnimation(.easeIn(duration: upTime)) {
                backgroundColor[symbol] = upColor(for: symbol, isPending: symbol == previouslyPendingOperator)
            }
        }
    }
    
    func showDownColors(for symbol: String) async {
        upHasHappended = false
        downAnimationFinished = false
        await MainActor.run {
            withAnimation(.easeIn(duration: downTime)) {
                backgroundColor[symbol] = downColor(for: symbol, isPending: symbol == previouslyPendingOperator)
            }
        }
        //print("down: downColor sleep START", downTime)
        try? await Task.sleep(nanoseconds: UInt64(downTime * 1_000_000_000))
        //print("down: downColor sleep STOP")
        downAnimationFinished = true
        //print("down: upHasHappended", upHasHappended)
        if upHasHappended {
            await showUpColors(for: symbol)
        }
    }

    func showUpColors(for symbol: String) async {
        /// Set the background color back to normal
        await MainActor.run {
            withAnimation(.easeIn(duration: upTime)) {
                backgroundColor[symbol] = upColor(for: symbol, isPending: symbol == previouslyPendingOperator)
            }
        }
    }
    
    func touchDown(for symbol: String) {
        print("touchDown1 keyState =", keyState)
        if keyState == .highPrecisionProcessing {
            keyState = .highPrecisionProcessingDisabled
            Task(priority: .userInitiated) {
                await showDisabledColors(for: symbol)
            }
            return
        }
        
        Task(priority: .userInitiated) {
            let validOrAllowed = displayNumber.isValid || !keysThatRequireValidNumber.contains(symbol)
            print("touchDown2 keyState =", keyState, "validOrAllowed =", validOrAllowed)
            guard keyState == .notPressed && validOrAllowed else {
                //keyState = .disabledPressed
                await showDisabledColors(for: symbol)
                return
            }
            await showDownColors(for: symbol)
        }
    }
    
    func touchUp(of symbol: String, screen: Screen) {
        if keyState == .highPrecisionProcessingDisabled {
            keyState = .highPrecisionProcessing
            /// this allows the user to try pressing a button again
            return
        }

        let symbol = ["sin", "cos", "tan", "asin", "acos", "atan"].contains(symbol) && !rad ? symbol+"D" : symbol

        switch symbol {
        case "2nd":
            secondActive.toggle()
            backgroundColor["2nd"] = secondColor(active: secondActive)
        case "Rad":
            rad = true
        case "Deg":
            rad = false
        default:
            guard keyState == .notPressed else { return }

            let valid = displayNumber.isValid || !keysThatRequireValidNumber.contains(symbol)
            guard valid else { return }

            if symbol == "AC" {
                showPrecision.toggle()
            } else {
                showPrecision = false
            }

            keyState = .pressed
            upHasHappended = true
            Task(priority: .high) {
                if downAnimationFinished {
                    await showUpColors(for: symbol)
                }
                await setPendingColors(for: symbol)
            }
            Task.detached(priority: .low) {
                await self.defaultTask(for: symbol, screen: screen)
                self.keyState = .notPressed
            }
        }
    }
    
    func setPendingColors(for symbol: String) async {
        if let previous = previouslyPendingOperator {
            await MainActor.run() {
                withAnimation(.easeIn(duration: downTime)) {
                    backgroundColor[previous] = upColor(for: previous, isPending: false)
                    textColor[previous] = textColor(for: previous, isPending: false)
                }
            }
        }
        if ["/", "x", "-", "+", "x^y", "y^x", "y√"].contains(symbol) {
            await MainActor.run() {
                withAnimation(.easeIn(duration: downTime)) {
                    backgroundColor[symbol] = upColor(for: symbol, isPending: true)
                    textColor[symbol] = textColor(for: symbol, isPending: true)
                    previouslyPendingOperator = symbol
                }
            }
        } else {
            previouslyPendingOperator = nil
        }
    }
    
    func defaultTask(for symbol: String, screen: Screen) async {
        //print("defaultTask", symbol)
        if showPreliminaryResults {
            let preliminaryResult = stupidBrain.operation(symbol)
            let preliminary = Display(preliminaryResult, screen: screen, showAs: self, forceScientific: screen.forceScientific)
            Task(priority: .high) {
                try? await Task.sleep(nanoseconds: 300_000_000)
                if keyState == .highPrecisionProcessing {
                    await MainActor.run() {
                        currentDisplay = preliminary
                    }
                }
            }
        }
        keyState = .highPrecisionProcessing
        let tempNumber = await brain.operation(symbol)
        if (displayNumber != tempNumber) {
            displayNumber = tempNumber.copy()
            /// new number: reset showAs
            await MainActor.run() {
                showAsInt = false
                showAsFloat = false
            }
            await refreshDisplay(screen: screen)
        }
    }
    
    func refreshDisplay(screen: Screen) async {
        //print("refreshDisplay precision =", displayNumber.precision)
        let tempDisplay = Display(displayNumber, screen: screen, showAs: self, forceScientific: screen.forceScientific)
        await MainActor.run() {
            currentDisplay = tempDisplay
            self.showAC = currentDisplay.isZero
        }
    }

    func copyFromPasteBin(screen: Screen) async -> Bool {
        if UIPasteboard.general.hasStrings {
            if let pasteString = UIPasteboard.general.string {
                print("pasteString", pasteString, pasteString.count)
                if pasteString.count > 0 {
                    if Gmp.isValidGmpString(pasteString, bits: 1000) {
                        displayNumber = await brain.replaceLast(withString: pasteString)
                        await refreshDisplay(screen: screen)
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func copyToPastBin(screen: Screen) async {
        let copyData = Display(displayNumber, screen: screen, noLimits: true, showAs: self, forceScientific: screen.forceScientific)
        UIPasteboard.general.string = copyData.allInOneLine
    }

    /// colors
    func textColor(for symbol: String, isPending pending: Bool) -> Color {
        keyColor.textColor(for: symbol, isPending: pending)
    }
    func upColor(for symbol: String, isPending pending: Bool) -> Color {
        keyColor.upColor(for: symbol, isPending: pending)
    }
    func downColor(for symbol: String, isPending pending: Bool) -> Color {
        keyColor.downColor(for: symbol, isPending: pending)
    }
    func secondColor(active: Bool) -> Color {
        keyColor.secondColor(active: active)
    }
    var disabledColor: Color {
        keyColor.disabledColor
    }
}
