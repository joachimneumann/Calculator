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
    @StateObject private var brainModel: BrainModel
    @StateObject private var keyModel: KeyModel
    
    init(screen: Screen) {
        _brainModel = StateObject(wrappedValue: BrainModel(screen: screen))
        _keyModel = StateObject(wrappedValue: KeyModel(screen: screen))
    }

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
        if brainModel.screen.isPortraitPhone {
            VStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                PortraitDisplay(
                    display: brainModel.display)
                .padding(.horizontal, brainModel.screen.portraitIPhoneDisplayHorizontalPadding)
                .padding(.bottom, brainModel.screen.portraitIPhoneDisplayBottomPadding)
                NonScientificKeyboard(
                    keyModel: keyModel,
                    spacing: brainModel.screen.keySpacing,
                    keySize: brainModel.screen.keySize)
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
                        offsetToVerticallyAlignTextWithkeyboard: brainModel.screen.offsetToVerticallyAlignTextWithkeyboard,
                        digitWidth: brainModel.screen.lengths.digitWidth,
                        ePadding: brainModel.screen.lengths.ePadding,
                        scrollViewID: scrollViewID
                    )
                    Icons(
                        store: store,
                        brainModel: brainModel,
                        screen: brainModel.screen,
                        isZoomed: $isZoomed)
                    .offset(y: brainModel.screen.offsetToVerticallyIconWithText)
                }
                .overlay() {
                    VStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        Rectangle()
                            .foregroundColor(.black)
                            .frame(height: brainModel.screen.lengths.infoHeight)
                            .overlay() {
                                let info = "\(keyModel.showPrecision ? "Precision: "+brainModel.precisionDescription+" digits" : "\(keyModel.rad ? "Rad" : "")")"
                                if info.count > 0 {
                                    HStack(spacing: 0.0) {
                                        Text(info)
                                            .foregroundColor(.white)
                                            .font(Font(brainModel.screen.infoUiFont))
                                        Spacer()
                                    }
                                    .padding(.leading, brainModel.screen.keySize.width * 0.3)
                                }
                            }
                        HStack(spacing: 0.0) {
                            ScientificKeyboard(
                                keyModel: keyModel,
                                spacing: brainModel.screen.keySpacing,
                                keySize: brainModel.screen.keySize)
                            .padding(.trailing, brainModel.screen.keySpacing)
                            NonScientificKeyboard(
                                keyModel: keyModel,
                                spacing: brainModel.screen.keySpacing,
                                keySize: brainModel.screen.keySize)
                        }
                        .background(Color.black)
                    }
                    .offset(y: isZoomed ? brainModel.screen.keyboardHeight + brainModel.screen.keySize.height : 0.0)
                    .transition(.move(edge: .bottom))
                }
            }
            .onAppear() {
                keyModel.assignCallback(callback: brainModel.execute)
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
