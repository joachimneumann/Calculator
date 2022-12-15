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
    let keySize: CGSize
    let spacing: CGFloat
    
    var body: some View {
        if isScientific {
            HStack(spacing: 0.0) {
                ScientificBoard(model: model, spacing: spacing, keySize: keySize)
                    .padding(.trailing, spacing)
//                    .background(Color.black)
                NonScientificKeyboard(model: model, spacing: spacing, keySize: keySize)
//                    .background(Color.black)
            }
            .background(testColors ? Color.cyan : Color.clear)
        } else {
            NonScientificKeyboard(model: model, spacing: spacing, keySize: keySize)
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
