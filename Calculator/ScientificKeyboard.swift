//
//  ScientificKeyboard.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/21/22.
//

import SwiftUI

struct ScientificKeyboard: View {
    let screen: Screen
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        let spacing = screen.keySpacing
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                Key("( ", screen, viewModel)
                Key(" )", screen, viewModel)
                Key("mc", screen, viewModel)
                Key("m+", screen, viewModel)
                Key("m-", screen, viewModel)
                Key("mr", screen, viewModel)
            }
            HStack(spacing: spacing) {
                Key("2nd", screen, viewModel)
                Key("x^2", screen, viewModel)
                Key("x^3", screen, viewModel)
                Key("x^y", screen, viewModel)
                Key(viewModel.secondActive ? "y^x" : "e^x", screen, viewModel)
                Key(viewModel.secondActive ? "2^x" : "10^x", screen, viewModel)
            }
            HStack(spacing: spacing) {
                Key("One_x", screen, viewModel)
                Key("√", screen, viewModel)
                Key("3√", screen, viewModel)
                Key("y√", screen, viewModel)
                Key(viewModel.secondActive ? "logy" : "ln", screen, viewModel)
                Key(viewModel.secondActive ? "log2" : "log10", screen, viewModel)
            }
            HStack(spacing: spacing) {
                Key("x!", screen, viewModel)
                Key(viewModel.secondActive ? "asin" : "sin", screen, viewModel)
                Key(viewModel.secondActive ? "acos" : "cos", screen, viewModel)
                Key(viewModel.secondActive ? "atan" : "tan", screen, viewModel)
                Key("e", screen, viewModel)
                Key("EE", screen, viewModel)
            }
            HStack(spacing: spacing) {
                Key(viewModel.rad ? "Deg" : "Rad", screen, viewModel)
                Key(viewModel.secondActive ? "asinh" : "sinh", screen, viewModel)
                Key(viewModel.secondActive ? "acosh" : "cosh", screen, viewModel)
                Key(viewModel.secondActive ? "atanh" : "tanh", screen, viewModel)
                Key("π", screen, viewModel)
                Key("Rand", screen, viewModel)
            }
        }
    }
}

//struct ScientificKeys_Previews: PreviewProvider {
//    static var previews: some View {
//        ScientificBoard(model: Model(), spacing: 10, keySize: CGSize(width: 400, height: 300))
//    }
//}

