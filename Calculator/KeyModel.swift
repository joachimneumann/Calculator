//
//  KeyModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/27/22.
//

import SwiftUI

/*
 10 million digits. Then
 8 7 times x^3 --> 1,14.. e1975. Then quickly press 3rd root, and x^3
 1. Problem: result back to 1,14.. e1975. Should be 2,25.. e658
 2. Problem: red color remains visible too long
 
 keyState:
 case notPressed,
 case downlegal,
 case downNotlegal,
 case upPreliminaryProcessing
 case upHighprecisionProcessing
 */


class KeyModel: ObservableObject {
    var keyPressResponder: KeyPressResponder?
    var stupidBrain = BrainEngine(precision: 100)
    
    private enum KeyState {
        case notPressed
        case processing
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
    
    private var calculationResult = CalculationResult()
    @Published var showAC = true
    var showPrecision: Bool = false
    var secondActive = false
    @Published var backgroundColor: [String: Color] = [:]
    @Published var textColor: [String: Color] = [:]
    @AppStorage("rad", store: .standard) var rad: Bool = false
    @Published var currentDisplay: Display
    private var previouslyPendingOperator: String? = nil
    init() {
        print("KeyModel INIT")
        self.currentDisplay = Display()
        for symbol in C.keysAll {
            backgroundColor[symbol] = keyColors(symbol, pending: false).upColor
            textColor[symbol]       = keyColors(symbol, pending: false).textColor
        }
    }
    
    ///  To give a clear visual feedback to the user that the button has been pressed,
    ///  the animation will always wait for the downAnimation to finish
    
    func touchDown(symbol: String) {
        Task(priority: .userInitiated) {
            let notValid = !calculationResult.isValidNumber && C.keysThatRequireValidNumber.contains(symbol)
            if keyState != .notPressed || notValid {
                await MainActor.run {
                    withAnimation(.easeIn(duration: downTime)) {
                        backgroundColor[symbol] = disabledColor
                    }
                }
                try await Task.sleep(nanoseconds: UInt64(downTime * 1_000_000_000))
                await MainActor.run {
                    withAnimation(.easeIn(duration: upTime)) {
                        backgroundColor[symbol] = keyColors(symbol, pending: symbol == previouslyPendingOperator).upColor
                    }
                }
                return
            }

            print("down keyState", keyState)
            upHasHappended = false
            downAnimationFinished = false
            await MainActor.run {
                withAnimation(.easeIn(duration: downTime)) {
                    backgroundColor[symbol] = keyColors(symbol, pending: symbol == previouslyPendingOperator).downColor
                }
            }
            //print("down: timer START", downTime)
            try await Task.sleep(nanoseconds: UInt64(downTime * 1_000_000_000))
            //print("down: timer STOP")
            downAnimationFinished = true
            //print("down: upHasHappended", upHasHappended)
            if upHasHappended {
                await MainActor.run {
                    withAnimation(.easeIn(duration: upTime)) {
                        backgroundColor[symbol] = keyColors(symbol, pending: symbol == previouslyPendingOperator).upColor
                    }
                }
            }
        }
    }
    
    func touchUp(symbol rawSymbol: String, screen: Screen) {
        let symbol = ["sin", "cos", "tan", "asin", "acos", "atan"].contains(rawSymbol) && !rad ? rawSymbol+"D" : rawSymbol

        print("up, state = ", keyState)
        guard keyState == .notPressed else { return }


        let valid = calculationResult.isValidNumber || !C.keysThatRequireValidNumber.contains(symbol)
        guard valid else { return }

        keyState = .processing

        switch symbol {
        case "2nd":
            secondActive.toggle()
            backgroundColor["2nd"] = secondActive ? secondActiveColors.upColor : secondColors.upColor
        case "Rad":
            //            hasBeenReset = false
            rad = true
        case "Deg":
            //            hasBeenReset = false
            rad = false
        default:
            upHasHappended = true
            Task(priority: .low) {
                await defaultTask(symbol: symbol, screen: screen)
                keyState = .notPressed
            }
        }
    }
    
    func defaultTask(symbol: String, screen: Screen) async {
        print("defaultTask", symbol)

        guard let keyPressResponder = keyPressResponder else { print("no keyPressResponder set"); return }

        /// Set the background color back to normal
        if downAnimationFinished {
            await MainActor.run {
                withAnimation(.easeIn(duration: upTime)) {
                    backgroundColor[symbol] = keyColors(symbol, pending: symbol == previouslyPendingOperator).upColor
                }
            }
        }
        
        if symbol == "AC" {
            showPrecision.toggle()
        }
        
        let preliminaryResult = stupidBrain.operation(symbol)
        let data = preliminaryResult.number.getDisplayData(
            multipleLines: false,
            lengths: screen.lengths,
            forceScientific: keyPressResponder.forceScientific,
            showAsInteger: keyPressResponder.showAsInteger,
            showAsFloat: keyPressResponder.showAsFloat)
        let format = DisplayFormat(
            for: data.length,
            withMaxLength: data.maxlength,
            showThreeDots: true,
            screen: screen)
        let preliminaryDisplay = Display(data: data, format: format)

        await MainActor.run() {
            currentDisplay = preliminaryDisplay
        }

        /// pending colors
        if let previous = previouslyPendingOperator {
            await MainActor.run() {
                backgroundColor[previous] = keyColors(previous, pending: false).upColor
                textColor[previous] = keyColors(previous, pending: false).textColor
            }
        }
        if ["/", "x", "-", "+", "x^y", "y^x"].contains(symbol) {
            await MainActor.run() {
                backgroundColor[symbol] = keyColors(symbol, pending: true).upColor
                textColor[symbol] = keyColors(symbol, pending: true).textColor
                previouslyPendingOperator = symbol
            }
        }

        calculationResult = await keyPressResponder.keyPress(symbol)
        await refreshDisplay(screen: screen)
    }
    func refreshDisplay(screen: Screen) async {
        if let keyPressResponder = keyPressResponder {
            let tempDisplay = await calculationResult.getDisplay(keyPressResponder: keyPressResponder, screen: screen)
            await MainActor.run() {
                currentDisplay = tempDisplay
                //print("currentDisplay", currentDisplay.data.left)
            }
        }
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
