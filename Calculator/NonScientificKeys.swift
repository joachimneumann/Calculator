//
//  NonScientificKeys.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/20/22.
//

import SwiftUI

struct NonScientificKeys: View {
    let calculatorModel: CalculatorModel
    @ObservedObject var keyModel: KeyModel
    let spaceBetweenKeys: CGFloat
    let keySize: CGSize
    let doubleKeySize: CGSize
    
    init(calculatorModel: CalculatorModel, keyModel: KeyModel, spaceBetweenKeys: CGFloat, size: CGSize) {
        self.calculatorModel = calculatorModel
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
                Key(calculatorModel._AC ? "AC" : "C", keyColors: keyModel.colorsOf[calculatorModel._AC ? "AC" : "C"]!, size: keySize)
                Key("±", keyColors: keyModel.colorsOf["±"]!, size: keySize)
                Key("%", keyColors: keyModel.colorsOf["%"]!, size: keySize)
                Key("/", keyColors: keyModel.colorsOf["/"]!, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("7", keyColors: keyModel.colorsOf["7"]!, size: keySize)
                Key("8", keyColors: keyModel.colorsOf["8"]!, size: keySize)
                Key("9", keyColors: keyModel.colorsOf["9"]!, size: keySize)
                Key("x", keyColors: keyModel.colorsOf["x"]!, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("4", keyColors: keyModel.colorsOf["4"]!, size: keySize)
                Key("5", keyColors: keyModel.colorsOf["5"]!, size: keySize)
                Key("6", keyColors: keyModel.colorsOf["6"]!, size: keySize)
                Key("-", keyColors: keyModel.colorsOf["-"]!, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("1", keyColors: keyModel.colorsOf["1"]!, size: keySize)
                Key("2", keyColors: keyModel.colorsOf["2"]!, size: keySize)
                Key("3", keyColors: keyModel.colorsOf["3"]!, size: keySize)
                Key("+", keyColors: keyModel.colorsOf["+"]!, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("0", keyColors: keyModel.colorsOf["0"]!, size: doubleKeySize)
                Key(",", keyColors: keyModel.colorsOf[","]!, size: keySize)
                Key("=", keyColors: keyModel.colorsOf["="]!, size: keySize)
            }
        }
    }
}

struct NonScientificKeys_Previews: PreviewProvider {
    static var previews: some View {
        NonScientificKeys(calculatorModel: CalculatorModel(), keyModel: KeyModel(), spaceBetweenKeys: 10, size: CGSize(width: 250, height: 300))
    }
}

