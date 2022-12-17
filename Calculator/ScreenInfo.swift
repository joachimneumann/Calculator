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
    let offsetToVerticallyAlignTextWithkeyboard: CGFloat
    let offsetToVerticallyIconWithText: CGFloat
    
    /// needed to correcty calculate the lengths in init()
    let uiFont: UIFont
    let uiFontLarge: UIFont
    let infoUiFont: UIFont
    let largeFontScaleFactor: CGFloat = 1.0 / 1.5

    init(hardwareSize: CGSize, insets: UIEdgeInsets, appOrientation: UIDeviceOrientation, model: Model) {
        // print("XX ScreenInfo init() \(hardwareSize)")
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
                keyboardHeight = 0.84 * calculatorSize.height
            }
            tempKeyheight = (keyboardHeight - 4.0 * keySpacing) * 0.2
        }
        
        keySize = CGSize(width: tempKeyWidth, height: tempKeyheight)

        plusIconSize = keyboardHeight * 0.0513
        plusIconLeftPadding = plusIconSize * 0.3
        ePadding = plusIconLeftPadding
        let singleLineFontSize = ((isPortraitPhone ? 0.14 : 0.16) * keyboardHeight).rounded()
        uiFont = UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize, weight: C.fontWeight)
        infoUiFont = UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize * 0.35, weight: C.fontWeight)
        uiFontLarge = UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize / largeFontScaleFactor, weight: C.fontWeight)
        C.kerning = 0.0//-0.05 * singleLineFontSize

        let displayWidth = calculatorSize.width// - plusIconSize - plusIconLeftPadding
        
        let temp = lengthMeasurement(width: displayWidth, uiFont: uiFont, ePadding: ePadding)
        model.lengths = temp
        // lengths is used in Model.haveResultCallback()

        offsetToVerticallyAlignTextWithkeyboard = calculatorSize.height - keyboardHeight - model.lengths.height
        offsetToVerticallyIconWithText = calculatorSize.height - keyboardHeight - plusIconSize + uiFont.descender - 0.5 * uiFont.capHeight + plusIconSize * 0.5

        // print("ScreenInfo: length = \(model.lengths)")
    }
}
