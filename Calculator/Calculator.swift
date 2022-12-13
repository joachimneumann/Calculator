//
//  Calculator.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

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
    @State private var isShowingDetailView = false
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

struct KeysViewAndInfo: View {
    let hasBeenReset: Bool
    let precisionDescription: String
    let rad: Bool
    let isPortrait: Bool
    let keyHeight: CGFloat
    let model: Model
    let keyboardSize: CGSize
    let isZoomed: Bool
    let size: CGSize
    var body: some View {
        let info = "\(hasBeenReset ? "Precision: "+precisionDescription+" digits" : "\(rad ? "Rad" : "")")"
        VStack(spacing: 0.0) {
            Spacer()
            if !isPortrait {
                HStack(spacing: 0.0) {
                    Text(info).foregroundColor(.white)
                        .offset(x: keyHeight * 0.3, y: keyHeight * -0.05)
                    Spacer()
                }
            }
            KeysView(model: model, isScientific: !isPortrait, size: keyboardSize)
        }
//        .transition(.move(edge: .bottom))
        .offset(y: (isZoomed && !isPortrait) ? size.height : 0)
    }
}

struct Calculator_Previews: PreviewProvider {
    static var previews: some View {
        let model = Model()
        Calculator(
            model: model,
            screenInfo: ScreenInfo(hardwareSize: UIScreen.main.bounds.size, insets: UIEdgeInsets(), appOrientation: .portrait, model: model))
            .background(Color.black)
    }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
