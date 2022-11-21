//
//  ScientificKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/21/22.
//

import SwiftUI

struct ScientificKeys: View {
    var keyModel: KeyModel
    let spaceBetweenKeys: CGFloat
    let keySize: CGSize

    init(keyModel: KeyModel, spaceBetweenKeys: CGFloat, size: CGSize) {
        self.keyModel = keyModel
        self.spaceBetweenKeys = spaceBetweenKeys
        let w = (size.width - 5.0 * spaceBetweenKeys) / 6.0
        let h = (size.height - 4.0 * spaceBetweenKeys) / 5.0
        self.keySize = CGSize(width: w, height: h)
    }

    var body: some View {
        VStack(spacing: spaceBetweenKeys) {
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder("( ", keySize, keyModel)
                KeyBuilder(" )", keySize, keyModel)
                KeyBuilder("mc", keySize, keyModel)
                KeyBuilder("m+", keySize, keyModel)
                KeyBuilder("m-", keySize, keyModel)
                KeyBuilder("mr", keySize, keyModel)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder("2nd", keySize, keyModel)
                KeyBuilder("x^2", keySize, keyModel)
                KeyBuilder("x^3", keySize, keyModel)
                KeyBuilder("x^y", keySize, keyModel)
                KeyBuilder("y^x", keySize, keyModel)
                KeyBuilder("2^x", keySize, keyModel)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder("One_x", keySize, keyModel)
                KeyBuilder("√", keySize, keyModel)
                KeyBuilder("3√", keySize, keyModel)
                KeyBuilder("y√", keySize, keyModel)
                KeyBuilder("logy", keySize, keyModel)
                KeyBuilder("log2", keySize, keyModel) /// todo: brain.secondkeys
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder("x!", keySize, keyModel)
                KeyBuilder("sin", keySize, keyModel)
                KeyBuilder("cos", keySize, keyModel)
                KeyBuilder("tan", keySize, keyModel)
                KeyBuilder("e", keySize, keyModel)
                KeyBuilder("EE", keySize, keyModel)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder("Deg", keySize, keyModel)
                KeyBuilder("sinh", keySize, keyModel)
                KeyBuilder("cosh", keySize, keyModel)
                KeyBuilder("tanh", keySize, keyModel)
                KeyBuilder("π", keySize, keyModel)
                KeyBuilder("Rand", keySize, keyModel)
            }
        }
        .background(Color.black)
    }
}

struct ScientificKeys_Previews: PreviewProvider {
    static var previews: some View {
        ScientificKeys(keyModel: KeyModel(), spaceBetweenKeys: 10, size: CGSize(width: 400, height: 300))
    }
}
