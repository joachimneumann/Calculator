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
                Spacer()
                PortraitDisplay(
                    displayData: model.displayData,
                    screenInfo: model.screenInfo,
                    lengths: model.lengths)
                NonScientificKeyboard(
                    model: model,
                    spacing: model.screenInfo.keySpacing,
                    keySize: model.screenInfo.keySize)
            }
        } else {
            NavigationStack {
                /*
                 lowest level: longDisplay and Icons
                 mid level: Keyboard with info and rectangle on top
                 top level: single line
                 */
                HStack(alignment: .top, spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    ScrollView(.vertical) {
                        Text(model.displayData.left)
                            .kerning(C.kerning)
                            .font(Font(model.screenInfo.uiFont))
                            .foregroundColor(model.isCopying || model.isPasting || !model.copyDone || !model.pasteDone ? .orange : .white)
                            .multilineTextAlignment(.trailing)
                            .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
                            .lineLimit(nil)
                            .offset(y: model.offsetToVerticallyAlignTextWithkeyboard)
                    }
                    .id(model.scrollViewID)
                    .disabled(!model.screenInfo.isPad && model.screenInfo.isPortraitPhone && !model.isZoomed)
                    if model.displayData.right != nil {
                        Text(model.displayData.right!)
                            .kerning(C.kerning)
                            .font(Font(model.screenInfo.uiFont))
                            .foregroundColor(model.isCopying || model.isPasting || !model.copyDone || !model.pasteDone ? .orange : .white)
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
                    if !model.isZoomed {
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
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            .accentColor(.white) // for the navigation back button
            .onChange(of: model.lengths.withoutComma) { _ in
                model.updateDisplayData() // redraw with or without keyboard
            }
//            .onChange(of: model.isZoomed) { _ in
//                // print("Calculator: isZoomed: \(model.isZoomed)")
//                model.showAsInteger = false
//                model.showAsFloat = false
//                withAnimation() {
//                    scrollViewID = UUID()
//                }
//            }
        }
    }
}


extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
