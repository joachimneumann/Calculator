//
//  TE.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

struct KeyProperties {
    let size: CGSize
    let font: Font
    let textColor: Color
    let disabledColor: Color
    let bgColor: Color
    let downBgColor: Color
    let downAnimationTime: Double
    let upAnimationTime: Double
}

class TE {
    static let iPhoneScientificFontSizeReduction: CGFloat = 0.85//1.0
    static let digitsInAllDigitsDisplay: Int = 200
    
    static let lowPrecision          = 100
    static let lowPrecisionString    = "one hundred digits"
    static let mediumPrecision       = 10000
    static let mediumPrecisionString = "ten thousand digits"
    static let highPrecision         = 1000000
    static let highPrecisionString   = "one million digits"


#if targetEnvironment(macCatalyst)
    /// The MacOS Calculator is a bit transparent.
    /// The colors specified here are the button colors
    /// when the MacOS Calcuator is on a black background.
    /// To make this app easily  distinguashable from the
    /// Apple MacOS Calculator, the 5 rightmost buttons
    /// have a blue tint instead of Apple's orange.
    static let appBackgroundColor = Color(
        red:    46.0/255.0,
        green:  39.0/255.0,
        blue:   38.0/255.0)

    let digits_1_9 = KeyProperties(
        size: CGSize(width: TE.kw,  height: TE.kh),
        font: Font.system(size: TE.kh * 0.45).monospacedDigit(),
        textColor: Color(
            red:   231.0/255.0,
            green: 231.0/255.0,
            blue:  231.0/255.0),
        disabledColor: Color(
            red:   231.0/255.0,
            green: 231.0/255.0,
            blue:  231.0/255.0),
        bgColor: Color(
            red:   98.0/255.0,
            green: 94.0/255.0,
            blue:  92.0/255.0),
        downBgColor: Color(
            red:   160.0/255.0,
            green: 159.0/255.0,
            blue:  158.0/255.0),
        downAnimationTime: 0.1,
        upAnimationTime: 0.5)
    
    let digits_0 = KeyProperties(
        size: CGSize(width: 2.0 * TE.kw + TE.sp,  height: TE.kh),
        font: Font.system(size: TE.kh * 0.45).monospacedDigit(),
        textColor: Color(
            red:   231.0/255.0,
            green: 231.0/255.0,
            blue:  231.0/255.0),
        disabledColor: Color(
            red:   231.0/255.0,
            green: 231.0/255.0,
            blue:  231.0/255.0),
        bgColor: Color(
            red:   98.0/255.0,
            green: 94.0/255.0,
            blue:  92.0/255.0),
        downBgColor: Color(
            red:   160.0/255.0,
            green: 159.0/255.0,
            blue:  158.0/255.0),
        downAnimationTime: 0.1,
        upAnimationTime: 0.5)


    let colorOpProperties = KeyProperties(
        size: CGSize(width: TE.wkw,  height: TE.kh),
        font: Font.system(size: TE.kh * 0.36, weight: .bold).monospacedDigit(),
        textColor: Color(
            red:   236.0/255.0,
            green: 235.0/255.0,
            blue:  235.0/255.0),
        disabledColor: Color(
            red:   236.0/255.0,
            green: 235.0/255.0,
            blue:  235.0/255.0),
        bgColor: Color(
            red:   105.0/255.0,
            green: 183.0/255.0,
            blue:  191.0/255.0),
        downBgColor: Color(
            red:   203.0/255.0,
            green: 230.0/255.0,
            blue:  232.0/255.0),
        downAnimationTime: 0.1,
        upAnimationTime: 0.3)

    let ac_plus_minus_percentProperties = KeyProperties(
        size: CGSize(width: TE.kw,  height: TE.kh),
        font: Font.system(size: TE.kh * 0.36).monospacedDigit(),
        textColor: Color(
            red:   236.0/255.0,
            green: 235.0/255.0,
            blue:  235.0/255.0),
        disabledColor: Color(
            red:   236.0/255.0,
            green: 235.0/255.0,
            blue:  235.0/255.0),
        bgColor: Color(
            red:    66.0/255.0,
            green:  62.0/255.0,
            blue:   59.0/255.0),
        downBgColor: Color(
            red:   124.0/255.0,
            green: 125.0/255.0,
            blue:  127.0/255.0),
        downAnimationTime: 0.1,
        upAnimationTime: 0.5)

    let scientificProperties = KeyProperties(
        size: CGSize(width: TE.kw,  height: TE.kh),
        font: Font.system(size: TE.kh * 0.38).monospacedDigit(),
        textColor: Color(
            red:   236.0/255.0,
            green: 235.0/255.0,
            blue:  235.0/255.0),
        disabledColor: Color(
            red:   236.0/255.0,
            green: 235.0/255.0,
            blue:  235.0/255.0),
        bgColor: Color(
            red:    66.0/255.0,
            green:  62.0/255.0,
            blue:   59.0/255.0),
        downBgColor: Color(
            red:   124.0/255.0,
            green: 125.0/255.0,
            blue:  127.0/255.0),
        downAnimationTime: 0.0,
        upAnimationTime: 0.0)

    /// I have selected "Optimize Interface for Mac" in target settings, general, which is 0.77 times smaller
    static private let kh: CGFloat  = 63.00 * 0.77 /// key height
    static private let kw: CGFloat  = 72.75 * 0.77 /// key width
    static private let wkw: CGFloat = 77.00 * 0.77 /// wider with for +-*/= keys
    static private let sp: CGFloat  = 1.0          /// space between keys

    static private let zoomIconSize: CGFloat = 30.0 * 0.77
    static let macWindowWidth: CGFloat = 9.0 * TE.kw + TE.wkw + 9.0 * TE.sp
    static let macWindowHeight: CGFloat = 419.5 * 0.77

    static private let numberPadWidth = 5.0 * TE.kw + 4.0 * TE.sp
    
    private static let staticDisplayFontSize: CGFloat = TE.numberPadWidth * 0.148
    let displayFontSize: CGFloat = TE.staticDisplayFontSize
    let scientificKeyFontSize = TE.kh * 0.36
    let digitsInSmallDisplay: Int = 16
    let isLandscape: Bool = true
    let spaceBetweenKeys: CGFloat = TE.sp
    let displayFont: Font = Font.system(size: TE.staticDisplayFontSize, weight: .thin).monospacedDigit()
    let widerKeySize: CGSize  = CGSize(width: TE.wkw, height: TE.kh)
    let scientificKeySize: CGSize   = CGSize(width: TE.kw,  height: TE.kh)
    let allkeysHeight: CGFloat = 5.0 * TE.kh + 4.0 * TE.sp
    let isPad: Bool = false
    let zeroTrailingPadding: CGFloat = TE.kw * 3
    let zoomTopPadding: CGFloat = 0.0
    let displayTopPaddingZoomed: CGFloat = 0.0
    let displayTopPaddingNotZoomed: CGFloat = 0.0
    let displayHeight: CGFloat = 0.0
    let iconSize: CGFloat = TE.kh * 0.7
    var circularProgressViewScaleFactor: CGFloat = 0.77
    let isIPad = false
    let isPortrait = false
    struct ButtonShape: View {
        var body: some View {
            Rectangle()
        }
    }

#else
    ///
    /// iOS
    ///
    
    static let appBackgroundColor = Color(.brown).opacity(0.7)
//    static let appBackgroundColor = Color(.black)

    let digits_1_9: KeyProperties
    let digits_0: KeyProperties
    let colorOpProperties: KeyProperties
    let ac_plus_minus_percentProperties: KeyProperties
    let scientificProperties: KeyProperties
    static let zoomIconSize: CGFloat = 30.0
    static let landscapeSpacingFraction: CGFloat = 0.01
    static let portraitSpacingFraction: CGFloat = 0.03

    var displayFontSize: CGFloat
    var displayFont: Font
    var spaceBetweenKeys: CGFloat
    var allkeysHeight: CGFloat
    var digitsInSmallDisplay: Int
    var isPad: Bool
    var zeroTrailingPadding: CGFloat
    var displayTopPaddingZoomed: CGFloat
    var displayTopPaddingNotZoomed: CGFloat
    var displayheight: CGFloat
    var zoomTopPadding: CGFloat
    var iconSize: CGFloat
    var circularProgressViewScaleFactor: CGFloat
    var isPortrait: Bool
    init(appFrame: CGSize, isPad: Bool, isPortrait: Bool) {
        self.isPad = isPad
        self.isPortrait = isPortrait
        let keySize: CGSize
        let keyWidth: CGFloat
        if !isPad && isPortrait {
            /// portrait iPhone
            spaceBetweenKeys = appFrame.width * Self.portraitSpacingFraction
            keyWidth = (appFrame.width - 3.0 * spaceBetweenKeys) * 0.25
        } else {
            /// all other cases
            spaceBetweenKeys = appFrame.width * Self.landscapeSpacingFraction
            keyWidth = (appFrame.width - 9.0 * spaceBetweenKeys) * 0.1
        }

        if isPortrait {
            keySize = CGSize(width: keyWidth, height: keyWidth)
        } else {
            let squareKeysHeight = 5.0 * keyWidth + 4.0 * spaceBetweenKeys
            let factor:CGFloat = min(1.0, appFrame.height * 0.8 / squareKeysHeight)
            keySize = CGSize(width: keyWidth, height: keyWidth * factor)
        }
        let scientificKeyFontSize = keySize.height * 0.35
        let digitsKeyFontSize     = keySize.height * 0.5
        digitsInSmallDisplay = 16
        displayFontSize = keySize.height * 1.1
        displayFont = Font.system(size: displayFontSize, weight: .thin).monospacedDigit()
        allkeysHeight = 5.0 * keySize.height + 4.0 * spaceBetweenKeys
        zeroTrailingPadding = keySize.width * 1 + digitsKeyFontSize*0.25
        iconSize = keySize.height * 0.7
        displayheight = 100.0
        if isPad {
            circularProgressViewScaleFactor = 2.0
            if isPortrait {
                /// iPad portrait
                displayTopPaddingNotZoomed = appFrame.height - allkeysHeight - keySize.height - spaceBetweenKeys
                displayTopPaddingZoomed = displayTopPaddingNotZoomed
                zoomTopPadding = displayTopPaddingNotZoomed + spaceBetweenKeys * 0.5
            } else {
                /// iPad landscape
                zoomTopPadding = spaceBetweenKeys * 0.5
                displayTopPaddingNotZoomed = appFrame.height - allkeysHeight - keySize.height - spaceBetweenKeys
                displayTopPaddingZoomed = 0.0
            }
        } else {
            /// iPhone
            circularProgressViewScaleFactor = 0.77
            displayTopPaddingNotZoomed = appFrame.height - allkeysHeight - keySize.height - spaceBetweenKeys
            displayTopPaddingZoomed = displayTopPaddingNotZoomed
            if isPortrait {
                /// iPhone portrait
                zoomTopPadding = displayTopPaddingNotZoomed + spaceBetweenKeys * 0.5
            } else {
                /// iPhone landscape
                zoomTopPadding = 0.5 * (keySize.height + spaceBetweenKeys - iconSize) + spaceBetweenKeys * 0.5
            }
        }

        digits_1_9 = KeyProperties(
            size: keySize,
            font: Font.system(size: digitsKeyFontSize).monospacedDigit(),
            textColor: Color(
                red:   231.0/255.0,
                green: 231.0/255.0,
                blue:  231.0/255.0),
            disabledColor: Color.gray,
            bgColor: Color(
                red:   51.0/255.0,
                green: 51.0/255.0,
                blue:  51.0/255.0),
            downBgColor: Color(
                red:   160.0/255.0,
                green: 159.0/255.0,
                blue:  158.0/255.0),
            downAnimationTime: 0.1,
            upAnimationTime: 0.5)
        
        digits_0 = KeyProperties(
            size: CGSize(width: 2.0 * keySize.width + spaceBetweenKeys, height: keySize.height),
            font: Font.system(size: digitsKeyFontSize).monospacedDigit(),
            textColor: Color(
                red:   231.0/255.0,
                green: 231.0/255.0,
                blue:  231.0/255.0),
            disabledColor: Color.gray,
            bgColor: Color(
                red:   51.0/255.0,
                green: 51.0/255.0,
                blue:  51.0/255.0),
            downBgColor: Color(
                red:   160.0/255.0,
                green: 159.0/255.0,
                blue:  158.0/255.0),
            downAnimationTime: 0.1,
            upAnimationTime: 0.5)


        colorOpProperties = KeyProperties(
            size: keySize,
            font: Font.system(size: scientificKeyFontSize, weight: .bold).monospacedDigit(),
            textColor: Color(
                red:   255.0/255.0,
                green: 255.0/255.0,
                blue:  255.0/255.0),
            disabledColor: Color.gray,
            bgColor: Color(
                red:   105.0/255.0,
                green: 183.0/255.0,
                blue:  191.0/255.0),
            downBgColor: Color(
                red:   203.0/255.0,
                green: 230.0/255.0,
                blue:  232.0/255.0),
            downAnimationTime: 0.1,
            upAnimationTime: 0.3)

        ac_plus_minus_percentProperties = KeyProperties(
            size: keySize,
            font: Font.system(size: scientificKeyFontSize).monospacedDigit(),
            textColor: Color(
                red:     0.0/255.0,
                green:   0.0/255.0,
                blue:    0.0/255.0),
            disabledColor: Color(
                red:    80.0/255.0,
                green:  80.0/255.0,
                blue:   80.0/255.0),
            bgColor: Color(
                red:   165.0/255.0,
                green: 165.0/255.0,
                blue:  165.0/255.0),
            downBgColor: Color(
                red:   124.0/255.0,
                green: 125.0/255.0,
                blue:  127.0/255.0),
            downAnimationTime: 0.1,
            upAnimationTime: 0.5)

        scientificProperties = KeyProperties(
            size: keySize,
            font: Font.system(size: scientificKeyFontSize).monospacedDigit(),
            textColor: Color(
                red:   236.0/255.0,
                green: 235.0/255.0,
                blue:  235.0/255.0),
            disabledColor: Color.gray,
            bgColor: Color(
                red:    33.0/255.0,
                green:  33.0/255.0,
                blue:   33.0/255.0),
            downBgColor: Color(
                red:   124.0/255.0,
                green: 125.0/255.0,
                blue:  127.0/255.0),
            downAnimationTime: 0.0,
            upAnimationTime: 0.0)
    }

    struct ButtonShape: View {
        var body: some View {
            Capsule()
        }
    }

#endif
        
}
