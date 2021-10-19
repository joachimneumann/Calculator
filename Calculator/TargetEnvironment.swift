//
//  TE.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

class TE {
    static let iPhoneScientificFontSizeReduction: CGFloat = 0.8
    static let digitsInAllDigitsDisplay: Int = 200
    static let numberPadFration: CGFloat = 0.4

#if targetEnvironment(macCatalyst)
    /// The MacOS Calculator is a bit transparent.
    /// The colors specified here are the button colors
    /// when the MacOS Calcuator is on a black background.
    /// To make this appeasily  distinguashable from the
    /// Apple MacOS Calculator, the 5 rightmost buttons
    /// are in a blue tint instead of Apple's orange.
    static let appBackgroundColor = Color(
        red:    46.0/255.0,
        green:  39.0/255.0,
        blue:   38.0/255.0)

    static let DigitKeyProperties = KeyProperties(
        textColor: Color(
            red:   231.0/255.0,
            green: 231.0/255.0,
            blue:  231.0/255.0),
        bgColor: Color(
            red:   98.0/255.0,
            green: 94.0/255.0,
            blue:  92.0/255.0),
        downColor: Color(
            red:   160.0/255.0,
            green: 159.0/255.0,
            blue:  158.0/255.0),
        downAnimationTime: 0.1,
        upAnimationTime: 0.5)


    static let OpKeyProperties = KeyProperties(
        textColor: Color(
            red:   236.0/255.0,
            green: 235.0/255.0,
            blue:  235.0/255.0),
        bgColor: Color(
            red:   105.0/255.0,
            green: 183.0/255.0,
            blue:  191.0/255.0),
        downColor: Color(
            red:   203.0/255.0,
            green: 230.0/255.0,
            blue:  232.0/255.0),
        downAnimationTime: 0.1,
        upAnimationTime: 0.3)

    static let LightGrayKeyProperties = KeyProperties(
        textColor: Color(
            red:   236.0/255.0,
            green: 235.0/255.0,
            blue:  235.0/255.0),
        bgColor: Color(
            red:    66.0/255.0,
            green:  62.0/255.0,
            blue:   59.0/255.0),
        downColor: Color(
            red:   124.0/255.0,
            green: 125.0/255.0,
            blue:  127.0/255.0),
        downAnimationTime: 0.1,
        upAnimationTime: 0.5)


    static let zoomIconSize: CGFloat = 30.0
    static let macWindowWidth: CGFloat = 9.0*TE.kw+TE.wkw+9.0*TE.sp
    static let macWindowHeight: CGFloat = 419.5
    static let reducedTrailing: CGFloat = 12.0
    static let additionalBottomSpacing: CGFloat = 7.0

    static private let kh  = 63.0  // key height
    static private let kw  = 72.75 // key width
    static private let wkw = 77.0  // wider with for +-*/= keys
    static private let sp  = 1.5   // space between keys
    static private let numberPadWidth = 5.0 * TE.kw + 4.0 * TE.sp
    
    let digitsInSmallDisplay: Int = 16
    let isLandscape: Bool = true
    let spaceBetweenkeys: CGFloat = TE.sp
    let displayFont: Font = Font.system(size: TE.numberPadWidth * 0.148, weight: .thin).monospacedDigit()
    let keySize: CGSize       = CGSize(width: TE.kw,  height: TE.kh)
    let widerKeySize: CGSize  = CGSize(width: TE.wkw, height: TE.kh)
    let scientificKeySize: CGSize   = CGSize(width: TE.kw,  height: TE.kh)
    let allkeysHeight: CGFloat = 5.0 * TE.kh + 4.0 * TE.sp
    let remainingAboveKeys: CGFloat = TE.macWindowHeight - (5.0 * TE.kh + 4.0 * TE.sp)
    let isPad: Bool = false
    // no init needed
#else
    ///
    /// iOS
    ///
    
    static let appBackgroundColor = Color(.black)

    static let DigitKeyProperties = KeyProperties(
        textColor: Color.white,
        bgColor: Color(
            red:    51.0/255.0,
            green:  51.0/255.0,
            blue:   51.0/255.0),
        downColor: Color(
            red:   115.0/255.0,
            green: 115.0/255.0,
            blue:  115.0/255.0),
        downAnimationTime: 0.1,
        upAnimationTime: 0.5)


    static let OpKeyProperties = KeyProperties(
        textColor: Color.white,
        bgColor: Color(
            red:   105.0/255.0,
            green: 183.0/255.0,
            blue:  191.0/255.0),
        downColor: Color(
            red:   203.0/255.0,
            green: 230.0/255.0,
            blue:  232.0/255.0),
        downAnimationTime: 0.1,
        upAnimationTime: 0.3)

    static let LightGrayKeyProperties = KeyProperties(
        textColor: Color.black,
        bgColor: Color(
            red:   165.0/255.0,
            green: 165.0/255.0,
            blue:  165.0/255.0),
        downColor: Color(
            red:   216.0/255.0,
            green: 216.0/255.0,
            blue:  216.0/255.0),
        downAnimationTime: 0.1,
        upAnimationTime: 0.5)

    static let zoomIconSize: CGFloat = 30.0
    static let portraitSpacingFration: CGFloat = 0.03
    static let landscapeSpacingFration: CGFloat = 0.01
    static let reducedTrailing: CGFloat = 0.0
    static let additionalBottomSpacing: CGFloat = 0.0

    var displayFontSize: CGFloat = 0.0
    var displayFont: Font = Font.system(size: 10, weight: .thin).monospacedDigit()
    var isLandscape: Bool = false
    var spaceBetweenkeys: CGFloat = 0.0
    var keySize: CGSize = CGSize(width: 0.0, height: 0.0)
    var widerKeySize: CGSize = CGSize(width: 0.0, height: 0.0)
    var allkeysHeight: CGFloat { 5.0 * keySize.height + 4.0 * spaceBetweenkeys }
    var remainingAboveKeys: CGFloat = 0.0
    var digitsInSmallDisplay: Int = 3
    var isPad: Bool = false
    init(appFrame: CGSize, isPad: Bool) {
        self.isPad = isPad
        if isPad {
            isLandscape = true
        } else {
            isLandscape = appFrame.width > appFrame.height
        }
        
        if isLandscape {
            spaceBetweenkeys = appFrame.width * Self.landscapeSpacingFration
            let w = (appFrame.width - 9.0 * spaceBetweenkeys) * 0.1

            // I need space for the display
            let squareKeysHeight = 5.0 * w + 4.0 * spaceBetweenkeys
            let factor:CGFloat = min(1.0, appFrame.height * 0.8 / squareKeysHeight)
            keySize = CGSize(width: w, height: w * factor)
            digitsInSmallDisplay = 16
        } else {
            /// portrait
            spaceBetweenkeys = appFrame.width * Self.portraitSpacingFration
            let w = (appFrame.width - 3.0 * spaceBetweenkeys) * 0.25
            keySize = CGSize(width: w, height: w)
            digitsInSmallDisplay = 9
        }
        displayFontSize = keySize.height
        displayFont = Font.system(size: displayFontSize, weight: .thin).monospacedDigit()
        widerKeySize = keySize
        remainingAboveKeys = appFrame.height - allkeysHeight
    }

#endif


    struct ButtonShape: View {
        var body: some View {
            #if targetEnvironment(macCatalyst)
                Rectangle()
            #else
                Capsule()
            #endif
        }
    }
        
}
