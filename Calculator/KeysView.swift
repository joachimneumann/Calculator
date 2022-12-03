//
//  KeysView.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct KeysView: View {
    let keyModel : KeyModel
    let isScientific: Bool
    let size: CGSize
    
    var body: some View {
        if isScientific {
            HStack(spacing: 0.0) {
                let space = C.spaceBetweenkeysFraction(withScientificKeys: true) * size.width
                let keyWidth = (1.0 * size.width - 9.0 * space) / 10.0
                let leftWidth = 6 * keyWidth + 5 * space
                let rightWidth = 4 * keyWidth + 3 * space
                let sizeLeft  = CGSize(width: leftWidth, height: size.height)
                let sizeRight = CGSize(width: rightWidth, height: size.height)
                ScientificKeys(keyModel: keyModel, spaceBetweenKeys: space, size: sizeLeft)
                    .padding(.trailing, space)
                    .background(Color.black)
                NonScientificKeys(keyModel: keyModel, spaceBetweenKeys: space, size: sizeRight)
                    .background(Color.black)
            }
        } else {
            let space = C.spaceBetweenkeysFraction(withScientificKeys: false) * size.width
            NonScientificKeys(keyModel: keyModel, spaceBetweenKeys: space, size: size)
                .background(Color.black)
        }
    }
}

struct KeysView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            KeysView(keyModel: KeyModel(), isScientific: false, size: CGSize(width: 100, height: 100))
            KeysView(keyModel: KeyModel(), isScientific: false, size: CGSize(width: 400, height: 400))
        }
    }
}
