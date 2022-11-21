//
//  ScientificKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/21/22.
//

import SwiftUI

struct ScientificKeys: View {
    @ObservedObject var keyModel: KeyModel
    let spaceBetweenKeys: CGFloat
    let keySize: CGSize

    init(keyModel: KeyModel, spaceBetweenKeys: CGFloat, size: CGSize) {
        self.keyModel = keyModel
        self.spaceBetweenKeys = spaceBetweenKeys
        let w = (size.width - 5.0 * spaceBetweenKeys) / 6.0
        let h = (size.height - 4.0 * spaceBetweenKeys) / 5.0
        self.keySize = CGSize(width: w, height: h)
    }

    //                OldKey(brain.secondKeys ? "logy" : "ln", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
    //                OldKey(brain.secondKeys ? "log2" : "log10", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
    //                OldKey(brain.rad ? (brain.secondKeys ? "asin" : "sin") : (brain.secondKeys ? "asinD" : "sinD"), requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
    //                OldKey(brain.rad ? (brain.secondKeys ? "acos" : "cos") : (brain.secondKeys ? "acosD" : "cosD"), requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
    //                OldKey(brain.rad ? (brain.secondKeys ? "atan" : "tan") : (brain.secondKeys ? "atanD" : "tanD"), requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
    //                OldKey(brain.secondKeys ? "asinh" : "sinh", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
    //                OldKey(brain.secondKeys ? "acosh" : "cosh", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
    //                OldKey(brain.secondKeys ? "atanh" : "tanh", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
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
                KeyBuilder(keyModel._2ndActive ? "y^x" : "e^x", keySize, keyModel)
                KeyBuilder(keyModel._2ndActive ? "2^x" : "10^x", keySize, keyModel)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder("One_x", keySize, keyModel)
                KeyBuilder("√", keySize, keyModel)
                KeyBuilder("3√", keySize, keyModel)
                KeyBuilder("y√", keySize, keyModel)
                KeyBuilder(keyModel._2ndActive ? "logy" : "ln", keySize, keyModel)
                KeyBuilder(keyModel._2ndActive ? "log2" : "log10", keySize, keyModel)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder("x!", keySize, keyModel)
                KeyBuilder(keyModel._2ndActive ? "asin" : "sin", keySize, keyModel)
                KeyBuilder(keyModel._2ndActive ? "acos" : "cos", keySize, keyModel)
                KeyBuilder(keyModel._2ndActive ? "atan" : "tan", keySize, keyModel)
                KeyBuilder("e", keySize, keyModel)
                KeyBuilder("EE", keySize, keyModel)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyBuilder(keyModel._rad ? "Rad" : "Deg", keySize, keyModel)
                KeyBuilder(keyModel._2ndActive ? "asinh" : "sinh", keySize, keyModel)
                KeyBuilder(keyModel._2ndActive ? "acosh" : "cosh", keySize, keyModel)
                KeyBuilder(keyModel._2ndActive ? "atanh" : "tanh", keySize, keyModel)
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
