//
//  KeysView.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct KeysView: View {
    let keyModel: KeyModel
    let bottomPadding: CGFloat
    let isScientific: Bool
    let scientificTrailingPadding: CGFloat
    let size: CGSize
//    if !t.isPad && t.isPortrait {
//        bottomPadding = t.allkeysHeight * 0.07
//    } else {
//        bottomPadding = 0
//    }

    var body: some View {
        VStack(spacing: 0.0) {
            Spacer(minLength: 0.0)
            HStack(spacing: 0.0) {
                if isScientific {
                    ScientificKeys(keyModel: keyModel, spaceBetweenKeys: KeyModel.spaceBetweenkeysFraction(withScientificKeys: true) * size.width, size: size)
//                        .padding(.trailing, scientificTrailingPadding)
                } else {
                    NonScientificKeys(keyModel: keyModel, spaceBetweenKeys: KeyModel.spaceBetweenkeysFraction(withScientificKeys: false) * size.width, size: size)
                }
            }
        }
        .frame(width: size.width, height: size.height)
        .background(Color.black)
        .transition(.move(edge: .bottom))
        .padding(.bottom, bottomPadding)
    }
}

struct Keys_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            KeysView(keyModel: KeyModel(), bottomPadding: 100, isScientific: false, scientificTrailingPadding: 100, size: CGSize(width: 100, height: 100))
            KeysView(keyModel: KeyModel(), bottomPadding: 100, isScientific: false, scientificTrailingPadding: 100, size: CGSize(width: 400, height: 400))
        }
    }
}
