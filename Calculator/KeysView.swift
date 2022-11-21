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
            Spacer(minLength: 100.0)
            HStack(spacing: 0.0) {
                if isScientific {
                    let space = KeyModel.spaceBetweenkeysFraction(withScientificKeys: true) * size.width
                    let keyWidth = (1.0 * size.width - 9.0 * space) / 10.0
                    let leftWidth = 6 * keyWidth + 5 * space
                    let rightWidth = 4 * keyWidth + 3 * space
                    let sizeLeft  = CGSize(width: leftWidth, height: size.height)
                    let sizeRight = CGSize(width: rightWidth, height: size.height)
                    ScientificKeys(keyModel: keyModel, spaceBetweenKeys: space, size: sizeLeft)
                    //                        .padding(.trailing, scientificTrailingPadding)
                        .padding(.trailing, space)
                    NonScientificKeys(keyModel: keyModel, spaceBetweenKeys: space, size: sizeRight)
                } else {
                    let space = KeyModel.spaceBetweenkeysFraction(withScientificKeys: false) * size.width
                    NonScientificKeys(keyModel: keyModel, spaceBetweenKeys: space, size: size)
                }
            }
        }
        .frame(width: size.width, height: size.height)
        .background(Color.black)
        .transition(.move(edge: .bottom))
        .padding(.bottom, bottomPadding)
    }
}

struct KeysView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            KeysView(keyModel: KeyModel(), bottomPadding: 100, isScientific: false, scientificTrailingPadding: 100, size: CGSize(width: 100, height: 100))
            KeysView(keyModel: KeyModel(), bottomPadding: 100, isScientific: false, scientificTrailingPadding: 100, size: CGSize(width: 400, height: 400))
        }
    }
}
