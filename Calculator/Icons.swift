//
//  Icons.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/17/22.
//

import SwiftUI

struct Icons : View {
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
                    if store.purchasedIDs.isEmpty {
                        NavigationLink {
                            PurchaseView(store: store, model: model, font: Font(screenInfo.infoUiFont))
                        } label: {
                            Text("copy")
                                .font(Font(screenInfo.infoUiFont))
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
                                .font(Font(screenInfo.infoUiFont))
                                .foregroundColor(.white)
                        }
                    }
                    
                    if store.purchasedIDs.isEmpty {
                        NavigationLink {
                            PurchaseView(store: store, model: model, font: Font(screenInfo.infoUiFont))
                        } label: {
                            Text("paste")
                                .font(Font(screenInfo.infoUiFont))
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
                                .font(Font(screenInfo.infoUiFont))
                                .foregroundColor(pasteAllowedState ? .white : .gray)
                        }
                        .disabled(!pasteAllowedState)
                    }

                    NavigationLink {
                        Settings(model: model, font: Font(screenInfo.infoUiFont))
                    } label: {
                        Text("0.00…")
                            .font(Font(screenInfo.infoUiFont))
                            .foregroundColor(.white)
                    }

                    Button {
                        Model.forceScientific = !Model.forceScientific
                        model.haveResultCallback()
                    } label: {
                        HStack(spacing: 0.0) {
                            Text("EE ")
                                .font(Font(screenInfo.infoUiFont))
                                .foregroundColor(.white)
                            Text(Model.forceScientific ? "!" : "?")
                                .font(Font(screenInfo.infoUiFont)).monospaced()
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.top, screenInfo.plusIconSize * 0.5)
                .minimumScaleFactor(0.01) // in case "paste" is too wide on small phones
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
