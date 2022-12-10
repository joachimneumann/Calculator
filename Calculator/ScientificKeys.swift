//
//  ScientificKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/21/22.
//

import SwiftUI

struct ScientificKeys: View {
    @ObservedObject var model: Model
    let spaceBetweenKeys: CGFloat
    let size: CGSize

//    init(model: KeyModel, spaceBetweenKeys: CGFloat, size: CGSize) {
//        //print("ScientificKeys init()")
//        self.model = model
//        self.spaceBetweenKeys = spaceBetweenKeys
//        let w = (size.width - 5.0 * spaceBetweenKeys) / 6.0
//        let h = (size.height - 4.0 * spaceBetweenKeys) / 5.0
//        self.keySize = CGSize(width: w, height: h)
//    }
    var body: some View {
        let w = (size.width - 5.0 * spaceBetweenKeys) / 6.0
        let h = (size.height - 4.0 * spaceBetweenKeys) / 5.0
        let keySize = CGSize(width: w, height: h)
        VStack(spacing: spaceBetweenKeys) {
            HStack(spacing: spaceBetweenKeys) {
                KeyPrep(symbol: "( ", model: model, keySize: keySize)
                KeyPrep(symbol: " )", model: model, keySize: keySize)
                KeyPrep(symbol: "mc", model: model, keySize: keySize)
                KeyPrep(symbol: "m+", model: model, keySize: keySize)
                KeyPrep(symbol: "m-", model: model, keySize: keySize)
                KeyPrep(symbol: "mr", model: model, keySize: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyPrep(symbol: "2nd", model: model, keySize: keySize)
                KeyPrep(symbol: "x^2", model: model, keySize: keySize)
                KeyPrep(symbol: "x^3", model: model, keySize: keySize)
                KeyPrep(symbol: "x^y", model: model, keySize: keySize)
                KeyPrep(symbol: model._2ndActive ? "y^x" : "e^x", model: model, keySize: keySize)
                KeyPrep(symbol: model._2ndActive ? "2^x" : "10^x", model: model, keySize: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyPrep(symbol: "One_x", model: model, keySize: keySize)
                KeyPrep(symbol: "√", model: model, keySize: keySize)
                KeyPrep(symbol: "3√", model: model, keySize: keySize)
                KeyPrep(symbol: "y√", model: model, keySize: keySize)
                KeyPrep(symbol: model._2ndActive ? "logy" : "ln", model: model, keySize: keySize)
                KeyPrep(symbol: model._2ndActive ? "log2" : "log10", model: model, keySize: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyPrep(symbol: "x!", model: model, keySize: keySize)
                KeyPrep(symbol: model._2ndActive ? "asin" : "sin", model: model, keySize: keySize)
                KeyPrep(symbol: model._2ndActive ? "acos" : "cos", model: model, keySize: keySize)
                KeyPrep(symbol: model._2ndActive ? "atan" : "tan", model: model, keySize: keySize)
                KeyPrep(symbol: "e", model: model, keySize: keySize)
                KeyPrep(symbol: "EE", model: model, keySize: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyPrep(symbol: Model._rad ? "Deg" : "Rad", model: model, keySize: keySize)
                KeyPrep(symbol: model._2ndActive ? "asinh" : "sinh", model: model, keySize: keySize)
                KeyPrep(symbol: model._2ndActive ? "acosh" : "cosh", model: model, keySize: keySize)
                KeyPrep(symbol: model._2ndActive ? "atanh" : "tanh", model: model, keySize: keySize)
                KeyPrep(symbol: "π", model: model, keySize: keySize)
                KeyPrep(symbol: "Rand", model: model, keySize: keySize)
            }
        }
        //.background(Color.black)
    }
}

struct ScientificKeys_Previews: PreviewProvider {
    static var previews: some View {
        ScientificKeys(model: Model(), spaceBetweenKeys: 10, size: CGSize(width: 400, height: 300))
    }
}

