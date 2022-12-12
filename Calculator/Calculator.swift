//
//  Calculator.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct Calculator: View {
    @StateObject var store = Store()
    @StateObject var model: Model
    let isPad: Bool
    var isPortrait: Bool
    let size: CGSize
    
    var keyboardSize: CGSize
    var keyHeight: CGFloat
    var singleLineFontSize: CGFloat
    let displayTrailingOffset: CGFloat
    let displayBottomOffset: CGFloat
    let keyboardPaddingBottom: CGFloat
    @State var isZoomed: Bool = false
    
    var body: some View {
        let _ = print("Calculator body")
        NavigationStack {
            Rectangle()
                .overlay() {
                    Display(isPortrait: isPortrait,
                            isZoomed: isZoomed,
                            displayData: model.displayData,
                            lengths: model.lengths,
                            singleLineFontSize: singleLineFontSize,
                            displayWidth: model.displayWidth,
                            height: keyboardSize.height,
                            displayTrailingOffset: displayTrailingOffset,
                            displayBottomOffset: displayBottomOffset)
                }
            
                .overlay() { /// Icons
                    Icons(store: store,
                          model: model,
                          isPortrait: isPortrait,
                          height: keyboardSize.height,
                          isCalculating: model.isCalculating,
                          isZoomed: $isZoomed,
                          keyInfo: model.keyInfo["plusKey"]!)
                }
            
                .overlay() { /// keyboard
                    KeysViewAndText(hasBeenReset: model._hasBeenReset,
                                    precisionDescription: model.precisionDescription,
                                    rad: Model._rad,
                                    isPortrait: isPortrait,
                                    keyHeight: keyHeight,
                                    model: model,
                                    keyboardSize: keyboardSize,
                                    isZoomed: isZoomed,
                                    size: size)
                }
                .background(Color.black)
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
    let displayWidth: CGFloat
    let height: CGFloat
    let displayTrailingOffset: CGFloat
    let displayBottomOffset: CGFloat
    var body: some View {
        VStack(spacing: 0.0) {
            if isPortrait {
                PortraitDisplay(
                    displayData: displayData,
                    fullLength: displayData.short.count == lengths.withoutComma,
                    ePadding: lengths.ePadding,
                    smallFont: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize, weight: .thin)),
                    largeFont: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize * 1.5, weight: .thin)),
                    fontScaleFactor: 1.5,
                    displayWidth: displayWidth)
                //.background(Color.yellow)
                .padding(.bottom, height)
                //                        .offset(y: displayYOffset)
            } else {
                HStack(spacing: 0.0) {
                    LandscapeDisplay(
                        zoomed: isZoomed,
                        displayData: displayData,
                        ePadding: lengths.ePadding,
                        font: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize, weight: .thin)),
                        isCopyingOrPasting: false,
                        precisionString: "Model.precision.useWords",
                        displayWidth: displayWidth)
                    .offset(x: -displayTrailingOffset, y: displayBottomOffset)
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
                        if isZoomed {
                            NavigationLink {
                                Settings(model: model)
                            } label: {
                                Image(systemName: "switch.2")
                                    .resizable()
                                    .scaledToFit()
                                    .font(.system(size: height, weight: .thin))
                                    .frame(width: size, height: size)
                                    .foregroundColor(Color(uiColor: UIColor(white: 0.9, alpha: 1.0)))
                            }
                            .padding(.top, size * 0.5)
                            Group {
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
                                        Text("copy")
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
                            .padding(.top, size * 0.5)
                            .frame(width: size, height: size)
                            .minimumScaleFactor(0.01)
                        }
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

struct KeysViewAndText: View {
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
        .transition(.move(edge: .bottom))
        .offset(y: (isZoomed && !isPortrait) ? size.height : 0)
    }
}

//struct Calculator_Previews: PreviewProvider {
//    static var previews: some View {
//        Calculator(isPad: false, isPortrait: true, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//            .background(Color.black)
//    }
//}
