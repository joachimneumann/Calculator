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
    let keyModel: KeyModel

    @StateObject private var brainModel: BrainModel = BrainModel()
    
    @State var scrollViewHasScrolled = false
    @State var scrollViewID = UUID()

    @State var isZoomed: Bool = false {
        didSet {
            if scrollViewHasScrolled {
                scrollViewID = UUID()
            }
        }
    }

    var store = Store()
    
    var body: some View {
        // let _ = print("screenModel.isPortraitPhone", screen.isPortraitPhone)
        Group {
            if keyModel.screen.isPortraitPhone {
                VStack(spacing: 0.0) {
                    Spacer(minLength: 0.0)
                                        PortraitDisplay(display: brainModel.display)
                                            .padding(.horizontal, keyModel.screen.portraitIPhoneDisplayHorizontalPadding)
                                            .padding(.bottom, keyModel.screen.portraitIPhoneDisplayBottomPadding)
                                        NonScientificKeyboard(
                                            keyModel: keyModel,
                                            spacing: keyModel.screen.keySpacing,
                                            keySize: keyModel.screen.keySize)
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
                            offsetToVerticallyAlignTextWithkeyboard: keyModel.screen.offsetToVerticallyAlignTextWithkeyboard,
                            digitWidth: keyModel.screen.lengths.digitWidth,
                            ePadding: keyModel.screen.lengths.ePadding,
                            scrollViewID: scrollViewID
                        )
                        Icons(
                            store: store,
                            brainModel: brainModel,
                            screen: keyModel.screen,
                            isZoomed: $isZoomed)
                        .offset(y: keyModel.screen.offsetToVerticallyIconWithText)
                    }
                    .overlay() {
                        VStack(spacing: 0.0) {
                            Spacer(minLength: 0.0)
                            Rectangle()
                                .foregroundColor(.black)
                                .frame(height: keyModel.screen.lengths.infoHeight)
                                .overlay() {
                                    let info = "\(keyModel.showPrecision ? "Precision: "+brainModel.precisionDescription+" digits" : "\(keyModel.rad ? "Rad" : "")")"
                                    if info.count > 0 {
                                        HStack(spacing: 0.0) {
                                            Text(info)
                                                .foregroundColor(.white)
                                                .font(Font(keyModel.screen.infoUiFont))
                                            Spacer()
                                        }
                                        .padding(.leading, keyModel.screen.keySize.width * 0.3)
                                    }
                                }
                            HStack(spacing: 0.0) {
                                ScientificKeyboard(
                                    keyModel: keyModel,
                                    spacing: keyModel.screen.keySpacing,
                                    keySize: keyModel.screen.keySize)
                                .padding(.trailing, keyModel.screen.keySpacing)
                                NonScientificKeyboard(
                                    keyModel: keyModel,
                                    spacing: keyModel.screen.keySpacing,
                                    keySize: keyModel.screen.keySize)
                            }
                            .background(Color.black)
                        }
                        .offset(y: isZoomed ? keyModel.screen.keyboardHeight + keyModel.screen.keySize.height : 0.0)
                        .transition(.move(edge: .bottom))
                    }
                }
                .accentColor(.white) // for the navigation back button
            }
        }
        .onAppear() {
            if keyModel.keyPressResponder == nil {
                keyModel.keyPressResponder = brainModel
            }
            brainModel.keyPress(symbol: "AC", screen: keyModel.screen)
        }
//        .onChange(of: keyModel.screen.lengths.withoutComma) { _ in
//            print("keyModel.screen.lengths.withoutComma", keyModel.screen.lengths.withoutComma)
//            Task {
//                await brainModel.refreshDisplay(screen: keyModel.screen)
//            }
//        }
    }
}
/*
 var body: some View {
 // let _ = print("Calculator: isPortraitPhone \(keyModel.screenInfo.isPortraitPhone) size \(keyModel.screenInfo.calculatorSize)")
 // let _ = print("brainModel.displayData.left \(brainModel.displayData.left)")
 if keyModel.screenInfo.isPortraitPhone {
 VStack(spacing: 0.0) {
 Spacer(minLength: 0.0)
 PortraitDisplay(
 display: brainModel.display,
 screenInfo: keyModel.screenInfo)
 //.background(Color.yellow)
 .padding(.horizontal, keyModel.screenInfo.portraitIPhoneDisplayHorizontalPadding)
 .padding(.bottom, keyModel.screenInfo.portraitIPhoneDisplayBottomPadding)
 NonScientificKeyboard(
 brainModel: brainModel,
 spacing: keyModel.screenInfo.keySpacing,
 keySize: keyModel.screenInfo.keySize)
 }
 //.background(Color.blue)
 .padding(.horizontal, keyModel.screenInfo.portraitIPhoneHorizontalPadding)
 .padding(.bottom, keyModel.screenInfo.portraitIPhoneBottomPadding)
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
 screenInfo: keyModel.screenInfo,
 showOrange: brainModel.isCopying || brainModel.isPasting,
 disabledScrolling: !brainModel.isZoomed,
 scrollViewHasScrolled: $brainModel.scrollViewHasScrolled,
 scrollViewID: brainModel.scrollViewID
 )
 Icons(
 store: store,
 brainModel: brainModel,
 screenInfo: keyModel.screenInfo,
 isZoomed: $brainModel.isZoomed)
 .offset(y: keyModel.screenInfo.offsetToVerticallyIconWithText)
 }
 .overlay() {
 VStack(spacing: 0.0) {
 Spacer(minLength: 0.0)
 Rectangle()
 .foregroundColor(.black)
 .frame(height: keyModel.screenInfo.lengths.infoHeight)
 .overlay() {
 let info = "\(brainModel.hasBeenReset ? "Precision: "+brainModel.precisionDescription+" digits" : "\(brainModel.rad ? "Rad" : "")")"
 if info.count > 0 {
 HStack(spacing: 0.0) {
 Text(info)
 .foregroundColor(.white)
 .font(Font(keyModel.screenInfo.infoUiFont))
 Spacer()
 }
 .padding(.leading, keyModel.screenInfo.keySize.width * 0.3)
 //                                .offset(x: screenInfo.keySpacing, y: -screenInfo.keyboardHeight)
 }
 }
 HStack(spacing: 0.0) {
 ScientificKeyboard(brainModel: brainModel, spacing: keyModel.screenInfo.keySpacing, keySize: keyModel.screenInfo.keySize)
 .padding(.trailing, keyModel.screenInfo.keySpacing)
 NonScientificKeyboard(brainModel: brainModel, spacing: keyModel.screenInfo.keySpacing, keySize: keyModel.screenInfo.keySize)
 }
 .background(Color.black)
 }
 .offset(y: brainModel.isZoomed ? keyModel.screenInfo.calculatorSize.height : 0.0)
 .transition(.move(edge: .bottom))
 }
 }
 .accentColor(.white) // for the navigation back button
 .onChange(of: keyModel.screenInfo.lengths.withoutComma) { _ in
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
