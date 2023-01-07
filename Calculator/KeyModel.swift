//
//  KeyModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/27/22.
//

import SwiftUI

class KeyModel: ObservableObject {
    var keyPressResponder: KeyPressResponder?

    let digitColors = ColorsOf(
        textColor: .white,
        upColor:   Color(white: 0.2),
        downColor: Color(white: 0.45))
    let disabledColor = Color.red
    let operatorColors = ColorsOf(
        textColor: Color(.white),
        upColor:   Color(white: 0.5),
        downColor: Color(white: 0.7))
    let pendingOperatorColors = ColorsOf(
        textColor: Color(white: 0.3),
        upColor:   Color(white: 0.9),
        downColor: Color(white: 0.8))
    let scientificColors = ColorsOf(
        textColor: Color(.white),
        upColor:   Color(white: 0.12),
        downColor: Color(white: 0.32))
    let pendingScientificColors = ColorsOf(
        textColor: Color(white: 0.3),
        upColor:   Color(white: 0.7),
        downColor: Color(white: 0.6))
    let secondColors = ColorsOf(
        textColor: Color(.white),
        upColor:   Color(white: 0.12),
        downColor: Color(white: 0.12))
    let secondActiveColors = ColorsOf(
        textColor: Color(white: 0.2),
        upColor:   Color(white: 0.6),
        downColor: Color(white: 0.6))
    var upHasHappended = false
    var downAnimationFinished = false
    let downTime = 0.1
    let upTime = 0.4
    private var downAnimation: Task<(), Error>?
    
    private var calculationResult = CalculationResult(number: Number("0", precision: 10), hasChanged: false)
    @Published var showAC = true
    var showPrecision: Bool = false
    var secondActive = false
    @Published var backgroundColor: [String: Color] = [:]
    @Published var textColor: [String: Color] = [:]
    @AppStorage("rad", store: .standard) var rad: Bool = false
    @Published var currentDisplay: Display
    private var previouslyPendingOperator: String? = nil
    init() {
        // print("KeyModel INIT")
        self.currentDisplay = Display()
        for symbol in C.keysAll {
            backgroundColor[symbol] = keyColors(symbol, pending: false).upColor
            textColor[symbol]       = keyColors(symbol, pending: false).textColor
        }
    }
        
    ///  To give a clear visual feedback to the user that the button has been pressed,
    ///  the animation will always wait for the downAnimation to finish
    
    func touchDown(symbol: String) {
        downAnimation = Task {
            upHasHappended = false
            downAnimationFinished = false
            await MainActor.run {
                withAnimation(.easeIn(duration: downTime)) {
                    backgroundColor[symbol] = keyColors(symbol, pending: symbol == previouslyPendingOperator).downColor
                }
            }
            try await Task.sleep(nanoseconds: UInt64(downTime * 1_000_000_000))
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
    
    func touchUp(symbol _symbol: String, screen: Screen) {
        let symbol = ["sin", "cos", "tan", "asin", "acos", "atan"].contains(_symbol) && !rad ? _symbol+"D" : _symbol
        
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
            if symbol == "AC" {
                showPrecision.toggle()
            }
            Task {
                //await MainActor.run { }

                /// pending colors
                if let previous = previouslyPendingOperator {
                    await MainActor.run() {
                        backgroundColor[previous] = keyColors(previous, pending: false).upColor
                        textColor[previous] = keyColors(previous, pending: false).textColor
                    }
                }
                if C.keysThatHavePendingOperation.contains(symbol) {
                    await MainActor.run() {
                        backgroundColor[symbol] = keyColors(symbol, pending: true).upColor
                        textColor[symbol] = keyColors(symbol, pending: true).textColor
                        previouslyPendingOperator = symbol
                    }
                }
                
                upHasHappended = true
                if downAnimationFinished {
                    await MainActor.run {
                        withAnimation(.easeIn(duration: upTime)) {
                            backgroundColor[symbol] = keyColors(symbol, pending: symbol == previouslyPendingOperator).upColor
                        }
                    }
                }
                
                guard let keyPressResponder = keyPressResponder else { print("no keyPressResponder set"); return }
                calculationResult = await keyPressResponder.keyPress(symbol)
                await refreshDisplay(screen: screen)
            }
        }
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
        if C.keysForDigits.contains(symbol) {
            return digitColors
        } else if symbol == "2nd" {
            return secondColors
        } else if C.keysOfOperator.contains(symbol) {
            return pending ? pendingOperatorColors : operatorColors
        } else if C.keysOfScientificOperators.contains(symbol) {
            return pending ? pendingScientificColors : scientificColors
        }
        return digitColors
    }
}
