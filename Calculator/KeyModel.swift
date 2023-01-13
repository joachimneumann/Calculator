//
//  KeyModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/27/22.
//

import SwiftUI

class KeyModel: ObservableObject {
    
    var keyPressResponder: KeyPressResponder?
    var stupidBrain = BrainEngine(precision: 100) // I want to call fast sync functions
    
    private enum KeyState {
        case notPressed
        case pressed
        case highPrecisionProcessing
    }

    private let keysThatRequireValidNumber = ["±", "%", "/", "x", "-", "+", "=", "( ", " )", "m+", "m-", "x^2", "x^3", "x^y", "e^x", "y^x", "2^x", "10^x", "One_x", "√", "3√", "y√", "logy", "ln", "log2", "log10", "x!", "sin", "cos", "tan", "asin", "acos", "atan", "EE", "sinh", "cosh", "tanh", "asinh", "acosh", "atanh"]

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
    @Published var showAC = true
    var showPrecision: Bool = false
    var secondActive = false
    @Published var backgroundColor: [String: Color] = [:]
    @Published var textColor: [String: Color] = [:]
    @AppStorage("rad", store: .standard) var rad: Bool = false
    @Published var currentDisplay: Display
    private var previouslyPendingOperator: String? = nil
    init() {
        //print("KeyModel INIT")
        self.currentDisplay = Display()
        for symbol in C.keysAll {
            backgroundColor[symbol] = keyColors(symbol, pending: false).upColor
            textColor[symbol]       = keyColors(symbol, pending: false).textColor
        }
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
        //print("down: timer START", downTime)
        try? await Task.sleep(nanoseconds: UInt64(downTime * 1_000_000_000))
        //print("down: timer STOP")
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
        if ["/", "x", "-", "+", "x^y", "y^x"].contains(symbol) {
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
            Task(priority: .low) {
                if downAnimationFinished {
                    await showUpColors(symbol: symbol)
                }

                await setPendingColors(symbol: symbol)
                await defaultTask(symbol: symbol, screen: screen)
                keyState = .notPressed
            }
        }
    }
    
    func defaultTask(symbol: String, screen: Screen) async {
        //print("defaultTask", symbol)

        guard let keyPressResponder = keyPressResponder else { print("no keyPressResponder set"); return }
                        
        let preliminaryResult = stupidBrain.operation(symbol)
        let data = preliminaryResult.getDisplayData(
            multipleLines: false,
            lengths: screen.lengths,
            useMaximalLength: false,
            forceScientific: keyPressResponder.forceScientific,
            showAsInteger: keyPressResponder.showAsInteger,
            showAsFloat: keyPressResponder.showAsFloat)
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
        displayNumber = await keyPressResponder.keyPress(symbol)
        await refreshDisplay(screen: screen)
    }
    
    func refreshDisplay(screen: Screen) async {
        if let keyPressResponder = keyPressResponder {
            let tempDisplayData = displayNumber.getDisplayData(
                    multipleLines: !screen.isPortraitPhone,
                    lengths: screen.lengths,
                    useMaximalLength: false,
                    forceScientific: keyPressResponder.forceScientific,
                    showAsInteger: keyPressResponder.showAsInteger,
                    showAsFloat: keyPressResponder.showAsFloat)
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
    }

    func copyFromPasteBin(screen: Screen) async -> Bool {
        guard let keyPressResponder = keyPressResponder else { return false }
        if let copyResult = await keyPressResponder.copyFromPasteBin() {
            displayNumber = copyResult
            await refreshDisplay(screen: screen)
            return true
        } else {
            return false
        }
    }
    
    func copyToPastBin() async {
        guard let keyPressResponder = keyPressResponder else { return }
        let copyData = displayNumber.getDisplayData(
            multipleLines: true,
            lengths: Lengths(0),
            useMaximalLength: true,
            forceScientific: keyPressResponder.forceScientific,
            showAsInteger: keyPressResponder.showAsInteger,
            showAsFloat: keyPressResponder.showAsFloat)
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
