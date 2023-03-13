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
    @ObservedObject var viewModel: ViewModel
    let screen: Screen
    @Binding var isZoomed: Bool
    @State var copyDone = true
    @State var pasteDone = true
    @State var isValidPasteContent = true
    @State var wait300msDone = false
#if os(macOS)
    private let plusWeight = Font.Weight.light
#else
    private let plusWeight = Font.Weight.thin
#endif

    var plus: some View {
        ZStack() {
            let plusIconBackgroundColor = viewModel.backgroundColor["plus"] ?? Color.gray
            Image(systemName: "plus.circle.fill")
                .resizable()
                .font(Font.title.weight(plusWeight))
                .rotationEffect(isZoomed ? .degrees(-45.0) : .degrees(0.0))
                .frame(width: screen.plusIconSize, height: screen.plusIconSize)
                .background(.white)
                .foregroundColor(plusIconBackgroundColor)
                .clipShape(Circle())
                .animation(.linear, value: isZoomed)
                .onTapGesture {
                    isZoomed.toggle()
                }
                .accessibilityIdentifier("plusButton")
            /// This circle removes antialising effects from the background color at the edge of the plus image
            Circle()
                .stroke(plusIconBackgroundColor, lineWidth: 1)
                .frame(width: screen.plusIconSize, height: screen.plusIconSize)
        }
    }
    
    @ViewBuilder
    var copy: some View {
        if !simulatePurchased && store.purchasedIDs.isEmpty {
            NavigationLink {
                PurchaseView(store: store, viewModel: viewModel, screen: screen)
            } label: {
                Text("copy")
                    .font(Font(screen.infoUiFont))
                    .foregroundColor(Color.white)
            }
        } else {
            Text("copy")
                .font(Font(screen.infoUiFont))
                .foregroundColor(viewModel.isCopying ? Color.orange : Color.white)
                .onTapGesture {
                    if copyDone && pasteDone && !viewModel.isCopying && !viewModel.isPasting {
                        setIsCopying(to: true)
                        wait300msDone = false
                        Task.detached(priority: .high) {
                            try? await Task.sleep(nanoseconds: 300_000_000)
                            await MainActor.run() {
                                wait300msDone = true
                                if copyDone {
                                    setIsCopying(to: false)
                                }
                            }
                        }
                        Task(priority: .low) {
                            copyDone = false
                            await viewModel.copyToPastBin(screen: screen)
                            copyDone = true
                            if wait300msDone {
                                setIsCopying(to: false)
                            }
                        }
                        isValidPasteContent = true
                    }
                }
                .accessibilityIdentifier("copyButton")
        }
    }
    
    @ViewBuilder
    var paste: some View {
        if !simulatePurchased && store.purchasedIDs.isEmpty {
            NavigationLink {
                PurchaseView(store: store, viewModel: viewModel, screen: screen)
            } label: {
                Text("paste")
                    .font(Font(screen.infoUiFont))
                    .foregroundColor(Color.white)
            }
        } else {
            Text("paste")
                .font(Font(screen.infoUiFont))
                .foregroundColor(isValidPasteContent ? (viewModel.isPasting ? .orange : .white) : .gray)
                .onTapGesture {
                    if copyDone && pasteDone && !viewModel.isCopying && !viewModel.isPasting && isValidPasteContent {
                        setIsPasting(to: true)
                        pasteDone = false
                        wait300msDone = false
                        Task.detached(priority: .high) {
                            try? await Task.sleep(nanoseconds: 300_000_000)
                            await MainActor.run() {
                                wait300msDone = true
                                if pasteDone {
                                    viewModel.isPasting = false
                                }
                            }
                        }
                        Task(priority: .low) {
                            isValidPasteContent = await viewModel.copyFromPasteBin(screen: screen)
                            pasteDone = true
                            if wait300msDone {
                                setIsPasting(to: false)
                            }
                        }
                    }
                }
                .accessibilityIdentifier("pasteButton")
        }
    }
    
    @ViewBuilder
    var settings: some View {
        NavigationLink {
            Settings(viewModel: viewModel, screen: screen, font: Font(screen.infoUiFont))
        } label: {
            Image(systemName: "gearshape")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .font(Font.title.weight(.thin))
                .frame(height: screen.plusIconSize * 0.6)
                .foregroundColor(Color.white)
                .accessibilityIdentifier("settingsButton")
        }
        .buttonStyle(TransparentButtonStyle())
    }
    
    @ViewBuilder
    var toInt: some View {
        let integerLabel = viewModel.currentDisplay.canBeInteger ? (viewModel.showAsInt ? "→ sci" : "→ int") : ""
        if integerLabel.count > 0 && !screen.forceScientific {
            Button {
                viewModel.showAsInt.toggle()
                Task {
                    await viewModel.refreshDisplay(screen: screen)
                }
            } label: {
                Text(integerLabel)
                    .font(Font(screen.infoUiFont))
                    .foregroundColor(Color.white)
            }
            .buttonStyle(TransparentButtonStyle())
        }
    }
    
    @ViewBuilder
    var toFloat: some View {
        let floatLabel = viewModel.currentDisplay.canBeFloat ? (viewModel.showAsFloat ? "→ sci" : "→ float") : ""
        if !viewModel.currentDisplay.canBeInteger && floatLabel.count > 0 && !screen.forceScientific {
            Button {
                viewModel.showAsFloat.toggle()
                Task {
                    await viewModel.refreshDisplay(screen: screen)
                }
            } label: {
                Text(floatLabel)
                    .font(Font(screen.infoUiFont))
                    .foregroundColor(Color.white)
            }
            .buttonStyle(TransparentButtonStyle())
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            plus
                .padding(.top, screen.infoTextHeight * 0.2)
            Group {
                copy
                paste
                settings
                toInt
                toFloat
            }
            .padding(.top, screen.plusIconSize * 0.5)//(viewModel.rad ? screen.infoTextHeight : 0.0))
            .lineLimit(1)
            .minimumScaleFactor(0.01) // in case "paste" is too wide on small phones
        }
        .frame(width: screen.iconsWidth)
        .padding(.trailing, screen.plusIconTrailingPadding)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                self.isValidPasteContent = true
            }
        }
    }
    @MainActor func setIsCopying(to isCopying: Bool) {
        viewModel.isCopying = isCopying
    }
    @MainActor func setIsPasting(to isPasting: Bool) {
        viewModel.isPasting = isPasting
    }
}
//struct Icons_Previews: PreviewProvider {
//    static var previews: some View {
//        Icons()
//    }
//}
