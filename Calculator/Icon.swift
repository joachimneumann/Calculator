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
//    @State var color: Color
//    let isEnabled: Bool
//    let size: CGFloat
//    let topPaddingZoomed: CGFloat
//    let topPaddingNotZoomed: CGFloat
//    let progressViewScaleFactor: CGFloat
//    @State var downAnimationFinished = false
////
//    init(isZoomed: Binding<Bool>, isEnabled: Bool, progressViewScaleFactor: CGFloat, size: CGFloat) {
//        self.isEnabled = isEnabled
//        self.size = size
//        self.progressViewScaleFactor = progressViewScaleFactor
//        self._isZoomed = isZoomed
//        color = Color(uiColor: C.digitColors.textColor)
//        self.topPaddingNotZoomed = 0.0//t.zoomTopPaddingNotZoomed
//        self.topPaddingZoomed = 0.0//t.zoomTopPaddingZoomed
//    }
//    
//    var body: some View {
//        Image(systemName: "plus.circle.fill")
//            .resizable()
//            .scaledToFit()
//            .frame(width: size, height: size)
//            .font(.system(size: size, weight: .thin))
//            .foregroundColor(color)
//            .rotationEffect(isZoomed ? .degrees(-45.0) : .degrees(0.0))
//            .padding(.top, isZoomed ? topPaddingZoomed : topPaddingNotZoomed)
//            .simultaneousGesture(DragGesture(minimumDistance: 0)
//                .onChanged { _ in
//                    if isEnabled {
//                        withAnimation() {
//                            isZoomed.toggle()
//                        }
//                    } else {
//                        withAnimation(.easeIn(duration: 0.1)) {
//                            self.downAnimationFinished = false
//                            color = Color.red
//                        }
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                            withAnimation(.easeIn(duration: 0.3)) {
//                                color = Color(uiColor: C.digitColors.textColor)
//                            }
//                        }
//                    }
//                })
//    }
////                    if isEnabled {
////                            isZoomed.toggle()
////                        }
////                    } else {
////                        withAnimation(.easeIn(duration: 0.1)) {
////                            color = Color.red
////                        }
////                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
////                            withAnimation(.easeIn(duration: 0.3)) {
////                                color = Color(uiColor: C.digitColors.textColor)
////                            }
////                        }
////                    }
////                }
////                .onEnded { _ in
//////                    if !isEnabled {
////                        withAnimation(.easeIn(duration: 0.3)) {
////                            color = Color(uiColor: C.digitColors.textColor)
////                        }
//////                    }
////                })
////            .onTapGesture {
////                if isEnabled {
////                    color = Color(uiColor: C.digitColors.textColor)
////                    withAnimation() {
////                        isZoomed.toggle()
////                    }
////                } else {
////                    withAnimation(.easeIn(duration: 0.1)) {
////                        color = Color.red
////                    }
////                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
////                        withAnimation(.easeIn(duration: 0.3)) {
////                            color = Color(uiColor: C.digitColors.textColor)
////                        }
////                    }
////                }
////            }
////    }
//}
//
//struct CopyIcon: View {
//    @Binding var isCopyingOrPasting: Bool
//    let keyModel: KeyModel
//    let size: CGFloat
//    let color: Color
//    let topPadding: CGFloat
//    
//    init(keyModel: KeyModel, isCopyingOrPasting: Binding<Bool>, size: CGFloat) {
//        self.keyModel = keyModel
//        self._isCopyingOrPasting = isCopyingOrPasting
//        self.size = size
//        color = Color(uiColor: C.digitColors.textColor)
//        self.topPadding = 0.0//t.iconSize*0.6
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
////            UIPasteboard.general.string = keyModel.oneLine.replacingOccurrences(of: ",", with: ".")
//        }
//        .foregroundColor(color)
//        .frame(width: size, height: size)
//        .padding(.top, topPadding)
//    }
//}
//
////struct PasteIcon: View {
////    @Binding var isCopyingOrPasting: Bool
////    @Environment(\.scenePhase) var scenePhase
////    let brain: Brain
////    let size: CGFloat
////    let color: Color
////    let topPadding: CGFloat
////    @State var showPasteButton = true
////    
////    func hasValidNumberToPaste() -> Bool {
////        if let pasteString = UIPasteboard.general.string {
////            if pasteString.count > 0 {
////                if Gmp("0", bits: brain.bits).isValidGmpString(pasteString) {
////                    return true
////                }
////            }
////        }
////        return false
////    }
////    
////    init(brain: Brain, t: TE, isCopyingOrPasting: Binding<Bool>) {
////        self.brain = brain
////        self._isCopyingOrPasting = isCopyingOrPasting
////        size = t.iconSize
////        color = t.digits_1_9.textColor
////        self.topPadding = t.iconSize*0.4
////    }
////    
////    var body: some View {
////        Group {
////            if showPasteButton {
////                Text("Paste")
////                    .scaledToFill()
////                    .onTapGesture() {
////                        if hasValidNumberToPaste() {
////                            DispatchQueue.main.async {
////                                isCopyingOrPasting = true
////                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
////                                    isCopyingOrPasting = false
////                                }
////                                brain.asyncOperation("fromPasteboard")
////                            }
////                        } else {
////                            showPasteButton = false
////                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
////                                showPasteButton = true
////                            }
////                        }
////                    }
////            } else {
////                Image("noNumber")
////                    .resizable()
////                    .aspectRatio(contentMode: .fit)
////            }
////        }
////        .frame(width: size, height: size)
////        .foregroundColor(color)
////        .padding(.top, topPadding)
////    }
////}
////
////struct ControlIcon: View {
////    let brain: Brain
////    let size: CGFloat
////    let color: Color
////    let topPadding: CGFloat
////    @Binding var copyAndPastePurchased: Bool
////    
////    init(brain: Brain, t: TE, copyAndPastePurchased: Binding<Bool>) {
////        self.brain = brain
////        self._copyAndPastePurchased = copyAndPastePurchased
////        size = t.iconSize
////        color = t.digits_1_9.textColor
////        self.topPadding = t.iconSize*0.6
////    }
////    
////    var body: some View {
////        NavigationLink(destination: ControlCenter(brain: brain, copyAndPastePurchased: _copyAndPastePurchased)) {
////            Image(systemName: "switch.2")
////                .resizable()
////                .scaledToFit()
////                .frame(width: size*0.8, height: size*0.8)
////                .font(.system(size: size, weight: .thin))
////                .foregroundColor(color)
////                .padding(.top, topPadding)
////        }
////    }
////}
