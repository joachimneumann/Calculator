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
    @State var pasteAllowedState: Bool = true
    @Binding var isZoomed: Bool
    @State var copyDone = true
    @State var pasteDone = true
    
    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .font(Font.title.weight(.thin))
                .rotationEffect(isZoomed ? .degrees(-45.0) : .degrees(0.0))
                .frame(width: screenInfo.plusIconSize, height: screenInfo.plusIconSize)
                .background(.white)
                .foregroundColor(.gray)
                .clipShape(Circle())
                .onTapGesture {
                    withAnimation(.linear(duration: 0.4)) {
                        isZoomed.toggle()
                    }
                }
            if !model.isCalculating {
                if !model.display.format.showThreeDots {
                    Group {
                        if !simulatePurchased && store.purchasedIDs.isEmpty {
                            NavigationLink {
                                PurchaseView(store: store, model: model, font: Font(screenInfo.infoUiFont))
                            } label: {
                                Text("copy")
                                    .font(Font(screenInfo.infoUiFont))
                                    .foregroundColor(Color.white)
                            }
                        } else {
                            Text("copy")
                                .font(Font(screenInfo.infoUiFont))
                                .foregroundColor(model.isCopying || !copyDone ? Color.orange : Color.white)
                                .onTapGesture {
                                    if copyDone && pasteDone {
                                        DispatchQueue.main.async {
                                            model.isCopying = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            model.isCopying = false
                                        }
                                        Task {
                                            DispatchQueue.main.async {
                                                copyDone = false
                                                //print("copyDone \(copyDone)")
                                            }
                                            await model.copyToPastBin()
                                            DispatchQueue.main.async {
                                                copyDone = true
                                                //print("copyDone \(copyDone)")
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
                                    .foregroundColor(Color.white)
                            }
                        } else {
                            Text("paste")
                                .font(Font(screenInfo.infoUiFont))
                                .foregroundColor((model.isPasting || !pasteDone) ? Color.orange : Color.white)
                                .onTapGesture {
                                    if copyDone && pasteDone {
                                        DispatchQueue.main.async {
                                            model.isPasting = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            model.isPasting = false
                                        }
                                        Task {
                                            DispatchQueue.main.async {
                                                pasteDone = false
                                                //print("pasteDone \(pasteDone)")
                                            }
                                            model.fromPastBin()
                                            DispatchQueue.main.async {
                                                pasteDone = true
                                                //print("pasteDone \(pasteDone)")
                                            }
                                        }
                                    }
                                }
                        }
                        
                        NavigationLink {
                            Settings(model: model, font: Font(screenInfo.infoUiFont))
                        } label: {
                            Image(systemName: "gearshape")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .font(Font.title.weight(.thin))
                                .frame(height: screenInfo.plusIconSize * 0.6)
                                .foregroundColor(Color.white)
                        }
                        
                        let integerLabel = model.display.data.canBeInteger ? (model.showAsInteger ? "→ sci" : "→ int") : ""
                        if integerLabel.count > 0 {
                            Button {
                                model.showAsInteger.toggle()
                                model.updateDisplayData()
                            } label: {
                                Text(integerLabel)
                                    .font(Font(screenInfo.infoUiFont))
                                    .foregroundColor(Color.white)
                            }
                        }
                        
                        let floatLabel = model.display.data.canBeFloat ? (model.showAsFloat ? "→ sci" : "→ float") : ""
                        if integerLabel.count == 0 && floatLabel.count > 0 {
                            Button {
                                model.showAsFloat.toggle()
                                model.updateDisplayData()
                            } label: {
                                Text(floatLabel)
                                    .font(Font(screenInfo.infoUiFont))
                                    .foregroundColor(Color.white)
                            }
                        }
                        
                    }
                    .padding(.top, screenInfo.plusIconSize * 0.5)
                    .lineLimit(1)
                    .minimumScaleFactor(0.01) // in case "paste" is too wide on small phones
                }
            }
        }
        .frame(width: model.screenInfo.plusIconSize)
        .padding(.leading, model.screenInfo.plusIconLeftPadding)
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
