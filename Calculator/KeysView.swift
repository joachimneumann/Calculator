//
//  KeysView.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct KeysView: View {
    let model : Model
    let isScientific: Bool
    let size: CGSize
//    let spaceBetweenKeys: CGFloat
    
    var body: some View {
        if isScientific {
            HStack(spacing: 0.0) {
                let keyPadding = C.spaceBetweenkeysFraction(withScientificKeys: true) * size.width
                let keyWidth = (size.width - 9.0 * keyPadding) / 10.0
                let keyHeight = (size.height - 4.0 * keyPadding) / 5.0
                let keySize = CGSize(width: keyWidth, height: keyHeight)
//                let leftWidth = 6 * keyWidth + 5 * space
//                let rightWidth = 4 * keyWidth + 3 * space
//                let sizeLeft  = CGSize(width: leftWidth, height: size.height)
//                let sizeRight = CGSize(width: rightWidth, height: size.height)
//                var w = (sizeLeft.width - 5.0 * spaceBetweenKeys) / 6.0
//                var h = (sizeLeft.height - 4.0 * spaceBetweenKeys) / 5.0
//                var keySize = CGSize(width: w, height: h)
                ScientificKeys(model: model, spaceBetweenKeys: keyPadding, keySize: keySize)
                    .padding(.trailing, keyPadding)
//                    .background(Color.black)
//                let _ = w = (sizeRight.width - 3.0 * spaceBetweenKeys) / 4.0
//                let _ = h = (sizeRight.height - 4.0 * spaceBetweenKeys) / 5.0
//                let _ = keySize = CGSize(width: w, height: h)
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
