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
                Key(screen, "( ", keyModel, keySize)
                Key(screen, " )", keyModel, keySize)
                Key(screen, "mc", keyModel, keySize)
                Key(screen, "m+", keyModel, keySize)
                Key(screen, "m-", keyModel, keySize)
                Key(screen, "mr", keyModel, keySize)
            }
            HStack(spacing: spacing) {
                Key(screen, "2nd", keyModel, keySize)
                Key(screen, "x^2", keyModel, keySize)
                Key(screen, "x^3", keyModel, keySize)
                Key(screen, "x^y", keyModel, keySize)
                Key(screen, keyModel.secondActive ? "y^x" : "e^x", keyModel, keySize)
                Key(screen, keyModel.secondActive ? "2^x" : "10^x", keyModel, keySize)
            }
            HStack(spacing: spacing) {
                Key(screen, "One_x", keyModel, keySize)
                Key(screen, "√", keyModel, keySize)
                Key(screen, "3√", keyModel, keySize)
                Key(screen, "y√", keyModel, keySize)
                Key(screen, keyModel.secondActive ? "logy" : "ln", keyModel, keySize)
                Key(screen, keyModel.secondActive ? "log2" : "log10", keyModel, keySize)
            }
            HStack(spacing: spacing) {
                Key(screen, "x!", keyModel, keySize)
                Key(screen, keyModel.secondActive ? "asin" : "sin", keyModel, keySize)
                Key(screen, keyModel.secondActive ? "acos" : "cos", keyModel, keySize)
                Key(screen, keyModel.secondActive ? "atan" : "tan", keyModel, keySize)
                Key(screen, "e", keyModel, keySize)
                Key(screen, "EE", keyModel, keySize)
            }
            HStack(spacing: spacing) {
                Key(screen, keyModel.rad ? "Deg" : "Rad", keyModel, keySize)
                Key(screen, keyModel.secondActive ? "asinh" : "sinh", keyModel, keySize)
                Key(screen, keyModel.secondActive ? "acosh" : "cosh", keyModel, keySize)
                Key(screen, keyModel.secondActive ? "atanh" : "tanh", keyModel, keySize)
                Key(screen, "π", keyModel, keySize)
                Key(screen, "Rand", keyModel, keySize)
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

