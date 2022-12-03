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
        print("ScientificKeys init()")
        self.keyModel = keyModel
        self.spaceBetweenKeys = spaceBetweenKeys
        let w = (size.width - 5.0 * spaceBetweenKeys) / 6.0
        let h = (size.height - 4.0 * spaceBetweenKeys) / 5.0
        self.keySize = CGSize(width: w, height: h)
    }
    var body: some View {
        VStack(spacing: spaceBetweenKeys) {
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: keyModel.keyInfo["( "]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo[" )"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo["mc"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo["m+"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo["m-"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo["mr"]!, keyModel: keyModel, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: keyModel.keyInfo["2nd"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo["x^2"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo["x^3"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo["x^y"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo[keyModel._2ndActive ? "y^x" : "e^x"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo[keyModel._2ndActive ? "2^x" : "10^x"]!, keyModel: keyModel, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: keyModel.keyInfo["One_x"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo["√"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo["3√"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo["y√"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo[keyModel._2ndActive ? "logy" : "ln"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo[keyModel._2ndActive ? "log2" : "log10"]!, keyModel: keyModel, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: keyModel.keyInfo["x!"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo[keyModel._2ndActive ? "asin" : "sin"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo[keyModel._2ndActive ? "acos" : "cos"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo[keyModel._2ndActive ? "atan" : "tan"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo["e"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo["EE"]!, keyModel: keyModel, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: keyModel.keyInfo[keyModel._rad ? "Deg" : "Rad"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo[keyModel._2ndActive ? "asinh" : "sinh"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo[keyModel._2ndActive ? "acosh" : "cosh"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo[keyModel._2ndActive ? "atanh" : "tanh"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo["π"]!, keyModel: keyModel, size: keySize)
                Key(keyInfo: keyModel.keyInfo["Rand"]!, keyModel: keyModel, size: keySize)
            }
        }
        //.background(Color.black)
    }
}

struct ScientificKeys_Previews: PreviewProvider {
    static var previews: some View {
        ScientificKeys(keyModel: KeyModel(), spaceBetweenKeys: 10, size: CGSize(width: 400, height: 300))
    }
}

