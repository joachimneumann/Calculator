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
        let keySize = screen.keySize
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                Key(screen, "( ", keyModel)
                Key(screen, " )", keyModel)
                Key(screen, "mc", keyModel)
                Key(screen, "m+", keyModel)
                Key(screen, "m-", keyModel)
                Key(screen, "mr", keyModel)
            }
            HStack(spacing: spacing) {
                Key(screen, "2nd", keyModel)
                Key(screen, "x^2", keyModel)
                Key(screen, "x^3", keyModel)
                Key(screen, "x^y", keyModel)
                Key(screen, keyModel.secondActive ? "y^x" : "e^x", keyModel)
                Key(screen, keyModel.secondActive ? "2^x" : "10^x", keyModel)
            }
            HStack(spacing: spacing) {
                Key(screen, "One_x", keyModel)
                Key(screen, "√", keyModel)
                Key(screen, "3√", keyModel)
                Key(screen, "y√", keyModel)
                Key(screen, keyModel.secondActive ? "logy" : "ln", keyModel)
                Key(screen, keyModel.secondActive ? "log2" : "log10", keyModel)
            }
            HStack(spacing: spacing) {
                Key(screen, "x!", keyModel)
                Key(screen, keyModel.secondActive ? "asin" : "sin", keyModel)
                Key(screen, keyModel.secondActive ? "acos" : "cos", keyModel)
                Key(screen, keyModel.secondActive ? "atan" : "tan", keyModel)
                Key(screen, "e", keyModel)
                Key(screen, "EE", keyModel)
            }
            HStack(spacing: spacing) {
                Key(screen, keyModel.rad ? "Deg" : "Rad", keyModel)
                Key(screen, keyModel.secondActive ? "asinh" : "sinh", keyModel)
                Key(screen, keyModel.secondActive ? "acosh" : "cosh", keyModel)
                Key(screen, keyModel.secondActive ? "atanh" : "tanh", keyModel)
                Key(screen, "π", keyModel)
                Key(screen, "Rand", keyModel)
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

