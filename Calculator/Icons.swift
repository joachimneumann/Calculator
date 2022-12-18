//
//  Icons.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/17/22.
//

import SwiftUI

struct Icons : View {
    let simulatePurchased = true
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var store: Store
    @ObservedObject var model: Model
    let screenInfo: ScreenInfo
    let isCalculating: Bool
    @State var pasteAllowedState: Bool = true
    @Binding var isZoomed: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            if isCalculating {
                AnimatedDots(color: .gray)
                    .padding(.top, screenInfo.plusIconSize * 0.55)
                    .animation(Animation.easeInOut(duration: 0.4), value: isZoomed)
            } else {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .font(Font.title.weight(.thin))
                    .rotationEffect(isZoomed ? .degrees(-45.0) : .degrees(0.0))
                    .frame(width: screenInfo.plusIconSize, height: screenInfo.plusIconSize)
                    .background(.white)
                    .foregroundColor(.gray)
                    .clipShape(Circle())
                    .onTapGesture {
                        withAnimation(.linear(duration: 0.3)) {
                            isZoomed.toggle()
                        }
                    }
                Group {
                    if !simulatePurchased && store.purchasedIDs.isEmpty {
                        NavigationLink {
                            PurchaseView(store: store, model: model, font: Font(screenInfo.infoUiFont))
                        } label: {
                            Text("copy")
                                .font(Font(screenInfo.infoUiFont))
                                .foregroundColor(.white)
                        }
                    } else {
                        Text("copy")
                            .font(Font(screenInfo.infoUiFont))
                            .foregroundColor(model.isCopying || !model.copyDone ? Color.orange : Color.white)
                            .onTapGesture {
                                if model.copyDone && model.pasteDone {
                                    DispatchQueue.main.async {
                                        model.isCopying = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        model.isCopying = false
                                    }
                                    Task {
                                        DispatchQueue.main.async {
                                            model.copyDone = false
                                            print("model.copyDone \(model.copyDone)")
                                        }
                                        await model.g()
                                        DispatchQueue.main.async {
                                            model.copyDone = true
                                            print("model.copyDone \(model.copyDone)")
                                        }
                                    }
                                }
                            }
                    }
                    if !simulatePurchased && store.purchasedIDs.isEmpty {
                        NavigationLink {
                            PurchaseView(store: store, model: model, font: Font(screenInfo.infoUiFont))
                        } label: {
                            Text("paste")
                                .font(Font(screenInfo.infoUiFont))
                                .foregroundColor(.white)
                        }
                    } else {
                        Text("paste")
                            .font(Font(screenInfo.infoUiFont))
                            .foregroundColor((model.isPasting || !model.pasteDone) ? Color.orange : Color.white)
                            .onTapGesture {
                                if model.copyDone && model.pasteDone {
                                    DispatchQueue.main.async {
                                        model.isPasting = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        model.isPasting = false
                                    }
                                    Task {
                                        DispatchQueue.main.async {
                                            model.pasteDone = false
                                            print("model.pasteDone \(model.pasteDone)")
                                        }
                                        model.fromPastBin()
                                        DispatchQueue.main.async {
                                            model.pasteDone = true
                                            print("model.pasteDone \(model.pasteDone)")
                                        }
                                    }
                                }
                            }
                        //                            DispatchQueue.main.async {
                        //                                pasteAllowedState = model.checkIfPasteBinIsValidNumber()
                        //                            }
                        //                          .disabled(!pasteAllowedState)
                    }
                    
                    NavigationLink {
                        Settings(model: model, font: Font(screenInfo.infoUiFont))
                    } label: {
                        Text("0.0…")
                            .font(Font(screenInfo.infoUiFont))
                            .minimumScaleFactor(0.01)
                            .foregroundColor(.white)
                    }
                    
                    let integerLabel = model.displayData.isInteger ? (model.showAsInteger ? "→ sci" : "→ int") : ""
                    //                    (model.displayData.isFloat ? "→ float" : "")
                    if integerLabel.count > 0 {
                        Button {
                            model.showAsInteger.toggle()
                        } label: {
                            Text(integerLabel)
                                .minimumScaleFactor(0.01)
                                .font(Font(screenInfo.infoUiFont))
                                .foregroundColor(.white)
                        }
                    }
                    
                    let floatLabel = model.displayData.isFloat ? (model.showAsFloat ? "→ sci" : "→ float") : ""
                    if integerLabel.count == 0 && floatLabel.count > 0 {
                        Button {
                            model.showAsFloat.toggle()
                        } label: {
                            Text(floatLabel)
                                .minimumScaleFactor(0.01)
                                .font(Font(screenInfo.infoUiFont))
                                .foregroundColor(.white)
                        }
                    }
                    
                }
                .padding(.top, screenInfo.plusIconSize * 0.5)
                .lineLimit(1)
                .minimumScaleFactor(0.01) // in case "paste" is too wide on small phones
                .frame(width: model.screenInfo.plusIconSize + model.screenInfo.plusIconLeftPadding)
            }
            Spacer(minLength: 0.0)
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
//struct Icons_Previews: PreviewProvider {
//    static var previews: some View {
//        Icons()
//    }
//}
