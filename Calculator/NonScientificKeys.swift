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
    @ObservedObject var keyModel: CalculatorModel
    init(_ symbol: String, _ size: CGSize, _ keyModel: CalculatorModel) {
        if keyModel.allKeyColors.keys.contains(symbol) {
            self.symbol = symbol
        } else {
            self.symbol = "?"
        }
        self.size = size
        self.keyModel = keyModel
        self.enabled = true // !keyModel._isCalculating
    }
    var body: some View {
        Key(symbol, enabled: enabled, size: size, keyColors: keyModel.allKeyColors[symbol]!, callback: keyModel.pressed)
    }
}

struct NonScientificKeys: View {
    @ObservedObject var keyModel: CalculatorModel
    let spaceBetweenKeys: CGFloat
    let keySize: CGSize
    let doubleKeySize: CGSize
    
    init(keyModel: CalculatorModel, spaceBetweenKeys: CGFloat, size: CGSize) {
        self.keyModel = keyModel
        self.spaceBetweenKeys = spaceBetweenKeys
        let w = (size.width - 3.0 * spaceBetweenKeys) / 4.0
        let h = (size.height - 4.0 * spaceBetweenKeys) / 5.0
        self.keySize = CGSize(width: w, height: h)
        self.doubleKeySize = CGSize(width: 2.0 * w + spaceBetweenKeys, height: h)
    }
    
    var body: some View {
        VStack(spacing: spaceBetweenKeys) {
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder(keyModel._AC ? "AC" : "C", keySize, keyModel)
                KeyBuilder("±", keySize, keyModel)
                KeyBuilder("%", keySize, keyModel)
                KeyBuilder("/", keySize, keyModel)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder("7", keySize, keyModel)
                KeyBuilder("8", keySize, keyModel)
                KeyBuilder("9", keySize, keyModel)
                KeyBuilder("x", keySize, keyModel)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder("4", keySize, keyModel)
                KeyBuilder("5", keySize, keyModel)
                KeyBuilder("6", keySize, keyModel)
                KeyBuilder("-", keySize, keyModel)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder("1", keySize, keyModel)
                KeyBuilder("2", keySize, keyModel)
                KeyBuilder("3", keySize, keyModel)
                KeyBuilder("+", keySize, keyModel)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder("0", doubleKeySize, keyModel)
                KeyBuilder(",", keySize, keyModel)
                KeyBuilder("=", keySize, keyModel)
            }
        }
    }
}

struct NonScientificKeys_Previews: PreviewProvider {
    static var previews: some View {
        NonScientificKeys(keyModel: CalculatorModel(), spaceBetweenKeys: 10, size: CGSize(width: 250, height: 300))
    }
}

