//
//  NonScientificKeys.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/20/22.
//

import SwiftUI

struct NonScientificKeyboard: View {
    @ObservedObject var model: Model
    let spaceBetweenKeys: CGFloat
    let keySize: CGSize
    
    var body: some View {
        VStack(spacing: spaceBetweenKeys) {
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: model.keyInfo[model.showAC ? "AC" : "C"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["±"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["%"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["/"]!, modelCallback: model.pressed, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: model.keyInfo["7"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["8"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["9"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["x"]!, modelCallback: model.pressed, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: model.keyInfo["4"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["5"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["6"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["-"]!, modelCallback: model.pressed, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: model.keyInfo["1"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["2"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["3"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["+"]!, modelCallback: model.pressed, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: model.keyInfo["0"]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo[","]!, modelCallback: model.pressed, size: keySize)
                Key(keyInfo: model.keyInfo["="]!, modelCallback: model.pressed, size: keySize)
            }
        }
    }
}

//struct NonScientificKeys_Previews: PreviewProvider {
//    static var previews: some View {
//        NonScientificKeys(model: Model(), spaceBetweenKeys: 10, size: CGSize(width: 250, height: 300))
//    }
//}

