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
        let keySize = screen.keySize
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                Key(screen, keyModel.showAC ? "AC" : "C", keyModel)
                Key(screen, "±", keyModel)
                Key(screen, "%", keyModel)
                Key(screen, "/", keyModel)
            }
            HStack(spacing: spacing) {
                Key(screen, "7", keyModel)
                Key(screen, "8", keyModel)
                Key(screen, "9", keyModel)
                Key(screen, "x", keyModel)
            }
            HStack(spacing: spacing) {
                Key(screen, "4", keyModel)
                Key(screen, "5", keyModel)
                Key(screen, "6", keyModel)
                Key(screen, "-", keyModel)
            }
            HStack(spacing: spacing) {
                Key(screen, "1", keyModel)
                Key(screen, "2", keyModel)
                Key(screen, "3", keyModel)
                Key(screen, "+", keyModel)
            }
            HStack(spacing: spacing) {
                Key(screen, "0", keyModel, doubleWidth: 2.0 * keySize.width + spacing)
                Key(screen, ",", keyModel)
                Key(screen, "=", keyModel)
            }
        }
    }
}

//struct NonScientificKeys_Previews: PreviewProvider {
//    static var previews: some View {
//        NonScientificKeys(model: Model(), spaceBetweenKeys: 10, size: CGSize(width: 250, height: 300))
//    }
//}

