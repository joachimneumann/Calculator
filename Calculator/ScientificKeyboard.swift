//
//  ScientificKeyboard.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/21/22.
//

import SwiftUI

struct ScientificKeyboard: View {
    @ObservedObject var keyModel: KeyModel
    let spacing: CGFloat
    let keySize: CGSize

    var body: some View {
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                Key("( ", keyModel)
                Key(" )", keyModel)
                Key("mc", keyModel)
                Key("m+", keyModel)
                Key("m-", keyModel)
                Key("mr", keyModel)
            }
            HStack(spacing: spacing) {
                Key("2nd", keyModel)
                Key("x^2", keyModel)
                Key("x^3", keyModel)
                Key("x^y", keyModel)
                Key(keyModel.secondActive ? "y^x" : "e^x", keyModel)
                Key(keyModel.secondActive ? "2^x" : "10^x", keyModel)
            }
            HStack(spacing: spacing) {
                Key("One_x", keyModel)
                Key("√", keyModel)
                Key("3√", keyModel)
                Key("y√", keyModel)
                Key(keyModel.secondActive ? "logy" : "ln", keyModel)
                Key(keyModel.secondActive ? "log2" : "log10", keyModel)
            }
            HStack(spacing: spacing) {
                Key("x!", keyModel)
                Key(keyModel.secondActive ? "asin" : "sin", keyModel)
                Key(keyModel.secondActive ? "acos" : "cos", keyModel)
                Key(keyModel.secondActive ? "atan" : "tan", keyModel)
                Key("e", keyModel)
                Key("EE", keyModel)
            }
            HStack(spacing: spacing) {
                Key(keyModel.rad ? "Deg" : "Rad", keyModel)
                Key(keyModel.secondActive ? "asinh" : "sinh", keyModel)
                Key(keyModel.secondActive ? "acosh" : "cosh", keyModel)
                Key(keyModel.secondActive ? "atanh" : "tanh", keyModel)
                Key("π", keyModel)
                Key("Rand", keyModel)
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

