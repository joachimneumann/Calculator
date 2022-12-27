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
    let screen: Screen
    @Binding var isZoomed: Bool
    @State var copyDone = true
    @State var pasteDone = true
    @State var isValidPasteContent = true
    @State var wait300msDone = false
    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .font(Font.title.weight(.thin))
                .rotationEffect(isZoomed ? .degrees(-45.0) : .degrees(0.0))
                .frame(width: screen.plusIconSize, height: screen.plusIconSize)
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
                                PurchaseView(store: store, model: model, screen: screen, font: Font(screen.infoUiFont))
                            } label: {
                                Text("copy")
                                    .font(Font(screen.infoUiFont))
                                    .foregroundColor(Color.white)
                            }
                        } else {
                            Text("copy")
                                .font(Font(screen.infoUiFont))
                                .foregroundColor(model.isCopying ? Color.orange : Color.white)
                                .onTapGesture {
                                    if copyDone && pasteDone && !model.isCopying && !model.isPasting {
                                        setIsCopying(to: true)
                                        wait300msDone = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            wait300msDone = true
                                            if copyDone {
                                                setIsCopying(to: false)
                                            }
                                        }
                                        Task {
                                            copyDone = false
                                            await model.copyToPastBin()
                                            copyDone = true
                                            if wait300msDone {
                                                setIsCopying(to: false)
                                            }
                                        }
                                        isValidPasteContent = true
                                    }
                                }
                        }
                        if !simulatePurchased && store.purchasedIDs.isEmpty {
                            NavigationLink {
                                PurchaseView(store: store, model: model, screen: screen, font: Font(screen.infoUiFont))
                            } label: {
                                Text("paste")
                                    .font(Font(screen.infoUiFont))
                                    .foregroundColor(Color.white)
                            }
                        } else {
                            Text("paste")
                                .font(Font(screen.infoUiFont))
                                .foregroundColor(isValidPasteContent ? (model.isPasting ? .orange : .white) : .gray)
                                .onTapGesture {
                                    if copyDone && pasteDone && !model.isCopying && !model.isPasting && isValidPasteContent {
                                        setIsPasting(to: true)
                                        pasteDone = false
                                        wait300msDone = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            wait300msDone = true
                                            if pasteDone {
                                                model.isPasting = false
                                            }
                                        }
                                        Task {
                                            isValidPasteContent = await model.copyFromPastBin()
                                            pasteDone = true
                                            if wait300msDone {
                                                setIsPasting(to: false)
                                            }
                                        }
                                    }
                                }
                        }
                        
                        NavigationLink {
                            Settings(model: model, screen: screen, font: Font(screen.infoUiFont))
                        } label: {
                            Image(systemName: "gearshape")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .font(Font.title.weight(.thin))
                                .frame(height: screen.plusIconSize * 0.6)
                                .foregroundColor(Color.white)
                        }
                        
                        let integerLabel = model.display.data.canBeInteger ? (model.showAsInteger ? "→ sci" : "→ int") : ""
                        if integerLabel.count > 0 {
                            Button {
                                model.showAsInteger.toggle()
                                //                                model.updateDisplayData()
                            } label: {
                                Text(integerLabel)
                                    .font(Font(screen.infoUiFont))
                                    .foregroundColor(Color.white)
                            }
                        }
                        
                        let floatLabel = model.display.data.canBeFloat ? (model.showAsFloat ? "→ sci" : "→ float") : ""
                        if integerLabel.count == 0 && floatLabel.count > 0 {
                            Button {
                                model.showAsFloat.toggle()
                                //                                model.updateDisplayData()
                            } label: {
                                Text(floatLabel)
                                    .font(Font(screen.infoUiFont))
                                    .foregroundColor(Color.white)
                            }
                        }
                        
                    }
                    .padding(.top, screen.plusIconSize * 0.5)
                    .lineLimit(1)
                    .minimumScaleFactor(0.01) // in case "paste" is too wide on small phones
                }
            }
        }
        .frame(width: screen.plusIconSize)
        .padding(.leading, screen.plusIconLeftPadding)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                self.isValidPasteContent = true
            }
        }
    }
    @MainActor func setIsCopying(to isCopying: Bool) {
        model.isCopying = isCopying
    }
    @MainActor func setIsPasting(to isPasting: Bool) {
        model.isPasting = isPasting
    }
}
//struct Icons_Previews: PreviewProvider {
//    static var previews: some View {
//        Icons()
//    }
//}
