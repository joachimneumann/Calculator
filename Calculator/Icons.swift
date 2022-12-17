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
        VStack(alignment: .trailing, spacing: 0.0) {
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
                    .padding(.leading, screenInfo.plusIconLeftPadding - 1) // the "- 1" stops the app from drawing into the safearea ?!?
                    .onTapGesture {
                        withAnimation(.linear(duration: 0.3)) {
                            isZoomed.toggle()
                        }
                    }
                    .offset(y: screenInfo.offsetToVerticallyIconWithText)
                Group {
                    NavigationLink {
                        Settings(model: model)
                    } label: {
                        Image(systemName: "switch.2")
                            .resizable()
                            .scaledToFit()
                            .font(.system(size: screenInfo.plusIconSize, weight: .thin))
                            .frame(width: screenInfo.plusIconSize, height: screenInfo.plusIconSize)
                            .foregroundColor(Color(UIColor(white: 0.9, alpha: 1.0)))
                    }
                    .padding(.top, screenInfo.plusIconSize * 0.5)
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
                .padding(.top, screenInfo.plusIconSize * 0.5)
                .frame(width: screenInfo.plusIconSize, height: screenInfo.plusIconSize)
                .minimumScaleFactor(0.01)
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
