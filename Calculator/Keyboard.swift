//
//  KeysView.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct Keyboard: View {
    let model : Model
    let isScientific: Bool
    let keyboardSize: CGSize
    
    var body: some View {
        if isScientific {
            HStack(spacing: 0.0) {
                let spacing = C.spacingFraction(withScientificKeys: true) * keyboardSize.width
                let keyWidth = (keyboardSize.width - 9.0 * spacing) / 10.0
                let keyHeight = (keyboardSize.height - 4.0 * spacing) / 5.0
                let keySize = CGSize(width: keyWidth, height: keyHeight)
                ScientificBoard(model: model, spacing: spacing, keySize: keySize)
                    .padding(.trailing, spacing)
//                    .background(Color.black)
                NonScientificKeyboard(model: model, spacing: spacing, keySize: keySize)
//                    .background(Color.black)
            }
            .background(testColors ? Color.cyan : Color.clear)
        } else {
            let keyPadding = C.spacingFraction(withScientificKeys: false) * keyboardSize.width
            let keyWidth = (keyboardSize.width - 3.0 * keyPadding) / 4.0
            let keyHeight = (keyboardSize.height - 4.0 * keyPadding) / 5.0
            let keySize = CGSize(width: keyWidth, height: keyHeight)
            NonScientificKeyboard(model: model, spacing: keyPadding, keySize: keySize)
                .background(testColors ? Color.cyan : Color.clear)
        }
    }
}

struct KeysView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
//            KeysView(model: Model(), isScientific: false, size: CGSize(width: 100, height: 100))
//            KeysView(model: Model(), isScientific: false, size: CGSize(width: 400, height: 400))
        }
    }
}
