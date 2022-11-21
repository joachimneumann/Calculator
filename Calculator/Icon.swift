////
////  Icon.swift
////  Calculator
////
////  Created by Joachim Neumann on 11/10/22.
////
//
//import SwiftUI
//
//struct PlusIcon: View {
//    @Binding var isZoomed: Bool
//    let showCalculating: Bool
//    let size: CGFloat
//    let color: Color
//    let topPaddingZoomed: CGFloat
//    let topPaddingNotZoomed: CGFloat
//    let progressViewScaleFactor: CGFloat
//    
//    init(brain: Brain, t: TE, isZoomed: Binding<Bool>, showCalculating: Bool, progressViewScaleFactor: CGFloat) {
//        size = t.iconSize*0.8
//        self.progressViewScaleFactor = progressViewScaleFactor
//        self._isZoomed = isZoomed
//        self.showCalculating = showCalculating
//        color = t.digits_1_9.textColor
//        self.topPaddingNotZoomed = t.zoomTopPaddingNotZoomed
//        self.topPaddingZoomed = t.zoomTopPaddingZoomed
//    }
//    
//    var body: some View {
//        Group {
//            if showCalculating {
//                ProgressView()
//                    .frame(width: size * progressViewScaleFactor, height: size * progressViewScaleFactor)
//                    .foregroundColor(.white)
//                    .tint(Color.white)
//            } else {
//                Image(systemName: "plus.circle.fill")
//                    .resizable()
//                    .onTapGesture {
//                        withAnimation() {
//                            isZoomed.toggle()
//                        }
//                    }
//            }
//        }
//            .scaledToFit()
//            .frame(width: size, height: size)
//            .font(.system(size: size, weight: .thin))
//            .foregroundColor(color)
//            .rotationEffect(isZoomed ? .degrees(-45.0) : .degrees(0.0))
//            .padding(.top, isZoomed ? topPaddingZoomed : topPaddingNotZoomed)
//    }
//}
//
//struct CopyIcon: View {
//    @Binding var isCopyingOrPasting: Bool
//    let brain: Brain
//    let size: CGFloat
//    let color: Color
//    let topPadding: CGFloat
//    
//    init(brain: Brain, t: TE, isCopyingOrPasting: Binding<Bool>) {
//        self.brain = brain
//        self._isCopyingOrPasting = isCopyingOrPasting
//        size = t.iconSize
//        color = t.digits_1_9.textColor
//        self.topPadding = t.iconSize*0.6
//    }
//    
//    var body: some View {
//        Text("Copy")
//            .scaledToFill()
//            .onTapGesture() {
//            isCopyingOrPasting = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                withAnimation() {
//                    isCopyingOrPasting = false
//                }
//            }
//            UIPasteboard.general.string = brain.last.singleLine(len: brain.precision).replacingOccurrences(of: ",", with: ".")
//        }
//        .foregroundColor(color)
//        .frame(width: size, height: size)
//        .padding(.top, topPadding)
//    }
//}
//
//struct PasteIcon: View {
//    @Binding var isCopyingOrPasting: Bool
//    @Environment(\.scenePhase) var scenePhase
//    let brain: Brain
//    let size: CGFloat
//    let color: Color
//    let topPadding: CGFloat
//    @State var showPasteButton = true
//    
//    func hasValidNumberToPaste() -> Bool {
//        if let pasteString = UIPasteboard.general.string {
//            if pasteString.count > 0 {
//                if Gmp("0", bits: brain.bits).isValidGmpString(pasteString) {
//                    return true
//                }
//            }
//        }
//        return false
//    }
//    
//    init(brain: Brain, t: TE, isCopyingOrPasting: Binding<Bool>) {
//        self.brain = brain
//        self._isCopyingOrPasting = isCopyingOrPasting
//        size = t.iconSize
//        color = t.digits_1_9.textColor
//        self.topPadding = t.iconSize*0.4
//    }
//    
//    var body: some View {
//        Group {
//            if showPasteButton {
//                Text("Paste")
//                    .scaledToFill()
//                    .onTapGesture() {
//                        if hasValidNumberToPaste() {
//                            DispatchQueue.main.async {
//                                isCopyingOrPasting = true
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//                                    isCopyingOrPasting = false
//                                }
//                                brain.asyncOperation("fromPasteboard")
//                            }
//                        } else {
//                            showPasteButton = false
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//                                showPasteButton = true
//                            }
//                        }
//                    }
//            } else {
//                Image("noNumber")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//            }
//        }
//        .frame(width: size, height: size)
//        .foregroundColor(color)
//        .padding(.top, topPadding)
//    }
//}
//
//struct ControlIcon: View {
//    let brain: Brain
//    let size: CGFloat
//    let color: Color
//    let topPadding: CGFloat
//    @Binding var copyAndPastePurchased: Bool
//    
//    init(brain: Brain, t: TE, copyAndPastePurchased: Binding<Bool>) {
//        self.brain = brain
//        self._copyAndPastePurchased = copyAndPastePurchased
//        size = t.iconSize
//        color = t.digits_1_9.textColor
//        self.topPadding = t.iconSize*0.6
//    }
//    
//    var body: some View {
//        NavigationLink(destination: ControlCenter(brain: brain, copyAndPastePurchased: _copyAndPastePurchased)) {
//            Image(systemName: "switch.2")
//                .resizable()
//                .scaledToFit()
//                .frame(width: size*0.8, height: size*0.8)
//                .font(.system(size: size, weight: .thin))
//                .foregroundColor(color)
//                .padding(.top, topPadding)
//        }
//    }
//}
