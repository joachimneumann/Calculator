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
        Group {
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
                }
            }
        }
        .onChange(of: model.lengths.withoutComma) { _ in
            model.updateDisplayData()
        }
        .overlay() {
            VStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                if !isZoomed {
                    KeyboardAndInfo(hasBeenReset: model.hasBeenReset,
                                    precisionDescription: model.precisionDescription,
                                    rad: Model._rad,
                                    isPortrait: screenInfo.isPortraitPhone,
                                    model: model,
                                    infoUiFont: screenInfo.infoUiFont,
                                    isZoomed: isZoomed,
                                    keySize: screenInfo.keySize,
                                    spacing: screenInfo.keySpacing)
                    .frame(width: screenInfo.calculatorSize.width, height: screenInfo.keyboardHeight)
                    .background(.black)//.opacity(0.1)//testColors ? .clear : .clear)
                }
            }
        }
        
        //        VStack(spacing: 0.0) {
        //            Spacer()
        //            HStack(alignment: .bottom, spacing: 0.0) {
        //                Spacer(minLength: 0.0)
        //                ZStack(alignment: .top) {
        //                    //                    VStack(alignment: .trailing, spacing: 0.0) {
        ////                    Text(model.displayData.shortLeft)
        ////                        .kerning(C.kerning)
        ////                        .font(font)
        ////                        .foregroundColor(.white)
        ////                    // .frame(width: screenInfo.calculatorSize.width - screenInfo.plusIconSize - screenInfo.plusIconLeftPadding)
        ////                        .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
        ////                        .offset(y: offsetToVerticallyAlignTextWithIcon)
        ////                        .lineLimit(1)
        ////                        .hidden(isZoomed)
        //                    Text(model.displayData.longLeft)
        //                        .kerning(C.kerning)
        //                        .font(font)
        //                        .foregroundColor(.white)
        ////                     .frame(width: screenInfo.calculatorSize.width - screenInfo.plusIconSize - screenInfo.plusIconLeftPadding, height: .infinity)
        //                        .multilineTextAlignment(.trailing)
        //                        .background(testColors ? .yellow : .black).opacity(testColors ? 0.9 : 1.0)
        //                        .offset(y: offsetToVerticallyAlignTextWithIcon)
        //                        .lineLimit(nil)
        //                    //                    }
        //                }
        //                //                .background(Color.blue)
        //                Image(systemName: "plus.circle.fill")
        //                    .resizable()
        //                    .font(Font.title.weight(.thin))
        //                    .rotationEffect(isZoomed ? .degrees(-45.0) : .degrees(0.0))
        //                    .frame(width: screenInfo.plusIconSize, height: screenInfo.plusIconSize)
        //                    .background(.white)
        //                    .foregroundColor(.gray)
        //                    .clipShape(Circle())
        //                    .padding(.leading, screenInfo.plusIconLeftPadding)
        //                    .onTapGesture {
        //                        withAnimation(.linear(duration: 0.4)) {
        //                            isZoomed.toggle()
        //                        }
        //                    }
        //            }
        //
        //            if !isZoomed {
        //                KeyboardAndInfo(hasBeenReset: model.hasBeenReset,
        //                                precisionDescription: model.precisionDescription,
        //                                rad: Model._rad,
        //                                isPortrait: screenInfo.isPortraitPhone,
        //                                model: model,
        //                                infoFontSize: screenInfo.singleLineFontSize * 0.35,
        //                                isZoomed: isZoomed,
        //                                keySize: screenInfo.keySize,
        //                                spacing: screenInfo.keySpacing)
        //                .frame(width: screenInfo.calculatorSize.width, height: screenInfo.keyboardHeight)
        //                .background(testColors ? .clear : .clear)
        //            }
        //            //            .hidden(isZoomed)
        //            /// optional rectangle to cover the first line of the long text
        //            //                .overlay() {
        //            //                    Rectangle()
        //            //                        .frame(width: size.width, height: iconSize)
        //            //                        .background(Color.brown).opacity(0.5)
        //            //                        .offset(y: -keyBoardHeight / 2 + iconSize / 2)
        //            //                }
        //        }
        //        //        .frame(width: screenInfo.calculatorSize.width, height: screenInfo.calculatorSize.height)
        //        //        .onChange(of: model.lengths.withoutComma) { _ in
        //        //            model.updateDisplayData()
        //        //        }
    }
}

/*
 
 struct Calculator: View {
 @StateObject var model: Model
 let screenInfo: ScreenInfo
 
 @StateObject var store = Store()
 @State var isZoomed: Bool = false
 
 var body: some View {
 //let _ = print("Calculator body")
 NavigationStack {
 Rectangle()
 .overlay() {
 Display(isPortrait: screenInfo.isPortrait,
 isZoomed: isZoomed,
 displayData: model.displayData,
 lengths: model.lengths,
 singleLineFontSize: screenInfo.singleLineFontSize,
 height: screenInfo.keyboardSize.height,
 width: screenInfo.displayWidth,
 displayTrailingOffset: screenInfo.displayTrailingOffset,
 displayOffset: screenInfo.displayOffset)
 .onChange(of: model.lengths.withoutComma) { _ in
 model.updateDisplayData()
 }
 .background(C.appBackground)
 }
 
 .overlay() { /// Icons
 Icons(store: store,
 model: model,
 isPortrait: screenInfo.isPortrait,
 height: screenInfo.keyboardSize.height,
 isCalculating: model.isCalculating,
 isZoomed: $isZoomed,
 keyInfo: model.keyInfo["plusKey"]!)
 .offset(y: isZoomed ? 0.0 : screenInfo.displayOffset)
 }
 
 .overlay() { /// keyboard
 KeysViewAndInfo(hasBeenReset: model.hasBeenReset,
 precisionDescription: model.precisionDescription,
 rad: Model._rad,
 isPortrait: screenInfo.isPortrait,
 keyHeight: screenInfo.keyHeight,
 model: model,
 keyboardSize: screenInfo.keyboardSize,
 isZoomed: isZoomed,
 size: screenInfo.calculatorSize)
 //                    .background(C.appBackground)
 }
 }
 .accentColor(.white) // for the navigation back button
 .onAppear() {
 Task {
 // print("Calculator requestProducts()")
 await store.requestProducts()
 // print("Calculator done")
 }
 }
 }
 }
 
 struct Display: View {
 let isPortrait: Bool
 let isZoomed: Bool
 let displayData: DisplayData
 let lengths: Lengths
 let singleLineFontSize: CGFloat
 let height: CGFloat
 let width: CGFloat
 let displayTrailingOffset: CGFloat
 let displayOffset: CGFloat
 var body: some View {
 VStack(spacing: 0.0) {
 //let _ = print("displayData l.left \(displayData.longLeft)")
 if isPortrait {
 PortraitDisplay(
 displayData: displayData,
 forceSmallFont: displayData.short.count == lengths.withoutComma,
 ePadding: lengths.ePadding,
 smallFont: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize, weight: C.fontWeight)),
 largeFont: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize * 1.5, weight: C.fontWeight)),
 fontScaleFactor: 1.5)
 //.background(Color.yellow)
 .padding(.bottom, height)
 //                .background(Color.blue)
 //                        .offset(y: displayYOffset)
 } else {
 HStack(spacing: 0.0) {
 LandscapeDisplay(
 zoomed: false,//isZoomed,
 displayData: displayData,
 width: width,
 ePadding: lengths.ePadding,
 font: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize, weight: C.fontWeight)),
 isCopyingOrPasting: false,
 precisionString: "Model.precision.useWords")
 .padding(.trailing, displayTrailingOffset)
 .offset(y: isZoomed ? 0.0 : displayOffset)
 //                        .background(Color.green).opacity(0.4)
 .animation(Animation.easeInOut(duration: 0.4), value: isZoomed)
 }
 //.background(Color.yellow)
 Spacer()
 }
 }
 }
 }
 
 struct Icons : View {
 @Environment(\.scenePhase) var scenePhase
 @ObservedObject var store: Store
 @ObservedObject var model: Model
 let isPortrait: Bool
 let height: CGFloat
 let isCalculating: Bool
 @State var pasteAllowedState: Bool = true
 @Binding var isZoomed: Bool
 let keyInfo: Model.KeyInfo
 var body: some View {
 if !isPortrait {
 HStack(spacing: 0.0) {
 Spacer(minLength: 0.0)
 let size = height * 0.13
 VStack(spacing: 0.0) {
 if isCalculating {
 AnimatedDots(color: .gray)
 .padding(.top, size * 0.55)
 .animation(Animation.easeInOut(duration: 0.4), value: isZoomed)
 } else {
 PlusKey(keyInfo: keyInfo, zoomed: $isZoomed, size: CGSize(width: size, height: size))
 .padding(.top, size * 0.25)
 //                                    .offset(y: size * 0.25)
 Group {
 NavigationLink {
 Settings(model: model)
 } label: {
 Image(systemName: "switch.2")
 .resizable()
 .scaledToFit()
 .font(.system(size: height, weight: .thin))
 .frame(width: size, height: size)
 .foregroundColor(Color(UIColor(white: 0.9, alpha: 1.0)))
 .hidden(!isZoomed)
 }
 .padding(.top, size * 0.5)
 if store.purchasedIDs.isEmpty {
 NavigationLink {
 PurchaseView(store: store)
 } label: {
 Text("copy")
 .foregroundColor(.white)
 }
 } else {
 Button {
 model.toPastBin()
 DispatchQueue.main.async {
 pasteAllowedState = true
 }
 } label: {
 Text("copy")
 .foregroundColor(.white)
 }
 }
 
 if store.purchasedIDs.isEmpty {
 NavigationLink {
 PurchaseView(store: store)
 } label: {
 Text("paste")
 .foregroundColor(.white)
 }
 } else {
 Button {
 if store.purchasedIDs.isEmpty {
 
 } else {
 DispatchQueue.main.async {
 pasteAllowedState = model.checkIfPasteBinIsValidNumber()
 }
 /// this logic postpones the diplay of the "allow paste" to the user until the user actually presses paste
 if pasteAllowedState {
 model.fromPastBin()
 }
 }
 } label: {
 Text("paste")
 .foregroundColor(pasteAllowedState ? .white : .gray)
 }
 .disabled(!pasteAllowedState)
 }
 }
 .hidden(!isZoomed)
 .padding(.top, size * 0.5)
 .frame(width: size, height: size)
 .minimumScaleFactor(0.01)
 }
 Spacer(minLength: 0.0)
 }
 }
 .onChange(of: scenePhase) { newPhase in
 if newPhase == .active {
 DispatchQueue.main.async {
 if pasteAllowedState == false {
 /// this can only happen after the popup
 pasteAllowedState = model.checkIfPasteBinIsValidNumber()
 }
 }
 }
 }
 }
 }
 }
 
 
 */

struct KeyboardAndInfo: View {
    let hasBeenReset: Bool
    let precisionDescription: String
    let rad: Bool
    let isPortrait: Bool
    let model: Model
    let infoUiFont: UIFont
    let isZoomed: Bool
    let keySize: CGSize
    let spacing: CGFloat
    
    var body: some View {
        let info = "\(hasBeenReset ? "Precision: "+precisionDescription+" digits" : "\(rad ? "Rad" : "")")"
        VStack(spacing: 0.0) {
            Spacer(minLength: 0.0)
            Keyboard(model: model, isScientific: !isPortrait, keySize: keySize, spacing: spacing)
                .overlay() {
                    if !isPortrait && info.count > 0 {
                        HStack(spacing: 0.0) {
                            Text(info)
                                .foregroundColor(.white)
                                .font(Font(infoUiFont))
                            Spacer()
                        }
                        //                        .offset(x: keySize * 0.02, y: infoFontSize * -0.2 + size.height * -0.5 - uiFont.capHeight - uiFont.descender)
                    }
                }
        }
        .transition(.move(edge: .bottom))
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
