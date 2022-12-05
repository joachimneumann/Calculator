//
//  NonScientificKeys.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/20/22.
//

import SwiftUI

struct NonScientificKeys: View {
    @ObservedObject var model: Model
    let spaceBetweenKeys: CGFloat
    let size: CGSize
    
    var body: some View {
        let w = (size.width - 3.0 * spaceBetweenKeys) / 4.0
        let h = (size.height - 4.0 * spaceBetweenKeys) / 5.0
        let keySize = CGSize(width: w, height: h)
        let doubleKeySize = CGSize(width: 2.0 * w + spaceBetweenKeys, height: h)

        VStack(spacing: spaceBetweenKeys) {
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: model.keyInfo[model._AC ? "AC" : "C"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["±"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["%"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["/"]!, model: model, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: model.keyInfo["7"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["8"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["9"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["x"]!, model: model, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: model.keyInfo["4"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["5"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["6"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["-"]!, model: model, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: model.keyInfo["1"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["2"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["3"]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["+"]!, model: model, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key(keyInfo: model.keyInfo["0"]!, model: model, size: doubleKeySize)
                Key(keyInfo: model.keyInfo[","]!, model: model, size: keySize)
                Key(keyInfo: model.keyInfo["="]!, model: model, size: keySize)
            }
        }
    }
}

struct NonScientificKeys_Previews: PreviewProvider {
    static var previews: some View {
        NonScientificKeys(model: Model(), spaceBetweenKeys: 10, size: CGSize(width: 250, height: 300))
    }
}

