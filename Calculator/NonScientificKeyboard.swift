//
//  NonScientificKeys.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/20/22.
//

import SwiftUI

struct NonScientificKeyboard: View {
    @ObservedObject var keyModel: KeyModel
    let spacing: CGFloat
    let keySize: CGSize
    
    var body: some View {
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                Key(keyModel.showAC ? "AC" : "C", keyModel)
                Key("±", keyModel)
                Key("%", keyModel)
                Key("/", keyModel)
            }
            HStack(spacing: spacing) {
                Key("7", keyModel)
                Key("8", keyModel)
                Key("9", keyModel)
                Key("x", keyModel)
            }
            HStack(spacing: spacing) {
                Key("4", keyModel)
                Key("5", keyModel)
                Key("6", keyModel)
                Key("-", keyModel)
            }
            HStack(spacing: spacing) {
                Key("1", keyModel)
                Key("2", keyModel)
                Key("3", keyModel)
                Key("+", keyModel)
            }
            HStack(spacing: spacing) {
                Key("0", keyModel, doubleWidth: 2.0 * keySize.width + spacing)
                Key(",", keyModel)
                Key("=", keyModel)
            }
        }
    }
}

//struct NonScientificKeys_Previews: PreviewProvider {
//    static var previews: some View {
//        NonScientificKeys(model: Model(), spaceBetweenKeys: 10, size: CGSize(width: 250, height: 300))
//    }
//}

