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
    let size: CGSize
    
    var body: some View {
        if isScientific {
            HStack(spacing: 0.0) {
                let keyPadding = C.spaceBetweenkeysFraction(withScientificKeys: true) * size.width
                let keyWidth = (size.width - 9.0 * keyPadding) / 10.0
                let keyHeight = (size.height - 4.0 * keyPadding) / 5.0
                let keySize = CGSize(width: keyWidth, height: keyHeight)
                ScientificKeys(model: model, spaceBetweenKeys: keyPadding, keySize: keySize)
                    .padding(.trailing, keyPadding)
//                    .background(Color.black)
                NonScientificKeys(model: model, spaceBetweenKeys: keyPadding, keySize: keySize)
//                    .background(Color.black)
            }
            .background(testColors ? Color.cyan : Color.clear)
        } else {
            let keyPadding = C.spaceBetweenkeysFraction(withScientificKeys: false) * size.width
            let keyWidth = (size.width - 3.0 * keyPadding) / 4.0
            let keyHeight = (size.height - 4.0 * keyPadding) / 5.0
            let keySize = CGSize(width: keyWidth, height: keyHeight)
            NonScientificKeys(model: model, spaceBetweenKeys: keyPadding, keySize: keySize)
                .background(Color.cyan)
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
