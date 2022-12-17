//
//  ScientificKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/21/22.
//

import SwiftUI

struct ScientificBoard: View {
    @ObservedObject var model: Model
    let spacing: CGFloat
    let keySize: CGSize

    var body: some View {
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                Key(keyInfo: model.keyInfo["( "]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo[" )"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["mc"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["m+"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["m-"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["mr"]!, modelCallback: model.pressed, size: keySize)
            }
            HStack(spacing: spacing) {
                Key(keyInfo: model.keyInfo["2nd"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["x^2"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["x^3"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["x^y"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo[model.secondActive ? "y^x" : "e^x"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo[model.secondActive ? "2^x" : "10^x"]!, modelCallback: model.pressed, size: keySize)
            }
            HStack(spacing: spacing) {
                Key(keyInfo: model.keyInfo["One_x"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["√"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["3√"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["y√"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo[model.secondActive ? "logy" : "ln"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo[model.secondActive ? "log2" : "log10"]!, modelCallback: model.pressed, size: keySize)
            }
            HStack(spacing: spacing) {
                Key(keyInfo: model.keyInfo["x!"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo[model.secondActive ? "asin" : "sin"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo[model.secondActive ? "acos" : "cos"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo[model.secondActive ? "atan" : "tan"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["e"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["EE"]!, modelCallback: model.pressed, size: keySize)
            }
            HStack(spacing: spacing) {
                Key(keyInfo: model.keyInfo[Model.rad ? "Deg" : "Rad"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo[model.secondActive ? "asinh" : "sinh"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo[model.secondActive ? "acosh" : "cosh"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo[model.secondActive ? "atanh" : "tanh"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["π"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["Rand"]!, modelCallback: model.pressed, size: keySize)
            }
        }
        //.background(Color.black)
    }
}

//struct ScientificKeys_Previews: PreviewProvider {
//    static var previews: some View {
//        ScientificBoard(model: Model(), spacing: 10, keySize: CGSize(width: 400, height: 300))
//    }
//}

