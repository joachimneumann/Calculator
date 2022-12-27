//
//  KeyModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/27/22.
//

import SwiftUI

class KeyModel: ObservableObject {
    let keySize: CGSize
    var showAC = true
    var secondActive = false
    @Published var backgroundColor: [String: Color] = [:]
    @AppStorage("rad", store: .standard) var rad: Bool = false

    private let model: Model

    init(model: Model) {
        keySize = model.screen.keySize
        self.model = model
        for symbol in C.keysAll {
            backgroundColor[symbol] = keyBackground(symbol).upColor
        }
    }
    
    func touchDown(symbol: String) {
        backgroundColor[symbol] = keyBackground(symbol).downColor
    }
    
    func touchUp(symbol: String) {
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
            Task {
                await model.pressed(symbol)
                if await model.isNull {
                    showAC = true
                } else {
                    showAC = false
                }
            }
//            if !isCalculating && keyInfo[symbol]!.enabled {
//                execute(symbol)
//            }
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
