//
//  TE.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

class TE {
    static let iPhoneScientificFontSizeReduction: CGFloat = 0.8
    static let digitsInAllDigitsDisplay = 10000-1

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

    static let allDigitsFont = Font.custom("CourierNewPSMT", size: 19)

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


    static let digitsInSmallDisplay = 16
    static let zoomIconSize: CGFloat = 30.0
    static let macWindowWidth: CGFloat = 9.0*TE.kw+TE.wkw+9.0*TE.sp
    static let macWindowHeight: CGFloat = 419.5
    static let kh  = 63.0  // key height
    static let kw  = 72.75 // key width
    static let wkw = 77.0  // wider with for +-*/= keys
    static let sp  = 1.5   // space between keys
    static let nf  = 0.4   // part of numberPad

    let isLandscape: Bool = true
    let spaceBetweenkeys: CGFloat   = TE.sp
    let numberPadWidth: CGFloat     = 3.0*TE.kw+TE.wkw+3.0*TE.sp
    let scientificPadWidth: CGFloat = 6.0*TE.kw+5.0*TE.sp
    let allKeysHeight: CGFloat      = (5.0 * TE.kh + 4.0 * TE.sp)
    let displayFontSize: CGFloat    = (5.0 * TE.kw + 4.0 * TE.sp) * 0.175
    let numberKeySize: CGSize       = CGSize(width: TE.kw,  height: TE.kh)
    let widerNumberKeySize: CGSize  = CGSize(width: TE.wkw, height: TE.kh)
    let scientificKeySize: CGSize   = CGSize(width: TE.kw,  height: TE.kh)
    // no init needed
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

    static let digitsInSmallDisplay = 16
    static let zoomIconSize: CGFloat = 30.0
    static let spacingFration: CGFloat = 0.03

    var displayFontSize: CGFloat = 0.0
    var isLandscape: Bool = false
    var spaceBetweenkeys: CGFloat = 0.0
    var numberPadWidth: CGFloat = 0.0
    var scientificPadWidth: CGFloat = 0.0
    var allKeysHeight: CGFloat = 0.0
    var numberKeySize: CGSize = CGSize(width: 0.0, height: 0.0)
    var widerNumberKeySize: CGSize = CGSize(width: 0.0, height: 0.0)
    var scientificKeySize: CGSize = CGSize(width: 0.0, height: 0.0)
    init(appFrame: CGSize) {
        let numberPadFration: CGFloat = 0.4//(0.4+3.0*spacingFration)/(1.0+9.0*spacingFration)
        isLandscape = appFrame.width > appFrame.height
        print("calc() appFrame=\(appFrame)")
        let landscapeAspectRatio = (10.0 + 9.0 * Self.spacingFration) / (5 + 4.0 * Self.spacingFration)
        let portraitAspectRatio = (4.0 + 3.0 * Self.spacingFration) / (5 + 4.0 * Self.spacingFration)
        
        let aspectRatio = max(isLandscape ? landscapeAspectRatio : portraitAspectRatio, appFrame.width / (appFrame.height*0.8))

        let allKeysWidth  = appFrame.width
        allKeysHeight = allKeysWidth / aspectRatio
        numberPadWidth = allKeysWidth * (isLandscape ? numberPadFration : 1.0)
        displayFontSize = allKeysHeight * 0.2
        spaceBetweenkeys = numberPadWidth * Self.spacingFration
        // print("numberKeySize appFrame=\(appFrame)")
        var keywidth = (numberPadWidth - 3.0*spaceBetweenkeys) * 0.25
        var keyheight = (allKeysHeight - 4.0*spaceBetweenkeys) * 0.20
        //let n = keywidth*4+3*spaceBetweenkeys
        //print(n)
        numberKeySize = CGSize(width: keywidth, height: keyheight)
        widerNumberKeySize = numberKeySize
        
        scientificPadWidth = allKeysWidth - numberPadWidth - spaceBetweenkeys
        keywidth = (scientificPadWidth - 5.0*spaceBetweenkeys) / 6.0
        //let s = keywidth*6+5*spaceBetweenkeys
        //print(s)
        //print(n+s+spaceBetweenkeys)
        keyheight = (allKeysHeight - 4.0*spaceBetweenkeys) * 0.2
        scientificKeySize = CGSize(width: keywidth, height: keyheight)
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
