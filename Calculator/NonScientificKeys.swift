//
//  NonScientificKeys.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/20/22.
//

import SwiftUI

struct KeyBuilder: View {
    let symbol: String
    let enabled: Bool
    let size: CGSize
    @ObservedObject var calculatorModel: CalculatorModel
    
    init(_ symbol: String, _ size: CGSize, _ calculatorModel: CalculatorModel) {
        if calculatorModel.allKeyColors.keys.contains(symbol) {
            self.symbol = symbol
        } else {
            self.symbol = "?"
        }
        self.size = size
        self.calculatorModel = calculatorModel
        self.enabled = true // !calculatorModel._isCalculating
    }
    var body: some View {
        Key(symbol, enabled: enabled, size: size, keyColors: calculatorModel.allKeyColors[symbol]!, callback: calculatorModel.pressed)
    }
}

struct NonScientificKeys: View {
    @ObservedObject var calculatorModel: CalculatorModel
    let spaceBetweenKeys: CGFloat
    let keySize: CGSize
    let doubleKeySize: CGSize
    
    init(calculatorModel: CalculatorModel, spaceBetweenKeys: CGFloat, size: CGSize) {
        self.calculatorModel = calculatorModel
        self.spaceBetweenKeys = spaceBetweenKeys
        let w = (size.width - 3.0 * spaceBetweenKeys) / 4.0
        let h = (size.height - 4.0 * spaceBetweenKeys) / 5.0
        self.keySize = CGSize(width: w, height: h)
        self.doubleKeySize = CGSize(width: 2.0 * w + spaceBetweenKeys, height: h)
    }
    
    var body: some View {
        VStack(spacing: spaceBetweenKeys) {
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder(calculatorModel._AC ? "AC" : "C", keySize, calculatorModel)
                KeyBuilder("±", keySize, calculatorModel)
                KeyBuilder("%", keySize, calculatorModel)
                KeyBuilder("/", keySize, calculatorModel)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder("7", keySize, calculatorModel)
                KeyBuilder("8", keySize, calculatorModel)
                KeyBuilder("9", keySize, calculatorModel)
                KeyBuilder("x", keySize, calculatorModel)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder("4", keySize, calculatorModel)
                KeyBuilder("5", keySize, calculatorModel)
                KeyBuilder("6", keySize, calculatorModel)
                KeyBuilder("-", keySize, calculatorModel)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder("1", keySize, calculatorModel)
                KeyBuilder("2", keySize, calculatorModel)
                KeyBuilder("3", keySize, calculatorModel)
                KeyBuilder("+", keySize, calculatorModel)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder("0", doubleKeySize, calculatorModel)
                KeyBuilder(",", keySize, calculatorModel)
                KeyBuilder("=", keySize, calculatorModel)
            }
        }
    }
}

struct NonScientificKeys_Previews: PreviewProvider {
    static var previews: some View {
        NonScientificKeys(calculatorModel: CalculatorModel(), spaceBetweenKeys: 10, size: CGSize(width: 250, height: 300))
    }
}

