//
//  NonScientificKeys.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/20/22.
//

import SwiftUI

struct NonScientificKeyboard: View {
    let screen: Screen
    @ObservedObject var keyModel: KeyModel
    
    var body: some View {
        let spacing = screen.keySpacing
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                Key(keyModel.showAC ? "AC" : "C", screen, keyModel)
                Key("±", screen, keyModel)
                Key("%", screen, keyModel)
                Key("/", screen, keyModel)
            }
            HStack(spacing: spacing) {
                Key("7", screen, keyModel)
                Key("8", screen, keyModel)
                Key("9", screen, keyModel)
                Key("x", screen, keyModel)
            }
            HStack(spacing: spacing) {
                Key("4", screen, keyModel)
                Key("5", screen, keyModel)
                Key("6", screen, keyModel)
                Key("-", screen, keyModel)
            }
            HStack(spacing: spacing) {
                Key("1", screen, keyModel)
                Key("2", screen, keyModel)
                Key("3", screen, keyModel)
                Key("+", screen, keyModel)
            }
            HStack(spacing: spacing) {
                Key("0", screen, keyModel)
                Key(",", screen, keyModel)
                Key("=", screen, keyModel)
            }
        }
    }
}

//struct NonScientificKeys_Previews: PreviewProvider {
//    static var previews: some View {
//        NonScientificKeys(model: Model(), spaceBetweenKeys: 10, size: CGSize(width: 250, height: 300))
//    }
//}

