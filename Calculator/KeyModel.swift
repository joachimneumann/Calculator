//
//  KeyModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/27/22.
//

import SwiftUI

class KeyModel: ObservableObject {
    private var calculationResult = CalculationResult(number: Number("0", precision: 10), hasChanged: false, pendingSymbol: nil)
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
        self.currentDisplay = Display()
        for symbol in C.keysAll {
            backgroundColor[symbol] = keyColors(symbol, pending: false).upColor
            textColor[symbol]       = keyColors(symbol, pending: false).textColor
        }
    }
        
    func touchDown(symbol: String) {
        backgroundColor[symbol] = keyColors(symbol, pending: symbol == previouslyPendingOperator).downColor
    }
    
    func touchUp(symbol: String, screen: Screen) {
        backgroundColor[symbol] = keyColors(symbol, pending: symbol == previouslyPendingOperator).upColor
        let _symbol = ["sin", "cos", "tan", "asin", "acos", "atan"].contains(symbol) && !rad ? symbol+"D" : symbol
        
        switch _symbol {
        case "2nd":
            secondActive.toggle()
            backgroundColor["2nd"] = secondActive ? C.secondActiveColors.upColor : C.secondColors.upColor
        case "Rad":
//            hasBeenReset = false
            rad = true
        case "Deg":
//            hasBeenReset = false
            rad = false
        default:
            if _symbol == "AC" {
                showPrecision.toggle()
            }
            if let keyPressResponder = keyPressResponder {
                Task {
                    calculationResult = await keyPressResponder.keyPress(symbol)
                    if let previous = previouslyPendingOperator {
                        await MainActor.run() {
                            backgroundColor[previous] = keyColors(previous, pending: false).upColor
                            textColor[previous] = keyColors(previous, pending: false).textColor
                        }
                    }
                    if let newPending = calculationResult.pendingSymbol {
                        await MainActor.run() {
                            backgroundColor[newPending] = keyColors(newPending, pending: true).upColor
                            textColor[newPending] = keyColors(newPending, pending: true).textColor
                            
//                            this does not seem to work
                        }
                    }
                    previouslyPendingOperator = calculationResult.pendingSymbol
                    await refreshDisplay(screen: screen)
                }
            } else {
                print("no keyPressResponder set")
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
