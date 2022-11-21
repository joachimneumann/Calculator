//
//  Calculator.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct Calculator: View {
    @StateObject private var keyModel = KeyModel()
    let isPad: Bool
    var isPortrait: Bool
    let size: CGSize
    @State var keyboardSize = CGSize(width: 0, height: 0)
    
    init(isPad: Bool, isPortrait: Bool, size: CGSize) {
        let _ = print("Calculator init() size = \(size)")
        self.isPad = isPad
        self.isPortrait = isPortrait
        self.size = size
    }
    //    @StateObject private var viewLogic = ViewLogic(size: CGSize(width: 100, height: 100))
    var body: some View {
        ZStack {
            Color.gray
            if isPad {
                VStack(spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    //                    if viewLogic.isZoomed {
                    //                        LongDisplay(text: viewLogic.longText, uiFont: viewLogic.displayUIFont, isCopyingOrPasting: viewLogic.isCopyingOrPasting, color: viewLogic.textColor)
                    //                        MultiLineDisplay(brain: Brain(), t: TE(), isCopyingOrPasting: false)
                    //                            .padding(.trailing, TE().trailingAfterDisplay)
                    //                            .opacity(viewLogic.isZoomed ? 1.0 : 0.0)
                    //                            .transition(.move(edge: .bottom))
                    //                    } else {
                    //                        SingleLineDisplay(brain: Brain(), t: TE())
                    //                            .padding(.trailing, TE().trailingAfterDisplay)
                    //                            .opacity(viewLogic.isZoomed ? 0.0 : 1.0)
                    //                    }
                    KeysView(keyModel: keyModel, bottomPadding: 10, isScientific: false, scientificTrailingPadding: 100, size: keyboardSize)
                }
            } else {
                VStack(spacing: 0.0) {
                    //                    if viewLogic.isZoomed && !isPortrait {
                    //                        LongDisplay(text: viewLogic.longText, uiFont: viewLogic.displayUIFont, isCopyingOrPasting: viewLogic.isCopyingOrPasting, color: viewLogic.textColor)
                    //
                    //                        MultiLineDisplay(brain: Brain(), t: TE(), isCopyingOrPasting: false)
                    //                            .padding(.trailing, TE().trailingAfterDisplay)
                    //                    } else {
                    //                        Spacer(minLength: 0.0)
                    //                        SingleLineDisplay(brain: Brain(), t: TE())
                    //                            .padding(.trailing, TE().trailingAfterDisplay)
                    KeysView(keyModel: keyModel, bottomPadding: 10, isScientific: false, scientificTrailingPadding: 100, size: keyboardSize)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
//            GeometryReader { geo in
                let isPortrait = size.height < size.width
                if isPad {
                    if isPortrait {
                        keyboardSize = CGSize(width: size.width, height: size.height*0.5)
                    } else {
                        /// landscape iPad
                        keyboardSize = CGSize(width: size.width, height: size.height*0.5)
                    }
                } else {
                    /// iPhone
                    if isPortrait {
                        /// we want square buttons :)
                        /// let
                        let spaceBetweenKeys = keyModel.spaceBetweenkeysFraction(withScientificKeys: false) * size.width
                        let oneKeyWidth = (size.width - 3.0 * spaceBetweenKeys) * 0.25
                        let allKeysheight = 5 * oneKeyWidth + 4 * spaceBetweenKeys
                        keyboardSize = CGSize(width: size.width, height: allKeysheight)
                    } else {
                        /// landscape iPhone
                        keyboardSize = CGSize(width: size.width, height: size.height*0.8)
                    }
                }
                let _ = print("orientation Notification \(isPortrait) \(size) \(keyboardSize)")
//            }
        }
    }
}


//struct Keys: View {
//    let brain: Brain
//    var t: TE
//    let bottomPadding: CGFloat
//
//    init(brain: Brain, t: TE) {
//        self.brain = brain
//        self.t = t
//        if !t.isPad && t.isPortrait {
//            bottomPadding = t.allkeysHeight * 0.07
//        } else {
//            bottomPadding = 0
//        }
//    }
//
//    var body: some View {
//        VStack(spacing: 0.0) {
//            Spacer(minLength: 0.0)
//            HStack(spacing: 0.0) {
//                if t.isPad || !t.isPortrait {
////                    ScientificKeys(brain: brain, t: t)
////                        .padding(.trailing, t.spaceBetweenKeys)
//                }
////                NumberKeys(brain: brain, t: t)
//            }
//        }
//        .frame(height: t.allkeysHeight)
//        .background(Color.black)
//        .transition(.move(edge: .bottom))
//        .padding(.bottom, bottomPadding)
//    }
//}

struct Calculator_Previews: PreviewProvider {
    static var previews: some View {
        Calculator(isPad: true, isPortrait: true, size: CGSize(width: UIScreen.main.bounds.width*0.9, height: UIScreen.main.bounds.height*0.85))
    }
}
