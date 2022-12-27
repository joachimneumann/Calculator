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
    @ObservedObject var model: Model
    var store = Store()
    @ObservedObject var keyModel: KeyModel
    
    init(_ screen: Screen) {
        print("Calculator INIT")
        self.screen = screen
        self.model = Model(screen: screen)
        self.keyModel = KeyModel(model: _model.wrappedValue)
    }
    
    var body: some View {
        // let _ = print("screenModel.isPortraitPhone", screen.isPortraitPhone)
        if screen.isPortraitPhone {
            VStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                PortraitDisplay(
                    display: model.display)
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
                        display: model.display,
                        showOrange: model.isCopying || model.isPasting,
                        disabledScrolling: !model.isZoomed,
                        scrollViewHasScrolled: $model.scrollViewHasScrolled,
                        offsetToVerticallyAlignTextWithkeyboard: screen.offsetToVerticallyAlignTextWithkeyboard,
                        digitWidth: screen.lengths.digitWidth,
                        ePadding: screen.lengths.ePadding,
                        scrollViewID: model.scrollViewID
                    )
                    Icons(
                        store: store,
                        model: model,
                        screen: screen,
                        isZoomed: $model.isZoomed)
                    .offset(y: screen.offsetToVerticallyIconWithText)
                }
                .overlay() {
                    VStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        Rectangle()
                            .foregroundColor(.black)
                            .frame(height: screen.lengths.infoHeight)
                            .overlay() {
                                let info = "\(keyModel.showPrecision ? "Precision: "+model.precisionDescription+" digits" : "\(keyModel.rad ? "Rad" : "")")"
                                let _ = print("info", info, "keyModel.showAC", keyModel.showAC)
                                if info.count > 0 {
                                    HStack(spacing: 0.0) {
                                        Text(info)
                                            .foregroundColor(.white)
                                            .font(Font(screen.infoUiFont))
                                        Spacer()
                                    }
                                    .padding(.leading, screen.keySize.width * 0.3)
                                    .offset(x: screen.keySpacing)
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
                    .offset(y: model.isZoomed ? screen.keyboardHeight + screen.keySize.height : 0.0)
                    .transition(.move(edge: .bottom))
                }
            }
//            .accentColor(.white) // for the navigation back button
//            .onChange(of: model.screenInfo.lengths.withoutComma) { _ in
//                model.updateDisplayData() // redraw with or without keyboard
//            }
        }
    }
}
/*
 var body: some View {
 // let _ = print("Calculator: isPortraitPhone \(model.screenInfo.isPortraitPhone) size \(model.screenInfo.calculatorSize)")
 // let _ = print("model.displayData.left \(model.displayData.left)")
 if model.screenInfo.isPortraitPhone {
 VStack(spacing: 0.0) {
 Spacer(minLength: 0.0)
 PortraitDisplay(
 display: model.display,
 screenInfo: model.screenInfo)
 //.background(Color.yellow)
 .padding(.horizontal, model.screenInfo.portraitIPhoneDisplayHorizontalPadding)
 .padding(.bottom, model.screenInfo.portraitIPhoneDisplayBottomPadding)
 NonScientificKeyboard(
 model: model,
 spacing: model.screenInfo.keySpacing,
 keySize: model.screenInfo.keySize)
 }
 //.background(Color.blue)
 .padding(.horizontal, model.screenInfo.portraitIPhoneHorizontalPadding)
 .padding(.bottom, model.screenInfo.portraitIPhoneBottomPadding)
 } else {
 MyNavigation {
 /*
  lowest level: longDisplay and Icons
  mid level: Keyboard with info and rectangle on top
  top level: single line
  */
 HStack(alignment: .top, spacing: 0.0) {
 Spacer(minLength: 0.0)
 // let _ = print("fontsize \(model.display.format.font)")
 LandscapeDisplay(
 display: model.display,
 screenInfo: model.screenInfo,
 showOrange: model.isCopying || model.isPasting,
 disabledScrolling: !model.isZoomed,
 scrollViewHasScrolled: $model.scrollViewHasScrolled,
 scrollViewID: model.scrollViewID
 )
 Icons(
 store: store,
 model: model,
 screenInfo: model.screenInfo,
 isZoomed: $model.isZoomed)
 .offset(y: model.screenInfo.offsetToVerticallyIconWithText)
 }
 .overlay() {
 VStack(spacing: 0.0) {
 Spacer(minLength: 0.0)
 Rectangle()
 .foregroundColor(.black)
 .frame(height: model.screenInfo.lengths.infoHeight)
 .overlay() {
 let info = "\(model.hasBeenReset ? "Precision: "+model.precisionDescription+" digits" : "\(model.rad ? "Rad" : "")")"
 if info.count > 0 {
 HStack(spacing: 0.0) {
 Text(info)
 .foregroundColor(.white)
 .font(Font(model.screenInfo.infoUiFont))
 Spacer()
 }
 .padding(.leading, model.screenInfo.keySize.width * 0.3)
 //                                .offset(x: screenInfo.keySpacing, y: -screenInfo.keyboardHeight)
 }
 }
 HStack(spacing: 0.0) {
 ScientificKeyboard(model: model, spacing: model.screenInfo.keySpacing, keySize: model.screenInfo.keySize)
 .padding(.trailing, model.screenInfo.keySpacing)
 NonScientificKeyboard(model: model, spacing: model.screenInfo.keySpacing, keySize: model.screenInfo.keySize)
 }
 .background(Color.black)
 }
 .offset(y: model.isZoomed ? model.screenInfo.calculatorSize.height : 0.0)
 .transition(.move(edge: .bottom))
 }
 }
 .accentColor(.white) // for the navigation back button
 .onChange(of: model.screenInfo.lengths.withoutComma) { _ in
 model.updateDisplayData() // redraw with or without keyboard
 }
 }
 }
 */


extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
