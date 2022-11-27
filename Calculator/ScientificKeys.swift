//
//  ScientificKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/21/22.
//

import SwiftUI

struct ScientificKeys: View {
    @ObservedObject var calculatorModel: CalculatorModel
    let spaceBetweenKeys: CGFloat
    let keySize: CGSize

    init(calculatorModel: CalculatorModel, spaceBetweenKeys: CGFloat, size: CGSize) {
        self.calculatorModel = calculatorModel
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
//            HStack(spacing: spaceBetweenKeys) {
//                KeyBuilder("( ", keySize, calculatorModel)
//                KeyBuilder(" )", keySize, calculatorModel)
//                KeyBuilder("mc", keySize, calculatorModel)
//                KeyBuilder("m+", keySize, calculatorModel)
//                KeyBuilder("m-", keySize, calculatorModel)
//                KeyBuilder("mr", keySize, calculatorModel)
//            }
//            HStack(spacing: spaceBetweenKeys) {
//                KeyBuilder("2nd", keySize, calculatorModel)
//                KeyBuilder("x^2", keySize, calculatorModel)
//                KeyBuilder("x^3", keySize, calculatorModel)
//                KeyBuilder("x^y", keySize, calculatorModel)
//                KeyBuilder(calculatorModel._2ndActive ? "y^x" : "e^x", keySize, calculatorModel)
//                KeyBuilder(calculatorModel._2ndActive ? "2^x" : "10^x", keySize, calculatorModel)
//            }
//            HStack(spacing: spaceBetweenKeys) {
//                KeyBuilder("One_x", keySize, calculatorModel)
//                KeyBuilder("√", keySize, calculatorModel)
//                KeyBuilder("3√", keySize, calculatorModel)
//                KeyBuilder("y√", keySize, calculatorModel)
//                KeyBuilder(calculatorModel._2ndActive ? "logy" : "ln", keySize, calculatorModel)
//                KeyBuilder(calculatorModel._2ndActive ? "log2" : "log10", keySize, calculatorModel)
//            }
//            HStack(spacing: spaceBetweenKeys) {
//                KeyBuilder("x!", keySize, calculatorModel)
//                KeyBuilder(calculatorModel._2ndActive ? "asin" : "sin", keySize, calculatorModel)
//                KeyBuilder(calculatorModel._2ndActive ? "acos" : "cos", keySize, calculatorModel)
//                KeyBuilder(calculatorModel._2ndActive ? "atan" : "tan", keySize, calculatorModel)
//                KeyBuilder("e", keySize, calculatorModel)
//                KeyBuilder("EE", keySize, calculatorModel)
//            }
//            HStack(spacing: spaceBetweenKeys) {
//                KeyBuilder(calculatorModel._rad ? "Rad" : "Deg", keySize, calculatorModel)
//                KeyBuilder(calculatorModel._2ndActive ? "asinh" : "sinh", keySize, calculatorModel)
//                KeyBuilder(calculatorModel._2ndActive ? "acosh" : "cosh", keySize, calculatorModel)
//                KeyBuilder(calculatorModel._2ndActive ? "atanh" : "tanh", keySize, calculatorModel)
//                KeyBuilder("π", keySize, calculatorModel)
//                KeyBuilder("Rand", keySize, calculatorModel)
//            }
        }
        .background(Color.black)
    }
}

struct ScientificKeys_Previews: PreviewProvider {
    static var previews: some View {
        ScientificKeys(calculatorModel: CalculatorModel(), spaceBetweenKeys: 10, size: CGSize(width: 400, height: 300))
    }
}
