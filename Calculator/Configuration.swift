//
//  Configuration.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

class Configuration {
    
    struct KeyProperties {
        let textColor: Color
        let color: Color
        let downColor: Color
        let downAnimationTime: Double
        let upAnimationTime: Double
    }
#if targetEnvironment(macCatalyst)
    static let digitsInSmallDisplay = 16
    static let windowWidth: CGFloat = 575.0
    static let windowHeight: CGFloat = 323.0
    static let displayFontSize: CGFloat = 47
    static var zoomIconSize: CGFloat = 30
    static func numberKeySize(appFrame: CGSize) -> CGSize { CGSize(width: 56.25,     height: 47.0) }
    static func slightlyLargerNumberKeySize(appFrame: CGSize) -> CGSize { CGSize(width: 56.25+2.0, height: 47.0) }
    static func scientificKeySize(appFrame: CGSize) -> CGSize { numberKeySize(appFrame: appFrame) }
    static func spaceBetweenkeys(appFrame: CGSize) -> CGFloat { 1.0 }
    static let allDigitsFont = Font.custom("CourierNewPSMT", keySize: 19)
    
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
        color: Color(
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
        color: Color(
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
        color: Color(
            red:    66.0/255.0,
            green:  62.0/255.0,
            blue:   59.0/255.0),
        downColor: Color(
            red:   124.0/255.0,
            green: 125.0/255.0,
            blue:  127.0/255.0),
        downAnimationTime: 0.1,
        upAnimationTime: 0.5)
#else
    ///
    /// iOS
    ///
    static let digitsInSmallDisplay = 9
    static let appBackgroundColor = Color(.black)
    static let displayFontSize: CGFloat = 70.0
    static var zoomIconSize: CGFloat = 30.0
    static let landscapeAspectRatio = 2.489
    static let landscapepadding: CGFloat = 100.0
    static let spacingFration = 0.01
    static let numberPadFration = (0.4+3.0*spacingFration)/(1.0+9.0*spacingFration)
    
    static func spaceBetweenkeys(appFrame: CGSize) -> CGFloat { appFrame.width * spacingFration }
    static func numberKeySize(appFrame: CGSize) -> CGSize {
        let allKeysWidth  = appFrame.width-landscapepadding
        let allKeysHeight = allKeysWidth / landscapeAspectRatio
        let numberPadWidth = allKeysWidth * numberPadFration
        print("numberKeySize appFrame=\(appFrame)")
        let keywidth = (numberPadWidth - 3.0*spaceBetweenkeys(appFrame: appFrame)) * 0.25
        let keyheight = (allKeysHeight - 4.0*spaceBetweenkeys(appFrame: appFrame)) * 0.20
        return CGSize(width: keywidth, height: keyheight)
    }
    static func slightlyLargerNumberKeySize(appFrame: CGSize) -> CGSize { numberKeySize(appFrame: appFrame) }
    static func scientificKeySize(appFrame: CGSize) -> CGSize {
            print("scientificKeySize appFrame=\(appFrame)")
        let allKeysWidth  = appFrame.width-landscapepadding
        let allKeysHeight = allKeysWidth / landscapeAspectRatio
        let numberPadWidth = allKeysWidth * numberPadFration
        let scientificPadWidth = allKeysWidth - numberPadWidth
        let keywidth = (scientificPadWidth - 5.0*spaceBetweenkeys(appFrame: appFrame)) / 6.0
        let keyheight = (allKeysHeight - 4.0*spaceBetweenkeys(appFrame: appFrame)) * 0.2
        return CGSize(width: keywidth, height: keyheight)
    }

    static func verticalSpace(forTotalWidth w: CGFloat)   -> CGFloat { 0.03 * w }
    static func horizontalSpace(forTotalWidth w: CGFloat) -> CGFloat { 0.03 * w }
    static let allDigitsFont = Font.custom("CourierNewPSMT", size: 19)

    static let DigitKeyProperties = KeyProperties(
        textColor: Color.white,
        color: Color(
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
        color: Color(
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
        color: Color(
            red:   165.0/255.0,
            green: 165.0/255.0,
            blue:  165.0/255.0),
        downColor: Color(
            red:   216.0/255.0,
            green: 216.0/255.0,
            blue:  216.0/255.0),
        downAnimationTime: 0.1,
        upAnimationTime: 0.5)
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
