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
    static let iPhoneSymbolFontSizeReduction: CGFloat = 0.85//1.0
    static let digitsInAllDigitsDisplay: Int = 100
    
    static let lowPrecision          = 100
    static let lowPrecisionString    = "one hundred digits"
    static let mediumPrecision       = 10000
    static let mediumPrecisionString = "ten thousand digits"
    static let highPrecision         = 1000000
    static let highPrecisionString   = "one million digits"


//    static let appBackgroundColor = Color(.brown).opacity(0.7)
    static let appBackgroundColor = Color(.brown)

    let digits_1_9: KeyProperties
    let digits_0: KeyProperties
    let colorOpProperties: KeyProperties
    let ac_plus_minus_percentProperties: KeyProperties
    let scientificProperties: KeyProperties
    static var digitsInOneLine: Int = 0
    static let zoomIconSize: CGFloat = 30.0
    static let landscapeSpacingFraction: CGFloat = 0.01
    static let portraitSpacingFraction: CGFloat = 0.03
    static let iconLeadingPadding: CGFloat = 0.2
    
    var displayUIFont: UIFont
    var spaceBetweenKeys: CGFloat
    var allkeysHeight: CGFloat
    var withoutComma: Int
    var withComma: Int
    var isPad: Bool
    var zeroTrailingPadding: CGFloat
    var displayTopPaddingZoomed: CGFloat
    var displayTopPaddingNotZoomed: CGFloat
    var displayHeight: CGFloat
    var zoomTopPadding: CGFloat
    var iconSize: CGFloat
    var circularProgressViewScaleFactor: CGFloat
    var isPortrait: Bool
    var isZoomAllowed: Bool {
        return isPad || !isPortrait
    }
    init(appFrame: CGSize) {
        self.isPad = (UIDevice.current.userInterfaceIdiom == .pad)
        self.isPortrait = appFrame.height > appFrame.width
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
            /// landscape
            if isPad {
                let allKeys = appFrame.height * 0.5
                let smallerKeyHeight = (allKeys - 4.0 * spaceBetweenKeys) / 5.0
                keySize = CGSize(width: keyWidth, height: smallerKeyHeight)
            } else {
                /// iPhone
                let squareKeysHeight = 5.0 * keyWidth + 4.0 * spaceBetweenKeys
                let factor:CGFloat = min(1.0, appFrame.height * 0.8 / squareKeysHeight)
                keySize = CGSize(width: keyWidth, height: keyWidth * factor)
            }
        }
        
        let scientificKeyFontSize = keySize.height * 0.35
        let digitsKeyFontSize     = keySize.height * 0.5
        let displayFontSize           = keySize.height * 0.79
        displayUIFont = UIFont.monospacedDigitSystemFont(ofSize: displayFontSize, weight: .thin)
        iconSize = keySize.height * 0.7

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
        displayHeight = keySize.height
        
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
}

extension String {
    func sizeOf_String(uiFont: UIFont) -> CGSize {
        let fontAttribute = [NSAttributedString.Key.font: uiFont]
        let size = self.size(withAttributes: fontAttribute)  // for Single Line
       return size;
    }
}

