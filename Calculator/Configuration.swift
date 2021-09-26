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
    let digitsInSmallDisplay = 16
    let windowWidth: CGFloat = 575.0
    let windowHeight: CGFloat = 323.0
    let displayFontSize: CGFloat = 47
    var zoomIconSize: CGFloat { displayFontSize*0.5 }
    let keyWidth: CGFloat = 56.25
    let keyHeight: CGFloat = 47.0

    
    /// The MacOS Calculator is a bit transparent.
    /// The colors specified here replicate the button colors
    /// when the MacOS Calcuator is on a black background.
    /// To make this app distinguashable from the
    /// MacOS Calculator, the 5 rightmost buttons
    /// are in a blue tint instead of Apple's orange.
    let appBackgroundColor = Color(
        red:    46.0/255.0,
        green:  39.0/255.0,
        blue:   38.0/255.0)
    let DigitKeyProperties = KeyProperties(
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


    let OpKeyProperties = KeyProperties(
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

    let LightGrayKeyProperties = KeyProperties(
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
    let digitsInSmallDisplay = 9
    let appBackgroundColor = Color(.black)
    let displayFontSize: CGFloat = 70
    let keyWidth: CGFloat = 20 // TODO remove this
    let keyHeight: CGFloat = 20

    let DigitKeyProperties = KeyProperties(
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


    let OpKeyProperties = KeyProperties(
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

    let LightGrayKeyProperties = KeyProperties(
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


    struct Background: View {
        var body: some View {
            #if targetEnvironment(macCatalyst)
                Rectangle()
            #else
                Capsule()
            #endif
        }
    }
    
#if targetEnvironment(macCatalyst)
    func verticalSpace(forTotalWidth w: CGFloat)   -> CGFloat { 1.0 }
    func horizontalSpace(forTotalWidth w: CGFloat) -> CGFloat { 1.0 }
#else
    func verticalSpace(forTotalWidth w: CGFloat)   -> CGFloat { 0.03 * w }
    func horizontalSpace(forTotalWidth w: CGFloat) -> CGFloat { 0.03 * w }
#endif

    /// singleton: private init and static shared object
    static var shared = Configuration()
    private init() {
    }
}
