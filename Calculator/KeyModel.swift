//
//  KeyModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/27/22.
//

import SwiftUI

class KeyModel: ObservableObject {
    var upHasHappended = false
    var downAnimationFinished = false
    let downTime = 0.1
    let upTime = 0.3
    private var downAnimation: Task<(), Error>?

    
    private var calculationResult = CalculationResult(number: Number("0", precision: 10), hasChanged: false)
    var keyPressResponder: KeyPressResponder? = nil
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
        
    private func setBG(_ symbol: String, _ color: Color) {
        Task {
            await MainActor.run() {
                backgroundColor[symbol] = color
            }
        }
    }
    private func setT(_ symbol: String, _ color: Color) {
        Task {
            await MainActor.run() {
                textColor[symbol] = color
            }
        }
    }

    ///  To give a clear visual feedback to the user that the button has been pressed,
    ///  the animation will always wait for the downAnimation to finish
    
    func touchDown(symbol: String) {
        downAnimation = Task {
            upHasHappended = false
            downAnimationFinished = false
            withAnimation(.easeIn(duration: downTime)) {
                setBG(symbol, keyColors(symbol, pending: symbol == previouslyPendingOperator).downColor)
            }
            try await Task.sleep(nanoseconds: UInt64(downTime * 1_000_000_000))
            downAnimationFinished = true
            // print("down: upHasHappended", upHasHappended)
            if upHasHappended {
                withAnimation(.easeIn(duration: upTime)) {
                    setBG(symbol, keyColors(symbol, pending: symbol == previouslyPendingOperator).upColor)
                }
            }
        }
    }
    
    func touchUp(symbol _symbol: String, screen: Screen) {
        let symbol = ["sin", "cos", "tan", "asin", "acos", "atan"].contains(_symbol) && !rad ? _symbol+"D" : _symbol
        
        switch symbol {
        case "2nd":
            secondActive.toggle()
            setBG("2nd", secondActive ? C.secondActiveColors.upColor : C.secondColors.upColor)
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
                if C.keysThatHavePendingOperation.contains(symbol) {
                    setBG(symbol, keyColors(symbol, pending: true).upColor)
                    setT(symbol, keyColors(symbol, pending: true).textColor)
                    previouslyPendingOperator = symbol
                } else {
                    if let previous = previouslyPendingOperator {
                        setBG(previous, keyColors(previous, pending: false).upColor)
                        setT(previous, keyColors(previous, pending: false).textColor)
                    }
                }
                
                upHasHappended = true
                if downAnimationFinished {
                    withAnimation(.easeIn(duration: upTime)) {
                        setBG(symbol, keyColors(symbol, pending: symbol == previouslyPendingOperator).upColor)
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
            }
        }
    }

    
    func keyColors(_ symbol: String, pending: Bool) -> ColorsOf {
        if C.keysForDigits.contains(symbol) {
            return C.digitColors
        } else if symbol == "2nd" {
            return C.secondColors
        } else if C.keysOfOperator.contains(symbol) {
            return pending ? C.pendingOperatorColors : C.operatorColors
        } else if C.keysOfScientificOperators.contains(symbol) {
            return pending ? C.pendingScientificColors : C.scientificColors
        }
        return C.digitColors
    }
}
