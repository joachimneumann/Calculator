//
//  ScreenModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/26/22.
//

import UIKit

class ScreenModel: ObservableObject {
    let isPad: Bool
    let isPortraitPhone: Bool
    let keyboardHeight: CGFloat
    let keySpacing: CGFloat
    let keySize: CGSize
    func updateSize(_ newSize: CGSize) {
        print("ScreenModel updateSize", newSize)
    }
    init(_ screenSize: CGSize) {
        print("ScreenModel INIT")

        isPad = UIDevice.current.userInterfaceIdiom == .pad
        let isPortrait = screenSize.height > screenSize.width
        isPortraitPhone = isPad ? false : isPortrait
        if isPortraitPhone {
            keySpacing = 0.034 * screenSize.width
        } else {
            // with scientific keyboard: narrower spacing
            keySpacing = 0.012 * screenSize.width
        }
        let tempKeyWidth: CGFloat
        let tempKeyheight: CGFloat

        if isPortrait {
            /// Round keys
            tempKeyWidth = isPad ? (screenSize.width - 9.0 * keySpacing) * 0.1 : (screenSize.width - 3.0 * keySpacing) * 0.25
            tempKeyheight = tempKeyWidth
            keyboardHeight = 5 * tempKeyheight + 4 * keySpacing
        } else {
            /// wider keys
            tempKeyWidth = (screenSize.width - 9.0 * keySpacing) * 0.1
            if isPad {
                /// landscape iPad: half of the screen is the keyboard
                keyboardHeight = isPortrait ? screenSize.height * 0.4 : screenSize.height * 0.5
            } else {
                /// iPhone landscape
                keyboardHeight = 0.8 * screenSize.height
            }
            tempKeyheight = (keyboardHeight - 4.0 * keySpacing) * 0.2
        }
        
        keySize = CGSize(width: tempKeyWidth, height: tempKeyheight)

    }
}
