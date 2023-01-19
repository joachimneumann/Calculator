//
//  NonScientificKeys.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/20/22.
//

import SwiftUI

struct NonScientificKeyboard: View {
    let screen: Screen
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        let spacing = screen.keySpacing
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                Key(viewModel.showAC ? "AC" : "C", screen, viewModel)
                Key("±", screen, viewModel)
                Key("%", screen, viewModel)
                Key("/", screen, viewModel)
            }
            HStack(spacing: spacing) {
                Key("7", screen, viewModel)
                Key("8", screen, viewModel)
                Key("9", screen, viewModel)
                Key("x", screen, viewModel)
            }
            HStack(spacing: spacing) {
                Key("4", screen, viewModel)
                Key("5", screen, viewModel)
                Key("6", screen, viewModel)
                Key("-", screen, viewModel)
            }
            HStack(spacing: spacing) {
                Key("1", screen, viewModel)
                Key("2", screen, viewModel)
                Key("3", screen, viewModel)
                Key("+", screen, viewModel)
            }
            HStack(spacing: spacing) {
                Key("0", screen, viewModel)
                Key(screen.decimalSeparator.string, screen, viewModel)
                Key("=", screen, viewModel)
            }
        }
    }
}

//struct NonScientificKeys_Previews: PreviewProvider {
//    static var previews: some View {
//        NonScientificKeys(model: Model(), spaceBetweenKeys: 10, size: CGSize(width: 250, height: 300))
//    }
//}

