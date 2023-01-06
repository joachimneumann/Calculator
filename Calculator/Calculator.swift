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
    
    var body: some View {
      //let _ = print("Calculator body keyModel isPortraitPhone", screen.isPortraitPhone)
        ZStack {
            if screen.isPortraitPhone {
                VStack(spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    PortraitDisplay(display: keyModel.currentDisplay)
                        .padding(.bottom, screen.portraitIPhoneDisplayBottomPadding)
                        .padding(.horizontal, screen.portraitIPhoneDisplayHorizontalPadding)
                    NonScientificKeyboard(
                        screen: screen,
                        keyModel: keyModel)
                }
//                .background(Color.red)
                .padding(.bottom, screen.bottomPadding)
            } else {
                MyNavigation {
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
                                    screen: screen,
                                    keyModel: keyModel)
                                .padding(.trailing, screen.keySpacing)
                                NonScientificKeyboard(
                                    screen: screen,
                                    keyModel: keyModel)
                            }
                            .background(Color.black)
                        }
                        .offset(y: isZoomed ? screen.keyboardHeight + screen.keySize.height : 0.0)
                        .transition(.move(edge: .bottom))
                    }
                }
                .accentColor(.white) // for the navigation back button
            }
        }
        .padding(.horizontal, screen.horizontalPadding)
        .preferredColorScheme(.dark)
        .onAppear() {
            if keyModel.keyPressResponder == nil {
                keyModel.keyPressResponder = brainModel
            }
            Task {
                await keyModel.refreshDisplay(screen: screen)
            }
//            print("Calculator onAppear", keyModel.keyPressResponder)
        }
        .onChange(of: screen) { newScreen in
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
