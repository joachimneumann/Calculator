//
//  ScreenInfo.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/15/22.
//

import UIKit

struct ScreenInfo {
    let isPad: Bool
    let isPortraitPhone: Bool
    let calculatorSize: CGSize
    let keyboardHeight: CGFloat
    let keySize: CGSize
    let keySpacing: CGFloat
    let plusIconSize: CGFloat
    let plusIconLeftPadding: CGFloat
    let ePadding: CGFloat
    
    /// needed to correcty calculate the lengths in init()
    let uiFont: UIFont
    let uiFontLarge: UIFont
    let infoUiFont: UIFont
    let largeFontScaleFactor: CGFloat = 1.0 / 1.5
    let infoUiFontSize: CGFloat
    
    init(hardwareSize: CGSize, insets: UIEdgeInsets, appOrientation: UIDeviceOrientation) {
        print("ScreenInfo init() \(hardwareSize)")
        /// appOrientation is used here to trigger a redraw when the orientation changes ???????
        isPad = UIDevice.current.userInterfaceIdiom == .pad
        isPortraitPhone = isPad ? false : UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width

        calculatorSize = CGSize(width: hardwareSize.width - insets.left - insets.right, height: hardwareSize.height - insets.top - insets.bottom)

        let iPadPortrait = UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width

        if isPortraitPhone {
            keySpacing = 0.02 * calculatorSize.width
        } else {
            // with scientific keyboard: narrower spacing
            keySpacing = 0.012 * calculatorSize.width
        }

        let tempKeyWidth: CGFloat
        let tempKeyheight: CGFloat

        if isPortraitPhone || iPadPortrait {
            /// Round keys
            tempKeyWidth = isPad ? (calculatorSize.width - 9.0 * keySpacing) * 0.1 : (calculatorSize.width - 3.0 * keySpacing) * 0.25
            tempKeyheight = tempKeyWidth
            keyboardHeight = 5 * tempKeyheight + 4 * keySpacing
        } else {
            /// wider keys
            tempKeyWidth = (calculatorSize.width - 9.0 * keySpacing) * 0.1
            if isPad {
                /// landscape iPad: half of the screen is the keyboard
                keyboardHeight = iPadPortrait ? calculatorSize.height * 0.4 : calculatorSize.height * 0.5
            } else {
                /// iPhone landscape
                keyboardHeight = 0.8 * calculatorSize.height
            }
            tempKeyheight = (keyboardHeight - 4.0 * keySpacing) * 0.2
        }
        
        keySize = CGSize(width: tempKeyWidth, height: tempKeyheight)

        plusIconSize = keyboardHeight * 0.13
        plusIconLeftPadding = plusIconSize * 0.3
        ePadding = plusIconSize * 0.3
        let singleLineFontSize = ((isPortraitPhone ? 0.14 : 0.16) * keyboardHeight).rounded()
        uiFont = UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize, weight: C.fontWeight)
        infoUiFontSize = singleLineFontSize * 0.35
        infoUiFont = UIFont.monospacedDigitSystemFont(ofSize: infoUiFontSize, weight: .light)
        uiFontLarge = UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize / largeFontScaleFactor, weight: C.fontWeight)
        C.kerning = 0.0//-0.05 * singleLineFontSize
        // print("ScreenInfo: length = \(model.lengths)")
    }
}
