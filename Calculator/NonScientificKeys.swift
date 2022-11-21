//
//  NonScientificKeys.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/20/22.
//

import SwiftUI

struct NonScientificKeys: View {
    @StateObject private var keyModel = KeyModel()
    let spaceBetweenKeys: CGFloat
    let keySize: CGSize
    let doubleKeySize: CGSize
    
    init(spaceBetweenKeys: CGFloat, size: CGSize) {
        self.spaceBetweenKeys = spaceBetweenKeys
        let w = (size.width - 3.0 * spaceBetweenKeys) / 4.0
        let h = (size.height - 4.0 * spaceBetweenKeys) / 5.0
        self.keySize = CGSize(width: w, height: h)
        self.doubleKeySize = CGSize(width: 2.0 * w + spaceBetweenKeys, height: h)
    }
    
    struct KeyBuilder: View {
        let symbol: String
        let size: CGSize
        @ObservedObject var keyModel: KeyModel
        init(_ symbol: String, _ size: CGSize, _ keyModel: KeyModel) {
            if keyModel.allKeyColors.keys.contains(symbol) {
                self.symbol = symbol
            } else {
                self.symbol = "C"
            }
            self.size = size
            self.keyModel = keyModel
        }
        var body: some View {
            Key(symbol, size: size, keyColors: keyModel.allKeyColors[symbol]!, callback: keyModel.pressed)
        }
    }

    var body: some View {
        VStack(spacing: spaceBetweenKeys) {
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder("C", keySize, keyModel)
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
        .background(Color.black)
    }
}

struct NonScientificKeys_Previews: PreviewProvider {
    static var previews: some View {
        NonScientificKeys(spaceBetweenKeys: 10, size: CGSize(width: 250, height: 300))
    }
}

