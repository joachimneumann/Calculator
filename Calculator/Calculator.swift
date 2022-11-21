//
//  Calculator.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct Calculator: View {
    let isPad: Bool
    let isPortrait: Bool
    let size: CGSize
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
                    KeysView(bottomPadding: 10, isScientific: true, scientificTrailingPadding: 100, size: size)
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
                    KeysView(bottomPadding: 10, isScientific: false, scientificTrailingPadding: 100, size: size)
                }
            }
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
        Calculator(isPad: true, isPortrait: true, size: CGSize(width: 100, height: 100))
    }
}
