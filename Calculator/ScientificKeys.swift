//
//  ScientificKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/21/22.
//

import SwiftUI

struct ScientificKeys: View {
    let calculatorModel: CalculatorModel
    @ObservedObject var keyModel: KeyModel
    let spaceBetweenKeys: CGFloat
    let keySize: CGSize

    init(calculatorModel: CalculatorModel, keyModel: KeyModel, spaceBetweenKeys: CGFloat, size: CGSize) {
        self.calculatorModel = calculatorModel
        self.keyModel = keyModel
        self.spaceBetweenKeys = spaceBetweenKeys
        let w = (size.width - 5.0 * spaceBetweenKeys) / 6.0
        let h = (size.height - 4.0 * spaceBetweenKeys) / 5.0
        self.keySize = CGSize(width: w, height: h)
    }
    var body: some View {
        VStack(spacing: spaceBetweenKeys) {
            HStack(spacing: spaceBetweenKeys) {
                Key("( ", keyColors: keyModel.colorsOf["( "]!, size: keySize)
                Key(" )", keyColors: keyModel.colorsOf[" )"]!, size: keySize)
                Key("mc", keyColors: keyModel.colorsOf["mc"]!, size: keySize)
                Key("m+", keyColors: keyModel.colorsOf["m+"]!, size: keySize)
                Key("m-", keyColors: keyModel.colorsOf["m-"]!, size: keySize)
                Key("mr", keyColors: keyModel.colorsOf["mr"]!, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("2nd", keyColors: keyModel.colorsOf["2nd"]!, size: keySize)
                Key("x^2", keyColors: keyModel.colorsOf["x^2"]!, size: keySize)
                Key("x^3", keyColors: keyModel.colorsOf["x^3"]!, size: keySize)
                Key("x^y", keyColors: keyModel.colorsOf["x^y"]!, size: keySize)
                Key(keyModel._2ndActive ? "y^x" : "e^x", keyColors: keyModel.colorsOf[keyModel._2ndActive ? "y^x" : "e^x"]!, size: keySize)
                Key(keyModel._2ndActive ? "2^x" : "10^x", keyColors: keyModel.colorsOf[keyModel._2ndActive ? "2^x" : "10^x"]!, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("One_x", keyColors: keyModel.colorsOf["One_x"]!, size: keySize)
                Key("√", keyColors: keyModel.colorsOf["√"]!, size: keySize)
                Key("3√", keyColors: keyModel.colorsOf["3√"]!, size: keySize)
                Key("y√", keyColors: keyModel.colorsOf["y√"]!, size: keySize)
                Key(keyModel._2ndActive ? "logy" : "ln", keyColors: keyModel.colorsOf[keyModel._2ndActive ? "logy" : "ln"]!, size: keySize)
                Key(keyModel._2ndActive ? "log2" : "log10", keyColors: keyModel.colorsOf[keyModel._2ndActive ? "log2" : "log10"]!, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("x!", keyColors: keyModel.colorsOf["x!"]!, size: keySize)
                Key(keyModel._2ndActive ? "asin" : "sin", keyColors: keyModel.colorsOf[keyModel._2ndActive ? "asin" : "sin"]!, size: keySize)
                Key(keyModel._2ndActive ? "acos" : "cos", keyColors: keyModel.colorsOf[keyModel._2ndActive ? "acos" : "cos"]!, size: keySize)
                Key(keyModel._2ndActive ? "atan" : "tan", keyColors: keyModel.colorsOf[keyModel._2ndActive ? "atan" : "tan"]!, size: keySize)
                Key("e", keyColors: keyModel.colorsOf["e"]!, size: keySize)
                Key("EE", keyColors: keyModel.colorsOf["EE"]!, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key(keyModel._rad ? "Rad" : "Deg", keyColors: keyModel.colorsOf[keyModel._rad ? "Rad" : "Deg"]!, size: keySize)
                Key(keyModel._2ndActive ? "asinh" : "sinh", keyColors: keyModel.colorsOf[keyModel._2ndActive ? "asinh" : "sinh"]!, size: keySize)
                Key(keyModel._2ndActive ? "acosh" : "cosh", keyColors: keyModel.colorsOf[keyModel._2ndActive ? "acosh" : "cosh"]!, size: keySize)
                Key(keyModel._2ndActive ? "atanh" : "tanh", keyColors: keyModel.colorsOf[keyModel._2ndActive ? "atanh" : "tanh"]!, size: keySize)
                Key("π", keyColors: keyModel.colorsOf["π"]!, size: keySize)
                Key("Rand", keyColors: keyModel.colorsOf["Rand"]!, size: keySize)
            }
        }
        .background(Color.black)
    }
}

struct ScientificKeys_Previews: PreviewProvider {
    static var previews: some View {
        ScientificKeys(calculatorModel: CalculatorModel(), keyModel: KeyModel(), spaceBetweenKeys: 10, size: CGSize(width: 400, height: 300))
    }
}

