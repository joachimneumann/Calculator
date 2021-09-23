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
    let appBackgroundColor = Color(
        red:    80.0/255.0,
        green:  76.0/255.0,
        blue:   80.0/255.0)
    let DigitKeyProperties = KeyProperties(
        textColor: Color(
            red:   236.0/255.0,
            green: 235.0/255.0,
            blue:  235.0/255.0),
        color: Color(
            red:   129.0/255.0,
            green: 121.0/255.0,
            blue:  122.0/255.0),
        downColor: Color(
            red:   179.0/255.0,
            green: 175.0/255.0,
            blue:  176.0/255.0),
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
            red:   103.0/255.0,
            green:  94.0/255.0,
            blue:   96.0/255.0),
        downColor: Color(
            red:   129.0/255.0,
            green: 121.0/255.0,
            blue:  122.0/255.0),
        downAnimationTime: 0.1,
        upAnimationTime: 0.5)
#else
    let appBackgroundColor = Color(.black)

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
