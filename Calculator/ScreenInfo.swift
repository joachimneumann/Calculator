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
    let uiFontSize: CGFloat
    let infoUiFont: UIFont
    let largeFontScaleFactor: CGFloat = 1.0 / 1.5
    let infoUiFontSize: CGFloat
    let portraitIPhoneBottomPadding: CGFloat
    let portraitIPhoneHorizontalPadding: CGFloat
    let portraitIPhoneDisplayHorizontalPadding: CGFloat
    let portraitIPhoneDisplayBottomPadding: CGFloat
    let displayWidth: CGFloat

    init(hardwareSize: CGSize, insets: UIEdgeInsets, appOrientation: UIDeviceOrientation) {
        // print("ScreenInfo init() \(hardwareSize)")
        /// appOrientation is used here to trigger a redraw when the orientation changes ???????
        isPad = UIDevice.current.userInterfaceIdiom == .pad
        isPortraitPhone = isPad ? false : UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width
        //print("ScreenInfo isPortraitPhone \(isPortraitPhone)")

        portraitIPhoneDisplayHorizontalPadding = hardwareSize.width * 0.035
        portraitIPhoneDisplayBottomPadding = hardwareSize.height * 0.012
        portraitIPhoneBottomPadding = hardwareSize.height * 0.044
        portraitIPhoneHorizontalPadding = hardwareSize.width * 0.08

        calculatorSize = CGSize(
            width:  hardwareSize.width  - insets.left - insets.right  - (isPortraitPhone ? portraitIPhoneHorizontalPadding : 0.0),
            height: hardwareSize.height - insets.top  - insets.bottom - (isPortraitPhone ? portraitIPhoneBottomPadding : 0.0))

        let iPadPortrait = UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width

        if isPortraitPhone {
            keySpacing = 0.034 * calculatorSize.width
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
        plusIconLeftPadding = plusIconSize * 0.4
        ePadding = isPortraitPhone ? plusIconSize * 0.1 : plusIconSize * 0.3

        displayWidth = calculatorSize.width - (isPortraitPhone ?
            portraitIPhoneHorizontalPadding :
            plusIconSize + plusIconLeftPadding)

        uiFontSize = ((isPortraitPhone ? 0.125 : 0.16) * keyboardHeight).rounded()
        uiFont = UIFont.monospacedDigitSystemFont(ofSize: uiFontSize, weight: C.fontWeight)
        infoUiFontSize = uiFontSize * 0.3
        infoUiFont = UIFont.monospacedDigitSystemFont(ofSize: infoUiFontSize, weight: .regular)
        C.kerning = 0.0//-0.05 * singleLineFontSize
    }
}
