//
//  Configuration.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

class Configuration {
    static let iPhoneScientificFontSizeReduction: CGFloat = 0.8
    static let digitsInAllDigitsDisplay = 10000-1

#if targetEnvironment(macCatalyst)
    static let digitsInSmallDisplay = 16
    static let windowWidth: CGFloat = 575.0
    static let windowHeight: CGFloat = 323.0
    static let displayFontSize: CGFloat = 47
    static let zoomIconSize: CGFloat = 30

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

//    static let numberKeySize:CGSize = CGSize(width: 56.25, height: 47.0)
//    func slightlyLargerNumberKeySize(appFrame: CGSize) -> CGSize { CGSize(width: 56.25+2.0, height: 47.0) }
//    func scientificKeySize(appFrame: CGSize) -> CGSize { numberKeySize(appFrame: appFrame) }
//    func spaceBetweenkeys(appFrame: CGSize) -> CGFloat { 1.0 }
//    let allDigitsFont = Font.custom("CourierNewPSMT", fontSize: 19)
    
#else
    ///
    /// iOS
    ///
    
    static let appBackgroundColor = Color(.black)
    static let allDigitsFont = Font.custom("CourierNewPSMT", size: 19)

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

    static let digitsInSmallDisplay = 9
    static let displayFontSize: CGFloat = 10.0
    static let zoomIconSize: CGFloat = 30.0
    static let spacingFration: CGFloat = 0.01
    static let numberPadFration: CGFloat = 0.3//(0.4+3.0*spacingFration)/(1.0+9.0*spacingFration)
    
    var landscapeAspectRatio: CGFloat = 0.0
    var spaceBetweenkeys: CGFloat = 0.0
    var numberPadWidth: CGFloat = 0.0
    var scientificPadWidth: CGFloat = 0.0
    var allKeysHeight: CGFloat = 0.0
    var numberKeySize: CGSize = CGSize(width: 0.0, height: 0.0)
    var slightlyLargerNumberKeySize: CGSize = CGSize(width: 0.0, height: 0.0)
    var scientificKeySize: CGSize = CGSize(width: 0.0, height: 0.0)
    init(appFrame: CGSize) {
        print("calc() appFrame=\(appFrame)")
        landscapeAspectRatio = (10.0 + 9.0 * Self.spacingFration) / (5 + 4.0 * Self.spacingFration) /// iPhone 11 Pro Max: 2.489
        spaceBetweenkeys = appFrame.width * Self.spacingFration
        
        // numberKeys
        let aspectRatio = max(landscapeAspectRatio, appFrame.width / (appFrame.height*0.8))
        //let landscapePadding = spaceBetweenkeys
        let allKeysWidth  = appFrame.width//-landscapePadding
        allKeysHeight = allKeysWidth / aspectRatio
        numberPadWidth = allKeysWidth * Self.numberPadFration
        // print("numberKeySize appFrame=\(appFrame)")
        var keywidth = (numberPadWidth - 3.0*spaceBetweenkeys) * 0.25
        var keyheight = (allKeysHeight - 4.0*spaceBetweenkeys) * 0.20
        let n = keywidth*4+3*spaceBetweenkeys
        print(n)
        numberKeySize = CGSize(width: keywidth, height: keyheight)
        slightlyLargerNumberKeySize = numberKeySize
        
        scientificPadWidth = allKeysWidth - numberPadWidth - spaceBetweenkeys
        keywidth = (scientificPadWidth - 5.0*spaceBetweenkeys) / 6.0
        let s = keywidth*6+5*spaceBetweenkeys
        print(s)
        print(n+s+spaceBetweenkeys)
        keyheight = (allKeysHeight - 4.0*spaceBetweenkeys) * 0.2
        scientificKeySize = CGSize(width: keywidth, height: keyheight)
    }

//    func verticalSpace(forTotalWidth w: CGFloat)   -> CGFloat { 0.03 * w }
//    func horizontalSpace(forTotalWidth w: CGFloat) -> CGFloat { 0.03 * w }

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
