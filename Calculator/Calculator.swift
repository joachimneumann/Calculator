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
                            .foregroundColor(.white)
                            .multilineTextAlignment(.trailing)
                            .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
                            .lineLimit(nil)
                            .offset(y: model.offsetToVerticallyAlignTextWithkeyboard)
                    }
                    if model.displayData.right != nil {
                        Text(model.displayData.right!)
                            .kerning(C.kerning)
                            .font(Font(model.screenInfo.uiFont))
                            .foregroundColor(.white)
                            .padding(.leading, model.screenInfo.ePadding)
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
                                .foregroundColor(.cyan)
                                .frame(height: model.lengths.infoHeight)
                                .overlay() {
                                    let info = "\(model.hasBeenReset ? "Precision: "+model.precisionDescription+" digits" : "\(Model.rad ? "Rad" : "")")"
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
        }
    }
}

/*
 NavigationStack {
     Group() {
         } else {
             /// Landscape phone or iPad
             HStack(alignment: .top, spacing: 0.0) {
                 LandscapeDisplay(
                     isZoomed: isZoomed,
                     displayData: model.displayData,
                     displayHeight: model.lengths.height,
                     screenInfo: screenInfo)
                 .offset(y: screenInfo.offsetToVerticallyAlignTextWithkeyboard)
                 Icons(
                     store: store,
                     model: model,
                     screenInfo: screenInfo,
                     isCalculating: model.isCalculating,
                     isZoomed: $isZoomed)
                 .padding(.leading, screenInfo.plusIconLeftPadding)
                 .offset(y: screenInfo.offsetToVerticallyIconWithText)
             }
         }
     }
     .onChange(of: model.lengths.withoutComma) { _ in
         model.updateDisplayData() // redraw with or without keyboard
     }
     .defersSystemGestures(on: .all)
     .overlay() {
         if !model.hideKeyboard && (screenInfo.isPortraitPhone || !isZoomed) {
             VStack(spacing: 0.0) {
                 Spacer(minLength: 0.0)
                 Keyboard(model: model, isScientific: !screenInfo.isPortraitPhone, keySize: screenInfo.keySize, spacing: screenInfo.keySpacing)
                 .background(.black)//.opacity(0.1)//testColors ? .clear : .clear)
                 .overlay() {
                     VStack(spacing: 0.0) {
                         Spacer(minLength: 0.0)
                         let info = "\(model.hasBeenReset ? "Precision: "+model.precisionDescription+" digits" : "\(Model.rad ? "Rad" : "")")"
                         if !screenInfo.isPortraitPhone && info.count > 0 {
                             HStack(spacing: 0.0) {
                                 Text(info)
                                     .foregroundColor(.white)
                                     .font(Font(screenInfo.infoUiFont))
                                 Spacer()
                             }
                             .offset(x: screenInfo.keySpacing, y: -screenInfo.keyboardHeight)
                             //                        .offset(x: keySize * 0.02, y: infoFontSize * -0.2 + size.height * -0.5 - uiFont.capHeight - uiFont.descender)
                         }
                     }
                 }
             }
             .transition(.move(edge: .bottom))
         }
     }
 }
 .accentColor(.white) // for the navigation back button
}
 */
//struct Calculator_Previews: PreviewProvider {
//    static var previews: some View {
//        let model = Model()
//        let _ = model.pressed("π")
//        Calculator(
//            model: model,
//            screenInfo:ScreenInfo (
//                hardwareSize: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height),
//                insets: UIEdgeInsets(),
//                appOrientation: .landscapeLeft,
//                model: model))
//        .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (3rd generation)"))
//        .previewDisplayName("iPad")
//        //        .preferredColorScheme(.dark)
//        Calculator(
//            model: model,
//            screenInfo:ScreenInfo(
//                hardwareSize: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height),
//                insets: UIEdgeInsets(),
//                appOrientation: .landscapeLeft,
//                model: model))
//        .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
//        .previewDisplayName("iPhone")
        //        .preferredColorScheme(.dark)
//    }
//}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
