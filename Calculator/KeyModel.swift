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
    @AppStorage("rad", store: .standard) var rad: Bool = false
    @Published var currentDisplay: Display
    
    init() {
        self.currentDisplay = Display(screen: Screen(CGSize()))
        for symbol in C.keysAll {
            backgroundColor[symbol] = keyBackground(symbol).upColor
        }
    }
        
    func touchDown(symbol: String) {
        backgroundColor[symbol] = keyBackground(symbol).downColor
    }
    
    func touchUp(symbol: String, screen: Screen) {
        backgroundColor[symbol] = keyBackground(symbol).upColor
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

    
    func keyBackground(_ symbol: String) -> ColorsOf {
        if C.keysForDigits.contains(symbol) {
            return C.digitColors
        } else if symbol == "2nd" {
            return C.secondColors
        } else if C.keysOfOperator.contains(symbol) {
            return C.operatorColors
        } else if C.keysOfScientificOperators.contains(symbol) {
            return C.scientificColors
        }
        return C.digitColors
    }
}
