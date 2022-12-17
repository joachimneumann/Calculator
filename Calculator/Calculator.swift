//
//  Calculator.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

let testColors = false

struct Calculator: View {
    @StateObject var model: Model
    @StateObject var store = Store()
    var screenInfo: ScreenInfo
    
    @State private var isZoomed = false
    
    var body: some View {
        // let _ = print("Calculator() model.lengths \(model.lengths)")
        NavigationStack {
            Group() {
                if screenInfo.isPortraitPhone {
                    VStack(alignment: .trailing, spacing: 0.0) {
                        Spacer()
                        PortraitDisplay(
                            displayData: model.displayData,
                            screenInfo: screenInfo,
                            lengths: model.lengths)
                        //.background(Color.yellow)
                        .offset(y: -screenInfo.keyboardHeight)
                    }
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
}

struct Calculator_Previews: PreviewProvider {
    static var previews: some View {
        let model = Model()
        let _ = model.pressed("π")
        Calculator(
            model: model,
            screenInfo:ScreenInfo (
                hardwareSize: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height),
                insets: UIEdgeInsets(),
                appOrientation: .landscapeLeft,
                model: model))
        .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (3rd generation)"))
        .previewDisplayName("iPad")
        //        .preferredColorScheme(.dark)
        Calculator(
            model: model,
            screenInfo:ScreenInfo(
                hardwareSize: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height),
                insets: UIEdgeInsets(),
                appOrientation: .landscapeLeft,
                model: model))
        .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
        .previewDisplayName("iPhone")
        //        .preferredColorScheme(.dark)
    }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
