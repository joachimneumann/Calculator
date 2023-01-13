//
//  ScreenModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/26/22.
//

import UIKit

class Screen: Equatable, ObservableObject {
    static func == (lhs: Screen, rhs: Screen) -> Bool {
        lhs.keySize == rhs.keySize
    }
    
    /// no @Published propertied, but objectWillChange.send() at the end of update()
    let isPad: Bool
    let isPortraitPhone: Bool
    let keyboardHeight: CGFloat
    let keySpacing: CGFloat
    let keySize: CGSize
    let lengths: Lengths
    let ePadding: CGFloat
    let plusIconSize: CGFloat
    let plusIconLeftPadding: CGFloat
    let uiFontSize: CGFloat
    let infoUiFont: UIFont
    let infoUiFontSize: CGFloat
    let portraitIPhoneDisplayHorizontalPadding: CGFloat
    let portraitIPhoneDisplayBottomPadding: CGFloat
    let horizontalPadding: CGFloat
    let bottomPadding: CGFloat
    let offsetToVerticallyAlignTextWithkeyboard: CGFloat
    let offsetToVerticallyIconWithText: CGFloat
    let kerning: CGFloat

    
    init(_ screenSize: CGSize) {
        // print("Screen INIT", screenSize)
        
        isPad = UIDevice.current.userInterfaceIdiom == .pad
        let isPortrait = screenSize.height > screenSize.width
        isPortraitPhone = isPad ? false : isPortrait

        if isPortraitPhone {
            keySpacing = 0.034 * screenSize.width
            horizontalPadding = keySpacing
        } else {
            // with scientific keyboard: narrower spacing
            keySpacing = 0.012 * screenSize.width
            horizontalPadding = 0.0
        }
        
        portraitIPhoneDisplayHorizontalPadding = screenSize.width * 0.035
        portraitIPhoneDisplayBottomPadding = screenSize.height * 0.012

        let calculatorWidth = screenSize.width - 2 * horizontalPadding
        let tempKeyWidth: CGFloat
        let tempKeyheight: CGFloat
        if isPortrait {
            /// Round keys
            tempKeyWidth = isPad ? (calculatorWidth - 9.0 * keySpacing) * 0.1 : (calculatorWidth - 3.0 * keySpacing) * 0.25
            tempKeyheight = tempKeyWidth
            keyboardHeight = 5 * tempKeyheight + 4 * keySpacing
            bottomPadding = isPad ? 0.0 : keyboardHeight * 0.09
        } else {
            /// wider keys
            tempKeyWidth = (calculatorWidth - 9.0 * keySpacing) * 0.1
            if isPad {
                /// landscape iPad: half of the screen is the keyboard
                keyboardHeight = isPortrait ? screenSize.height * 0.4 : screenSize.height * 0.5
            } else {
                /// iPhone landscape
                keyboardHeight = 0.8 * screenSize.height
            }
            tempKeyheight = (keyboardHeight - 4.0 * keySpacing) * 0.2
            bottomPadding = 0.0
        }

        keySize = CGSize(width: tempKeyWidth, height: tempKeyheight)
        
        plusIconSize = keyboardHeight * 0.13
        plusIconLeftPadding = plusIconSize * 0.4
        ePadding = isPortraitPhone ? plusIconSize * 0.1 : plusIconSize * 0.3
        let displayWidth = calculatorWidth -
        (isPortraitPhone ? 2.0 * portraitIPhoneDisplayHorizontalPadding : plusIconSize + plusIconLeftPadding)
        uiFontSize = ((isPortraitPhone ? 0.125 : 0.16) * keyboardHeight).rounded()
        let uiFont = UIFont.monospacedDigitSystemFont(ofSize: uiFontSize, weight: C.fontWeight)
        infoUiFontSize = uiFontSize * 0.3
        infoUiFont = UIFont.monospacedDigitSystemFont(ofSize: infoUiFontSize, weight: .regular)
        kerning = -0.02 * uiFontSize
        lengths = lengthMeasurement(width: displayWidth, uiFont: uiFont, infoUiFont: infoUiFont, ePadding: ePadding, kerning: kerning)
        
        offsetToVerticallyAlignTextWithkeyboard =
        CGFloat(screenSize.height) -
        CGFloat(keyboardHeight) -
        CGFloat(infoUiFontSize) -
        CGFloat(lengths.height)

        offsetToVerticallyIconWithText =
        CGFloat(screenSize.height) -
        CGFloat(keyboardHeight) -
        CGFloat(infoUiFontSize) -
        CGFloat(plusIconSize) +
        CGFloat(uiFont.descender) -
        CGFloat(0.5 * uiFont.capHeight) +
        CGFloat(0.5 * plusIconSize)
        objectWillChange.send()
    }
}
