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
    let bottomPadding: CGFloat
}

class TE {
    static let iPhoneSymbolFontSizeReduction: CGFloat = 0.85//1.0
    static let digitsInAllDigitsDisplay: Int = 100

//    static let appBackgroundColor = Color(.brown).opacity(0.7)
    static let appBackgroundColor = Color(.black)
//    static let appBackgroundColor = Color(.brown)

    let digits_1_9: KeyProperties
    let digits_0: KeyProperties
    let colorOpProperties: KeyProperties
    let ac_plus_minus_percentProperties: KeyProperties
    let scientificProperties: KeyProperties
    let parenthesisProperties: KeyProperties
    static var digitsInOneLine: Int = 0
    static let zoomIconSize: CGFloat = 30.0
    static let iconLeadingPadding: CGFloat = 0.2
    
    var displayUIFont: UIFont
    var iPhonePortraitDisplayUIFont: UIFont
    var spaceBetweenKeys: CGFloat
    var allkeysHeight: CGFloat
    var withoutComma: Int
    var withComma: Int
    var isPad: Bool
    var zeroTrailingPadding: CGFloat
    var singleLineDisplayHeight: CGFloat
    var iPhonePortraitSingleLineDisplayHeight: CGFloat
    var multipleLineDisplayHeight: CGFloat
    var zoomTopPaddingZoomed: CGFloat
    var zoomTopPaddingNotZoomed: CGFloat
    var iconSize: CGFloat
    var circularProgressViewScaleFactor: CGFloat
    var isPortrait: Bool
    var isZoomAllowed: Bool {
        return isPad || !isPortrait
    }
    let trailingAfterDisplay: CGFloat

    init(appFrame: CGSize) {
        self.isPad = (UIDevice.current.userInterfaceIdiom == .pad)
        self.isPortrait = appFrame.height > appFrame.width
        let keySize: CGSize
        let keyWidth: CGFloat
        if !isPad && isPortrait {
            /// portrait iPhone
            spaceBetweenKeys = appFrame.width * 0.04
            keyWidth = (appFrame.width - 3.0 * spaceBetweenKeys) * 0.25
        } else {
            /// all other cases
            spaceBetweenKeys = appFrame.width * 0.01
            keyWidth = (appFrame.width - 9.0 * spaceBetweenKeys) * 0.1
        }

        if isPortrait {
            keySize = CGSize(width: keyWidth, height: keyWidth)
        } else {
            /// landscape
            if isPad {
                let allKeys = appFrame.height * 0.5
                let smallerKeyHeight = (allKeys - 4.0 * spaceBetweenKeys) / 5.0
                keySize = CGSize(width: keyWidth, height: smallerKeyHeight)
            } else {
                /// iPhone
                let keyHeight = (appFrame.height - 4.0 * spaceBetweenKeys) / 6 /// 5 keys and display, which is also keyHeight
                keySize = CGSize(width: keyWidth, height: keyHeight)
            }
        }
        
        let scientificKeyFontSize = keySize.height * 0.35
        let digitsKeyFontSize     = keySize.height * 0.47
        let displayFontSize           = keySize.height * 0.79
        displayUIFont = UIFont.monospacedDigitSystemFont(ofSize: displayFontSize, weight: .thin)
        iconSize = keySize.height * 0.7
        trailingAfterDisplay = (isPad || !isPortrait) ? iconSize * 1.2 : 0.0

        var w = 0.0
        var s = ""
        var displayLength = appFrame.width
        if isPad || !isPortrait {
            displayLength -= iconSize * (1.0 + TE.iconLeadingPadding)
        }
//        print("iconSize = \(iconSize)")
//        print("displayLength = \(displayLength)")
        while w < displayLength {
            s.append("0")
            w = s.sizeOf_String(uiFont: displayUIFont).width
        }
        withoutComma = s.count - 1
        //print("digitsInDisplayWithoutComma: \(digitsInDisplayWithoutComma)")

        w = 0.0
        s = ","
        while w < displayLength {
            s.append("0")
            w = s.sizeOf_String(uiFont: displayUIFont).width
        }
        withComma = s.count - 1
        // print("digitsInDisplayWithComma: \(digitsInDisplayWithComma)")

        allkeysHeight = 5.0 * keySize.height + 4.0 * spaceBetweenKeys
        zeroTrailingPadding = keySize.width * 1 + digitsKeyFontSize*0.25
        singleLineDisplayHeight = keySize.height
        let fontFactor = 1.5
        iPhonePortraitSingleLineDisplayHeight = keySize.height * fontFactor
        iPhonePortraitDisplayUIFont = UIFont.monospacedDigitSystemFont(ofSize: displayFontSize * fontFactor, weight: .thin)

        if isPad {
            circularProgressViewScaleFactor = 2.0
            zoomTopPaddingNotZoomed = appFrame.height - allkeysHeight - singleLineDisplayHeight + singleLineDisplayHeight * 0.15
            zoomTopPaddingZoomed = singleLineDisplayHeight * 0.15
            multipleLineDisplayHeight = appFrame.height - allkeysHeight
        } else {
            /// iPhone
            circularProgressViewScaleFactor = 0.77
            zoomTopPaddingNotZoomed = singleLineDisplayHeight * 0.15
            zoomTopPaddingZoomed = zoomTopPaddingNotZoomed
            multipleLineDisplayHeight = singleLineDisplayHeight + allkeysHeight
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
            upAnimationTime: 0.5,
            bottomPadding: 0.0)
        
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
            upAnimationTime: 0.5,
            bottomPadding: 0.0)


        colorOpProperties = KeyProperties(
            size: keySize,
            font: Font.system(size: scientificKeyFontSize, weight: .bold).monospacedDigit(),
            textColor: Color(
                red:   255.0/255.0,
                green: 255.0/255.0,
                blue:  255.0/255.0),
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
//            textColor: Color(
//                red:   255.0/255.0,
//                green: 255.0/255.0,
//                blue:  255.0/255.0),
//            disabledColor: Color.gray,
//            bgColor: Color(
//                red:   105.0/255.0,
//                green: 183.0/255.0,
//                blue:  191.0/255.0),
//            downBgColor: Color(
//                red:   203.0/255.0,
//                green: 230.0/255.0,
//                blue:  232.0/255.0),
            downAnimationTime: 0.1,
            upAnimationTime: 0.3,
            bottomPadding: 0.0)

        ac_plus_minus_percentProperties = KeyProperties(
            size: keySize,
            font: Font.system(size: scientificKeyFontSize).monospacedDigit(),
            textColor: Color(
                red:   255.0/255.0,
                green: 255.0/255.0,
                blue:  255.0/255.0),
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
            upAnimationTime: 0.5,
            bottomPadding: 0.0)

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
            upAnimationTime: 0.0,
            bottomPadding: 0.0)

        parenthesisProperties = KeyProperties(
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
            upAnimationTime: 0.0,
            bottomPadding: keySize.height * 0.05)
    }

    struct ButtonShape: View {
        var body: some View {
            Capsule()
        }
    }
}

extension String {
    func sizeOf_String(uiFont: UIFont) -> CGSize {
        let fontAttribute = [NSAttributedString.Key.font: uiFont]
        let size = self.size(withAttributes: fontAttribute)  // for Single Line
       return size;
    }
}

