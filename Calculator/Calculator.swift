//
//  Calculator.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

let testColors = false

struct MyNavigation<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack(root: content)
        } else {
            NavigationView(content: content)
        }
    }
}

struct Calculator: View {
    let screen: Screen
    @ObservedObject var brainModel: BrainModel
    let keyModel: KeyModel

    @State var scrollViewHasScrolled = false
    @State var scrollViewID = UUID()

    @State var isZoomed: Bool = false {
        didSet {
            if scrollViewHasScrolled {
                scrollViewID = UUID()
            }
        }
    }

//    @ObservedObject var brainModel: Model
    var store = Store()
//    @ObservedObject var keyModel: KeyModel
    
    
    var body: some View {
        // let _ = print("screenModel.isPortraitPhone", screen.isPortraitPhone)
        if screen.isPortraitPhone {
            VStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                PortraitDisplay(
                    display: brainModel.display)
                .padding(.horizontal, screen.portraitIPhoneDisplayHorizontalPadding)
                .padding(.bottom, screen.portraitIPhoneDisplayBottomPadding)
                NonScientificKeyboard(
                    keyModel: keyModel,
                    spacing: screen.keySpacing,
                    keySize: screen.keySize)
            }
        } else {
            MyNavigation {
                /*
                 lowest level: longDisplay and Icons
                 mid level: Keyboard with info and rectangle on top
                 top level: single line
                 */
                HStack(alignment: .top, spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    LandscapeDisplay(
                        display: brainModel.display,
                        showOrange: brainModel.isCopying || brainModel.isPasting,
                        disabledScrolling: !isZoomed,
                        scrollViewHasScrolled: $scrollViewHasScrolled,
                        offsetToVerticallyAlignTextWithkeyboard: screen.offsetToVerticallyAlignTextWithkeyboard,
                        digitWidth: screen.lengths.digitWidth,
                        ePadding: screen.lengths.ePadding,
                        scrollViewID: scrollViewID
                    )
                    Icons(
                        store: store,
                        brainModel: brainModel,
                        screen: screen,
                        isZoomed: $isZoomed)
                    .offset(y: screen.offsetToVerticallyIconWithText)
                }
                .overlay() {
                    VStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        Rectangle()
                            .foregroundColor(.black)
                            .frame(height: screen.lengths.infoHeight)
                            .overlay() {
                                let info = "\(keyModel.showPrecision ? "Precision: "+brainModel.precisionDescription+" digits" : "\(keyModel.rad ? "Rad" : "")")"
                                if info.count > 0 {
                                    HStack(spacing: 0.0) {
                                        Text(info)
                                            .foregroundColor(.white)
                                            .font(Font(screen.infoUiFont))
                                        Spacer()
                                    }
                                    .padding(.leading, screen.keySize.width * 0.3)
                                }
                            }
                        HStack(spacing: 0.0) {
                            ScientificKeyboard(
                                keyModel: keyModel,
                                spacing: screen.keySpacing,
                                keySize: screen.keySize)
                            .padding(.trailing, screen.keySpacing)
                            NonScientificKeyboard(
                                keyModel: keyModel,
                                spacing: screen.keySpacing,
                                keySize: screen.keySize)
                        }
                        .background(Color.black)
                    }
                    .offset(y: isZoomed ? screen.keyboardHeight + screen.keySize.height : 0.0)
                    .transition(.move(edge: .bottom))
                }
            }
            .accentColor(.white) // for the navigation back button
//            .onChange(of: brainModel.screenInfo.lengths.withoutComma) { _ in
//                brainModel.updateDisplayData() // redraw with or without keyboard
//            }
        }
    }
}
/*
 var body: some View {
 // let _ = print("Calculator: isPortraitPhone \(brainModel.screenInfo.isPortraitPhone) size \(brainModel.screenInfo.calculatorSize)")
 // let _ = print("brainModel.displayData.left \(brainModel.displayData.left)")
 if brainModel.screenInfo.isPortraitPhone {
 VStack(spacing: 0.0) {
 Spacer(minLength: 0.0)
 PortraitDisplay(
 display: brainModel.display,
 screenInfo: brainModel.screenInfo)
 //.background(Color.yellow)
 .padding(.horizontal, brainModel.screenInfo.portraitIPhoneDisplayHorizontalPadding)
 .padding(.bottom, brainModel.screenInfo.portraitIPhoneDisplayBottomPadding)
 NonScientificKeyboard(
 brainModel: brainModel,
 spacing: brainModel.screenInfo.keySpacing,
 keySize: brainModel.screenInfo.keySize)
 }
 //.background(Color.blue)
 .padding(.horizontal, brainModel.screenInfo.portraitIPhoneHorizontalPadding)
 .padding(.bottom, brainModel.screenInfo.portraitIPhoneBottomPadding)
 } else {
 MyNavigation {
 /*
  lowest level: longDisplay and Icons
  mid level: Keyboard with info and rectangle on top
  top level: single line
  */
 HStack(alignment: .top, spacing: 0.0) {
 Spacer(minLength: 0.0)
 // let _ = print("fontsize \(brainModel.display.format.font)")
 LandscapeDisplay(
 display: brainModel.display,
 screenInfo: brainModel.screenInfo,
 showOrange: brainModel.isCopying || brainModel.isPasting,
 disabledScrolling: !brainModel.isZoomed,
 scrollViewHasScrolled: $brainModel.scrollViewHasScrolled,
 scrollViewID: brainModel.scrollViewID
 )
 Icons(
 store: store,
 brainModel: brainModel,
 screenInfo: brainModel.screenInfo,
 isZoomed: $brainModel.isZoomed)
 .offset(y: brainModel.screenInfo.offsetToVerticallyIconWithText)
 }
 .overlay() {
 VStack(spacing: 0.0) {
 Spacer(minLength: 0.0)
 Rectangle()
 .foregroundColor(.black)
 .frame(height: brainModel.screenInfo.lengths.infoHeight)
 .overlay() {
 let info = "\(brainModel.hasBeenReset ? "Precision: "+brainModel.precisionDescription+" digits" : "\(brainModel.rad ? "Rad" : "")")"
 if info.count > 0 {
 HStack(spacing: 0.0) {
 Text(info)
 .foregroundColor(.white)
 .font(Font(brainModel.screenInfo.infoUiFont))
 Spacer()
 }
 .padding(.leading, brainModel.screenInfo.keySize.width * 0.3)
 //                                .offset(x: screenInfo.keySpacing, y: -screenInfo.keyboardHeight)
 }
 }
 HStack(spacing: 0.0) {
 ScientificKeyboard(brainModel: brainModel, spacing: brainModel.screenInfo.keySpacing, keySize: brainModel.screenInfo.keySize)
 .padding(.trailing, brainModel.screenInfo.keySpacing)
 NonScientificKeyboard(brainModel: brainModel, spacing: brainModel.screenInfo.keySpacing, keySize: brainModel.screenInfo.keySize)
 }
 .background(Color.black)
 }
 .offset(y: brainModel.isZoomed ? brainModel.screenInfo.calculatorSize.height : 0.0)
 .transition(.move(edge: .bottom))
 }
 }
 .accentColor(.white) // for the navigation back button
 .onChange(of: brainModel.screenInfo.lengths.withoutComma) { _ in
 brainModel.updateDisplayData() // redraw with or without keyboard
 }
 }
 }
 */


extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
