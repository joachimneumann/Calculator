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
    @ObservedObject var screen: Screen
    @StateObject private var keyModel: KeyModel = KeyModel()
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
        
    var portraitView: some View {
        VStack(spacing: 0.0) {
            Spacer(minLength: 0.0)
            PortraitDisplay(display: keyModel.currentDisplay)
                .padding(.bottom, screen.portraitIPhoneDisplayBottomPadding)
                .padding(.horizontal, screen.portraitIPhoneDisplayHorizontalPadding)
            NonScientificKeyboard(
                screen: screen,
                keyModel: keyModel)
        }
    }
    
    var landscapeKeyboard: some View {
        HStack(spacing: 0.0) {
            ScientificKeyboard(
                screen: screen,
                keyModel: keyModel)
            .padding(.trailing, screen.keySpacing)
            NonScientificKeyboard(
                screen: screen,
                keyModel: keyModel)
        }
        .background(Color.black)
    }
    
    var infoView: some View {
        HStack(spacing: 0.0) {
            let info = "\(keyModel.showPrecision ? "Precision: "+brainModel.precisionDescription+" digits" : "\(keyModel.rad ? "Rad" : "")")"
            Text(info)
                .foregroundColor(.white)
                .font(Font(screen.infoUiFont))
            Spacer()
        }
        .padding(.leading, screen.keySize.width * 0.3)
    }
    
    var landscapeKeyboardPlusStuff: some View {
        VStack(spacing: 0.0) {
            Spacer(minLength: 0.0)
            Rectangle()
                .foregroundColor(.black)
                .frame(height: screen.lengths.infoHeight)
                .overlay() {
                    infoView
                }
            landscapeKeyboard
        }
        .offset(y: isZoomed ? screen.keyboardHeight + screen.keySize.height : 0.0)
        .transition(.move(edge: .bottom))
    }
    
    var landscapeDisplayAndIcons: some View {
        HStack(alignment: .top, spacing: 0.0) {
            Spacer(minLength: 0.0)
            LandscapeDisplay(
                display: keyModel.currentDisplay,
                showOrange: brainModel.isCopying || brainModel.isPasting,
                disabledScrolling: !isZoomed,
                scrollViewHasScrolled: $scrollViewHasScrolled,
                offsetToVerticallyAlignTextWithkeyboard: screen.offsetToVerticallyAlignTextWithkeyboard,
                scrollViewID: scrollViewID
            )
            Icons(
                store: store,
                brainModel: brainModel,
                keyModel: keyModel,
                screen: screen,
                isZoomed: $isZoomed)
            .offset(y: screen.offsetToVerticallyIconWithText)
        }
    }
    
    var landscapeView: some View {
        MyNavigation {
            landscapeDisplayAndIcons
            .overlay() {
                landscapeKeyboardPlusStuff
            }
        }
        .accentColor(.white) // for the navigation back button
    }
    
    @ViewBuilder
    var content: some View {
        if screen.isPortraitPhone {
            portraitView
        } else {
            landscapeView
        }
    }
    
    
    var body: some View {
      //let _ = print("Calculator body keyModel isPortraitPhone", screen.isPortraitPhone)
        content
        .padding(.bottom, screen.bottomPadding)
        .padding(.horizontal, screen.horizontalPadding)
        .preferredColorScheme(.dark)
        .onAppear() {
            keyModel.keyPressResponder = brainModel
            Task {
                await keyModel.refreshDisplay(screen: screen)
            }
        }
        .onChange(of: screen) { newScreen in /// e.g., rotation
            Task {
                await keyModel.refreshDisplay(screen: newScreen)
            }
        }
    }
}



extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
