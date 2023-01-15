//
//  Calculator.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

let testColors = false

struct Calculator: View {
    @StateObject private var viewModel: ViewModel = ViewModel()

    @ObservedObject var screen: Screen
    @State var scrollViewHasScrolled = false
    @State var scrollViewID = UUID()
    @State var isZoomed: Bool = false
    
    var store = Store()
    
    var portraitView: some View {
        VStack(spacing: 0.0) {
            Spacer(minLength: 0.0)
            PortraitDisplay(display: viewModel.currentDisplay)
                .padding(.bottom, screen.portraitIPhoneDisplayBottomPadding)
                .padding(.horizontal, screen.portraitIPhoneDisplayHorizontalPadding)
            NonScientificKeyboard(
                screen: screen,
                viewModel: viewModel)
        }
    }
    
    var landscapeKeyboard: some View {
        HStack(spacing: 0.0) {
            ScientificKeyboard(
                screen: screen,
                viewModel: viewModel)
            .padding(.trailing, screen.keySpacing)
            NonScientificKeyboard(
                screen: screen,
                viewModel: viewModel)
        }
        .background(Color.black) /// this hides the Icons
    }
    
    var infoView: some View {
        HStack(spacing: 0.0) {
            let info = "\(viewModel.showPrecision ? "Precision: "+viewModel.precisionDescription+" digits" : "\(viewModel.rad ? "Rad" : "")")"
            Text(info)
                .foregroundColor(.white)
                .font(Font(screen.infoUiFont))
                .accessibilityIdentifier("infoText")
            Spacer()
        }
        .padding(.leading, screen.keySize.width * 0.3)
    }
    
    var landscapeKeyboardPlusStuff: some View {
        return VStack(spacing: 0.0) {
            Spacer(minLength: 0.0)
            Rectangle()
                .foregroundColor(.black)
                .frame(height: screen.infoTextHeight)
                .overlay() {
                    infoView
                }
            landscapeKeyboard
        }
        .offset(y: isZoomed ? screen.keyboardHeight + screen.keySize.height : 0.0)
        .animation(.linear, value: isZoomed)
    }
    
    var landscapeDisplayAndIcons: some View {
        HStack(alignment: .top, spacing: 0.0) {
            Spacer(minLength: 0.0)
            LandscapeDisplay(
                display: viewModel.currentDisplay,
                showOrange: viewModel.isCopying || viewModel.isPasting,
                disabledScrolling: !isZoomed,
                scrollViewHasScrolled: $scrollViewHasScrolled,
                offsetToVerticallyAlignTextWithkeyboard: screen.offsetToVerticallyAlignTextWithkeyboard,
                scrollViewID: scrollViewID
            )
            .onChange(of: isZoomed) { _ in
                if scrollViewHasScrolled {
                    withAnimation(.linear(duration: 0.4)) {
                        scrollViewID = UUID()
                    }
                }
            }
            Icons(
                store: store,
                viewModel: viewModel,
                screen: screen,
                isZoomed: $isZoomed)
            .offset(y: screen.offsetToVerticallyIconWithText)
        }
    }
    
    var landscapeView: some View {
        FlexibleNavigation {
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
        //let _ = print("Calculator body isPortraitPhone", screen.isPortraitPhone)
        content
            .padding(.bottom, screen.bottomPadding)
            .padding(.horizontal, screen.horizontalPadding)
            .preferredColorScheme(.dark)
            .onAppear() {
                Task {
                    await viewModel.refreshDisplay(screen: screen)
                }
            }
            .onChange(of: screen) { newScreen in /// e.g., rotation
                Task {
                    await viewModel.refreshDisplay(screen: newScreen)
                }
            }
    }
}

