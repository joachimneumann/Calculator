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
                Key(keyInfo: model.keyInfo["( "]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo[" )"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["mc"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["m+"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["m-"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["mr"]!, model: model, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: model.keyInfo["2nd"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["x^2"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["x^3"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["x^y"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo[model._2ndActive ? "y^x" : "e^x"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo[model._2ndActive ? "2^x" : "10^x"]!, model: model, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: model.keyInfo["One_x"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["√"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["3√"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["y√"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo[model._2ndActive ? "logy" : "ln"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo[model._2ndActive ? "log2" : "log10"]!, model: model, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: model.keyInfo["x!"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo[model._2ndActive ? "asin" : "sin"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo[model._2ndActive ? "acos" : "cos"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo[model._2ndActive ? "atan" : "tan"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["e"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["EE"]!, model: model, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: model.keyInfo[Model._rad ? "Deg" : "Rad"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo[model._2ndActive ? "asinh" : "sinh"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo[model._2ndActive ? "acosh" : "cosh"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo[model._2ndActive ? "atanh" : "tanh"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["π"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["Rand"]!, model: model, size: keySize)
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

