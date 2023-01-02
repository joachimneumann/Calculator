//
//  ScientificKeyboard.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/21/22.
//

import SwiftUI

struct ScientificKeyboard: View {
    let screen: Screen
    @ObservedObject var keyModel: KeyModel

    var body: some View {
        let spacing = screen.keySpacing
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                Key("( ", screen, keyModel)
                Key(" )", screen, keyModel)
                Key("mc", screen, keyModel)
                Key("m+", screen, keyModel)
                Key("m-", screen, keyModel)
                Key("mr", screen, keyModel)
            }
            HStack(spacing: spacing) {
                Key("2nd", screen, keyModel)
                Key("x^2", screen, keyModel)
                Key("x^3", screen, keyModel)
                Key("x^y", screen, keyModel)
                Key(keyModel.secondActive ? "y^x" : "e^x", screen, keyModel)
                Key(keyModel.secondActive ? "2^x" : "10^x", screen, keyModel)
            }
            HStack(spacing: spacing) {
                Key("One_x", screen, keyModel)
                Key("√", screen, keyModel)
                Key("3√", screen, keyModel)
                Key("y√", screen, keyModel)
                Key(keyModel.secondActive ? "logy" : "ln", screen, keyModel)
                Key(keyModel.secondActive ? "log2" : "log10", screen, keyModel)
            }
            HStack(spacing: spacing) {
                Key("x!", screen, keyModel)
                Key(keyModel.secondActive ? "asin" : "sin", screen, keyModel)
                Key(keyModel.secondActive ? "acos" : "cos", screen, keyModel)
                Key(keyModel.secondActive ? "atan" : "tan", screen, keyModel)
                Key("e", screen, keyModel)
                Key("EE", screen, keyModel)
            }
            HStack(spacing: spacing) {
                Key(keyModel.rad ? "Deg" : "Rad", screen, keyModel)
                Key(keyModel.secondActive ? "asinh" : "sinh", screen, keyModel)
                Key(keyModel.secondActive ? "acosh" : "cosh", screen, keyModel)
                Key(keyModel.secondActive ? "atanh" : "tanh", screen, keyModel)
                Key("π", screen, keyModel)
                Key("Rand", screen, keyModel)
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

