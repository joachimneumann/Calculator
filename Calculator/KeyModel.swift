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
    let upTime = 0.4
    private var downAnimation: Task<(), Error>?

    
    private var calculationResult = CalculationResult(number: Number("0", precision: 10), hasChanged: false)
    var keyPressResponder: KeyPressResponder? = nil
    @Published var showAC = true
    var showPrecision: Bool = false
    var secondActive = false
    @Published var upColor: [String: Color] = [:]
    @Published var downColor: [String: Color] = [:]
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
            upColor[symbol]         = keyColors(symbol, pending: false).upColor
            downColor[symbol]       = keyColors(symbol, pending: false).downColor
            textColor[symbol]       = keyColors(symbol, pending: false).textColor
        }
    }
        
    ///  To give a clear visual feedback to the user that the button has been pressed,
    ///  the animation will always wait for the downAnimation to finish
    
    func touchDown(symbol: String) {
//        downAnimation = Task {
//            upHasHappended = false
//            downAnimationFinished = false
//            await MainActor.run {
//                withAnimation(.easeIn(duration: downTime)) {
//                    backgroundColor[symbol] = keyColors(symbol, pending: symbol == previouslyPendingOperator).downColor
//                }
//            }
//            try await Task.sleep(nanoseconds: UInt64(downTime * 1_000_000_000))
//            downAnimationFinished = true
//            //print("down: upHasHappended", upHasHappended)
//            if upHasHappended {
//                await MainActor.run {
//                    withAnimation(.easeIn(duration: upTime)) {
//                        backgroundColor[symbol] = keyColors(symbol, pending: symbol == previouslyPendingOperator).upColor
//                    }
//                }
//            }
//        }
    }
    
    func touchUp(symbol _symbol: String, screen: Screen) {
        let symbol = ["sin", "cos", "tan", "asin", "acos", "atan"].contains(_symbol) && !rad ? _symbol+"D" : _symbol
        
        switch symbol {
        case "2nd":
            secondActive.toggle()
            backgroundColor["2nd"] = secondActive ? C.secondActiveColors.upColor : C.secondColors.upColor
            upColor["2nd"] = secondActive ? C.secondActiveColors.upColor : C.secondColors.upColor
            downColor["2nd"] = secondActive ? C.secondActiveColors.downColor : C.secondColors.downColor
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
                        upColor[previous] = keyColors(previous, pending: false).upColor
                        downColor[previous] = keyColors(previous, pending: false).downColor
                        textColor[previous] = keyColors(previous, pending: false).textColor
                    }
                }
                if C.keysThatHavePendingOperation.contains(symbol) {
                    await MainActor.run() {
                        backgroundColor[symbol] = keyColors(symbol, pending: true).upColor
                        upColor[symbol] = keyColors(symbol, pending: true).upColor
                        downColor[symbol] = keyColors(symbol, pending: true).downColor
                        textColor[symbol] = keyColors(symbol, pending: true).textColor
                        previouslyPendingOperator = symbol
                    }
                }
                
                upHasHappended = true
                if downAnimationFinished {
                    await MainActor.run {
                        withAnimation(.easeIn(duration: upTime)) {
                            backgroundColor[symbol] = keyColors(symbol, pending: symbol == previouslyPendingOperator).upColor
                            upColor[symbol] = keyColors(symbol, pending: symbol == previouslyPendingOperator).upColor
                            downColor[symbol] = keyColors(symbol, pending: symbol == previouslyPendingOperator).downColor
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
