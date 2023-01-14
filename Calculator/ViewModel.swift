//
//  ViewModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 1/14/23.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published internal var showAsInteger = false /// This will update the "-> Int or -> sci button texts
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

    @AppStorage("precision", store: .standard) private (set) var precision: Int = 1000
    @AppStorage("forceScientific", store: .standard) var forceScientific: Bool = false
    @AppStorage("memoryValue", store: .standard) var memoryValue: String = ""
    @AppStorage("rad", store: .standard) var rad: Bool = false

    private let brain: Brain /// initialized later with _precision.wrappedValue
    private var stupidBrain = BrainEngine(precision: 100) /// I want to call fast sync functions

    private enum KeyState {
        case notPressed
        case pressed
        case highPrecisionProcessing
    }

    private let keysThatRequireValidNumber = ["±", "%", "/", "x", "-", "+", "=", "( ", " )", "m+", "m-", "x^2", "x^3", "x^y", "e^x", "y^x", "2^x", "10^x", "One_x", "√", "3√", "y√", "logy", "ln", "log2", "log10", "x!", "sin", "cos", "tan", "asin", "acos", "atan", "EE", "sinh", "cosh", "tanh", "asinh", "acosh", "atanh"]
    private static let MAX_DISPLAY_LEN = 10_000 /// too long strings in Text() crash the app

    class ColorsOf {
        var textColor: Color
        var upColor: Color
        var downColor: Color
        init(textColor: Color, upColor: Color, downColor: Color) {
            self.textColor = textColor
            self.upColor = upColor
            self.downColor = downColor
        }
    }

    private let digitColors = ColorsOf(
        textColor: .white,
        upColor:   Color(white: 0.2),
        downColor: Color(white: 0.45))
    private let disabledColor = Color.red
    private let operatorColors = ColorsOf(
        textColor: Color(.white),
        upColor:   Color(white: 0.5),
        downColor: Color(white: 0.7))
    private let pendingOperatorColors = ColorsOf(
        textColor: Color(white: 0.3),
        upColor:   Color(white: 0.9),
        downColor: Color(white: 0.8))
    private let scientificColors = ColorsOf(
        textColor: Color(.white),
        upColor:   Color(white: 0.12),
        downColor: Color(white: 0.32))
    private let pendingScientificColors = ColorsOf(
        textColor: Color(white: 0.3),
        upColor:   Color(white: 0.7),
        downColor: Color(white: 0.6))
    private let secondColors = ColorsOf(
        textColor: Color(.white),
        upColor:   Color(white: 0.12),
        downColor: Color(white: 0.12))
    private let secondActiveColors = ColorsOf(
        textColor: Color(white: 0.2),
        upColor:   Color(white: 0.6),
        downColor: Color(white: 0.6))
    private var upHasHappended = false
    private var downAnimationFinished = false
    private var keyState: KeyState = .notPressed
    private let downTime = 0.1
    private let upTime = 0.4
    
    private var displayNumber = Number("0", precision: 10)
    private var previouslyPendingOperator: String? = nil

    init() {
        //print("ViewModel INIT")
        self.currentDisplay = Display()
        brain = Brain(precision: _precision.wrappedValue)
        precisionDescription = _precision.wrappedValue.useWords
    }
    
    /// the update of the precision in brain can be slow.
    /// Therefore, I only want to do that when leaving the settings screen
    func updatePrecision(to newPecision: Int) async {
        await MainActor.run {
            precision = newPecision
            precisionDescription = self.precision.useWords
        }
        let _ = await brain.setPrecision(newPecision)
    }

    ///  To give a clear visual feedback to the user that the button has been pressed,
    ///  the animation will always wait for the downAnimation to finish
    func showDisabledColors(symbol: String) async {
        await MainActor.run {
            withAnimation(.easeIn(duration: downTime)) {
                backgroundColor[symbol] = disabledColor
            }
        }
        try? await Task.sleep(nanoseconds: UInt64(downTime * 1_000_000_000))
        await MainActor.run {
            withAnimation(.easeIn(duration: upTime)) {
                backgroundColor[symbol] = keyColors(symbol, pending: symbol == previouslyPendingOperator).upColor
            }
        }
    }
    
    func showDownColors(symbol: String) async {
        upHasHappended = false
        downAnimationFinished = false
        await MainActor.run {
            withAnimation(.easeIn(duration: downTime)) {
                backgroundColor[symbol] = keyColors(symbol, pending: symbol == previouslyPendingOperator).downColor
            }
        }
        //print("down: downColor sleep START", downTime)
        try? await Task.sleep(nanoseconds: UInt64(downTime * 1_000_000_000))
        //print("down: downColor sleep STOP")
        downAnimationFinished = true
        //print("down: upHasHappended", upHasHappended)
        if upHasHappended {
            await showUpColors(symbol: symbol)
        }
    }

    func showUpColors(symbol: String) async {
        /// Set the background color back to normal
        await MainActor.run {
            withAnimation(.easeIn(duration: upTime)) {
                backgroundColor[symbol] = keyColors(symbol, pending: symbol == previouslyPendingOperator).upColor
            }
        }
    }
    
    func touchDown(symbol: String) {
        Task(priority: .userInitiated) {
            let validOrAllowed = displayNumber.isValid || !keysThatRequireValidNumber.contains(symbol)
            guard keyState == .notPressed && validOrAllowed else {
                await showDisabledColors(symbol: symbol)
                return
            }
            await showDownColors(symbol: symbol)
        }
    }
    
    func setPendingColors(symbol: String) async {
        if let previous = previouslyPendingOperator {
            await MainActor.run() {
                withAnimation(.easeIn(duration: downTime)) {
                    backgroundColor[previous] = keyColors(previous, pending: false).upColor
                    textColor[previous] = keyColors(previous, pending: false).textColor
                }
            }
        }
        if ["/", "x", "-", "+", "x^y", "y^x", "y√"].contains(symbol) {
            await MainActor.run() {
                withAnimation(.easeIn(duration: downTime)) {
                    backgroundColor[symbol] = keyColors(symbol, pending: true).upColor
                    textColor[symbol] = keyColors(symbol, pending: true).textColor
                    previouslyPendingOperator = symbol
                }
            }
        }
    }
    
    func touchUp(symbol rawSymbol: String, screen: Screen) {
        let symbol = ["sin", "cos", "tan", "asin", "acos", "atan"].contains(rawSymbol) && !rad ? rawSymbol+"D" : rawSymbol

        switch symbol {
        case "2nd":
            secondActive.toggle()
            backgroundColor["2nd"] = secondActive ? secondActiveColors.upColor : secondColors.upColor
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
            }

            keyState = .pressed
            upHasHappended = true
            Task(priority: .high) {
                if downAnimationFinished {
                    await showUpColors(symbol: symbol)
                }
                await setPendingColors(symbol: symbol)
            }
            Task.detached(priority: .low) {
                await self.defaultTask(symbol: symbol, screen: screen)
                self.keyState = .notPressed
            }
        }
    }
    
    func defaultTask(symbol: String, screen: Screen) async {
        //print("defaultTask", symbol)
        let preliminaryResult = stupidBrain.operation(symbol)
        let data = preliminaryResult.getDisplayData(
            multipleLines: false,
            lengths: screen.lengths,
            useMaximalLength: false,
            forceScientific: forceScientific,
            showAsInteger: showAsInteger,
            showAsFloat: showAsFloat)
        let format = DisplayFormat(
            for: data.length,
            withMaxLength: data.maxlength,
            showThreeDots: true,
            screen: screen)
        let preliminaryDisplay = Display(data: data, format: format)
        Task(priority: .high) {
            try? await Task.sleep(nanoseconds: 300_000_000)
            if keyState == .highPrecisionProcessing {
                await MainActor.run() {
                    currentDisplay = preliminaryDisplay
                }
            }
        }
        keyState = .highPrecisionProcessing
        displayNumber = await brain.operation(symbol)
        await refreshDisplay(screen: screen)
    }
    
    func refreshDisplay(screen: Screen) async {
        print("refreshDisplay")
        let tempDisplayData = displayNumber.getDisplayData(
                multipleLines: !screen.isPortraitPhone,
                lengths: screen.lengths,
                useMaximalLength: false,
                forceScientific: forceScientific,
                showAsInteger: showAsInteger,
                showAsFloat: showAsFloat)
        let format = DisplayFormat(
            for: tempDisplayData.length,
            withMaxLength: tempDisplayData.maxlength,
            showThreeDots: false,
            screen: screen)

        //print("tempDisplay", tempDisplay)
        await MainActor.run() {
            currentDisplay = Display(data: tempDisplayData, format: format)
            self.showAC = currentDisplay.data.isZero
            //print("currentDisplay", currentDisplay.data.left)
        }
    }

    func copyFromPasteBin(screen: Screen) async -> Bool {
        if UIPasteboard.general.hasStrings {
            if let pasteString = UIPasteboard.general.string {
                print("pasteString", pasteString, pasteString.count)
                if pasteString.count > 0 {
                    if Gmp.isValidGmpString(pasteString, bits: 1000) {
                        displayNumber = await brain.replaceLast(with: Number(pasteString, precision: brain.precision))
                        await refreshDisplay(screen: screen)
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func copyToPastBin() async {
        let copyData = displayNumber.getDisplayData(
            multipleLines: true,
            lengths: Lengths(0),
            useMaximalLength: true,
            forceScientific: forceScientific,
            showAsInteger: showAsInteger,
            showAsFloat: showAsFloat)
        UIPasteboard.general.string = copyData.oneLine
    }

    
    func keyColors(_ symbol: String, pending: Bool) -> ColorsOf {
        if ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ","].contains(symbol) {
            return digitColors
        } else if symbol == "2nd" {
            return secondColors
        } else if ["C", "AC", "±", "%", "/", "x", "-", "+", "="].contains(symbol) {
            return pending ? pendingOperatorColors : operatorColors
        } else {
            return pending ? pendingScientificColors : scientificColors
        }
    }
}
