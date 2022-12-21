//
//  Calculator.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

let testColors = false

struct Calculator: View {
    @ObservedObject var model: Model
    @StateObject var store = Store()

    var body: some View {
        // let _ = print("Calculator: isPortraitPhone \(model.screenInfo.isPortraitPhone) size \(model.screenInfo.calculatorSize)")
        // let _ = print("model.displayData.left \(model.displayData.left)")
        if model.screenInfo.isPortraitPhone {
            VStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                if model.displayData.preliminary {
                    let dotDiamater = model.screenInfo.calculatorSize.width * 0.05
                    HStack(spacing: 0.0) {
                        Spacer()
                        AnimatedDots(dotDiamater: dotDiamater)
                    }
                    .padding(.bottom, dotDiamater)
                }
                PortraitDisplay(
                    displayData: model.displayData,
                    screenInfo: model.screenInfo,
                    lengths: model.lengths)
                .padding(.horizontal, model.screenInfo.portraitIPhoneDisplayHorizontalPadding)
                .padding(.bottom, model.screenInfo.portraitIPhoneDisplayBottomPadding)
                NonScientificKeyboard(
                    model: model,
                    spacing: model.screenInfo.keySpacing,
                    keySize: model.screenInfo.keySize)
            }
            .padding(.horizontal, model.screenInfo.portraitIPhoneHorizontalPadding)
            .padding(.bottom, model.screenInfo.portraitIPhoneBottomPadding)
        } else {
            NavigationStack {
                /*
                 lowest level: longDisplay and Icons
                 mid level: Keyboard with info and rectangle on top
                 top level: single line
                 */
                let color: Color = (model.isCopying || model.isPasting || !model.copyDone || !model.pasteDone) ? .orange : (model.displayData.preliminary ? .gray : .white)
                HStack(alignment: .top, spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    ScrollViewConditionalAnimation(
                        text: model.displayData.left,
                        font: Font(model.screenInfo.uiFont),
                        foregroundColor: color,
                        backgroundColor: testColors ? .yellow : .black,
                        offsetY: model.offsetToVerticallyAlignTextWithkeyboard,
                        disabled: !model.isZoomed,
                        scrollViewHasScolled: $model.scrollViewHasScrolled,
                        scrollViewID: model.scrollViewID)
                    if model.displayData.right != nil {
                        Text(model.displayData.right!)
                            .kerning(C.kerning)
                            .font(Font(model.screenInfo.uiFont))
                            .foregroundColor(color)
                            .padding(.leading, model.screenInfo.ePadding)
                        .offset(y: model.offsetToVerticallyAlignTextWithkeyboard)
                    }
                    Icons(
                        store: store,
                        model: model,
                        screenInfo: model.screenInfo,
                        isCalculating: model.isCalculating,
                        isZoomed: $model.isZoomed)
                    .padding(.leading, model.screenInfo.plusIconLeftPadding)
                    .offset(y: model.offsetToVerticallyIconWithText)
                }
                .overlay() {
                    VStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        Rectangle()
                            .foregroundColor(.black)
                            .frame(height: model.lengths.infoHeight)
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
                            ScientificBoard(model: model, spacing: model.screenInfo.keySpacing, keySize: model.screenInfo.keySize)
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
            .onChange(of: model.lengths.withoutComma) { _ in
                model.updateDisplayData() // redraw with or without keyboard
            }
        }
    }
}


extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
