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
    @ObservedObject var brainModel: BrainModel
    let keyModel: KeyModel
    let screen: Screen
    @Binding var isZoomed: Bool
    @State var copyDone = true
    @State var pasteDone = true
    @State var isValidPasteContent = true
    @State var wait300msDone = false

    var plus: some View {
        Image(systemName: "plus.circle.fill")
            .resizable()
            .font(Font.title.weight(.thin))
            .rotationEffect(isZoomed ? .degrees(-45.0) : .degrees(0.0))
            .frame(width: screen.plusIconSize, height: screen.plusIconSize)
            .background(.white)
            .foregroundColor(.gray)
            .clipShape(Circle())
            .animation(.linear, value: isZoomed)
            .onTapGesture {
                isZoomed.toggle()
            }
            .accessibilityIdentifier("plusButton")
    }
    
    @ViewBuilder
    var copy: some View {
        if !simulatePurchased && store.purchasedIDs.isEmpty {
            NavigationLink {
                PurchaseView(store: store, brainModel: brainModel, screen: screen, font: Font(screen.infoUiFont))
            } label: {
                Text("copy")
                    .font(Font(screen.infoUiFont))
                    .foregroundColor(Color.white)
            }
        } else {
            Text("copy")
                .font(Font(screen.infoUiFont))
                .foregroundColor(brainModel.isCopying ? Color.orange : Color.white)
                .onTapGesture {
                    if copyDone && pasteDone && !brainModel.isCopying && !brainModel.isPasting {
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
                            await keyModel.copyToPastBin()
                            copyDone = true
                            if wait300msDone {
                                setIsCopying(to: false)
                            }
                        }
                        isValidPasteContent = true
                    }
                }
        }
    }
    
    @ViewBuilder
    var paste: some View {
        if !simulatePurchased && store.purchasedIDs.isEmpty {
            NavigationLink {
                PurchaseView(store: store, brainModel: brainModel, screen: screen, font: Font(screen.infoUiFont))
            } label: {
                Text("paste")
                    .font(Font(screen.infoUiFont))
                    .foregroundColor(Color.white)
            }
        } else {
            Text("paste")
                .font(Font(screen.infoUiFont))
                .foregroundColor(isValidPasteContent ? (brainModel.isPasting ? .orange : .white) : .gray)
                .onTapGesture {
                    if copyDone && pasteDone && !brainModel.isCopying && !brainModel.isPasting && isValidPasteContent {
                        setIsPasting(to: true)
                        pasteDone = false
                        wait300msDone = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            wait300msDone = true
                            if pasteDone {
                                brainModel.isPasting = false
                            }
                        }
                        Task {
                            isValidPasteContent = await keyModel.copyFromPasteBin(screen: screen)
                            pasteDone = true
                            if wait300msDone {
                                setIsPasting(to: false)
                            }
                        }
                    }
                }
        }
    }
    
    var settings: some View {
        NavigationLink {
            Settings(brainModel: brainModel, screen: screen, font: Font(screen.infoUiFont))
        } label: {
            Image(systemName: "gearshape")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .font(Font.title.weight(.thin))
                .frame(height: screen.plusIconSize * 0.6)
                .foregroundColor(Color.white)
                .accessibilityIdentifier("settingsButton")
        }
    }
    
    @ViewBuilder
    var toInt: some View {
        let integerLabel = keyModel.currentDisplay.data.canBeInteger ? (brainModel.showAsInteger ? "→ sci" : "→ int") : ""
        if integerLabel.count > 0 {
            Button {
                brainModel.showAsInteger.toggle()
                Task {
                    await keyModel.refreshDisplay(screen: screen)
                }
            } label: {
                Text(integerLabel)
                    .font(Font(screen.infoUiFont))
                    .foregroundColor(Color.white)
            }
        }
    }
    
    @ViewBuilder
    var toFloat: some View {
        let floatLabel = keyModel.currentDisplay.data.canBeFloat ? (brainModel.showAsFloat ? "→ sci" : "→ float") : ""
        if !keyModel.currentDisplay.data.canBeInteger && floatLabel.count > 0 {
            Button {
                brainModel.showAsFloat.toggle()
                Task {
                    await keyModel.refreshDisplay(screen: screen)
                }
            } label: {
                Text(floatLabel)
                    .font(Font(screen.infoUiFont))
                    .foregroundColor(Color.white)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            plus
            Group {
                copy
                paste
                settings
                toInt
                toFloat
            }
            .padding(.top, screen.plusIconSize * 0.5)
            .lineLimit(1)
            .minimumScaleFactor(0.01) // in case "paste" is too wide on small phones
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
        brainModel.isCopying = isCopying
    }
    @MainActor func setIsPasting(to isPasting: Bool) {
        brainModel.isPasting = isPasting
    }
}
//struct Icons_Previews: PreviewProvider {
//    static var previews: some View {
//        Icons()
//    }
//}
