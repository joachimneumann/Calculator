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
    var keyboardSize = CGSize(width: 0, height: 0)
    var displaySize = CGSize(width: 0, height: 0)

    init(isPad: Bool, isPortrait: Bool, size: CGSize) {
        self.isPad = isPad
        self.isPortrait = isPortrait
        self.size = size
        
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
                let spaceBetweenKeys = KeyModel.spaceBetweenkeysFraction(withScientificKeys: false) * size.width
                let oneKeyWidth = (size.width - 3.0 * spaceBetweenKeys) * 0.25
                let allKeysheight = 5 * oneKeyWidth + 4 * spaceBetweenKeys
                keyboardSize = CGSize(width: size.width, height: allKeysheight)
                displaySize = CGSize(width: size.width, height: oneKeyWidth) /// keys are as wide as high
            } else {
                /// landscape iPhone
                let spaceBetweenKeys = KeyModel.spaceBetweenkeysFraction(withScientificKeys: true) * size.width
                let oneKeyheight = (size.height - 5.0 * spaceBetweenKeys) / 6.0
                let keyboardHeight = 5 * oneKeyheight + 4.0 * spaceBetweenKeys
                let displayHeight = oneKeyheight
                keyboardSize = CGSize(width: size.width, height: keyboardHeight)
                displaySize = CGSize(width: size.width, height: displayHeight)
                if isPad || !isPortrait {
                    /// make space for "rad" info
                    displaySize.width -= displayHeight
                }
            }
        }
    }
    //    @StateObject private var viewLogic = ViewLogic(size: CGSize(width: 100, height: 100))
    var body: some View {
        let info1 = "\(keyModel._hasBeenReset ? "Precision: "+keyModel.precisionDescription+" digits" : "")"
        let info2 = "\(keyModel._rad ? "Rad      " : "")"
        if isPad {
            VStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                KeysView(keyModel: keyModel, isScientific: false, size: keyboardSize)
            }
        } else {
            ZStack {
                /// display
                VStack(spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    OneLineDisplay(keyModel: keyModel, size: displaySize, fontShouldScale: !isPad && isPortrait)
                    KeysView(keyModel: keyModel, isScientific: !isPortrait, size: keyboardSize)
                        .padding(.bottom, isPortrait ? size.height*0.06 : 0.0)
                }
                VStack(spacing: 0.0) {
                    if keyModel._isCalculating {
                        Spacer(minLength: 0.0)
                        HStack(spacing: 0.0) {
                            AnimatedDots(color: Color(white: 0.7))
                                .padding(.top, displaySize.height * 0.2)
                            Spacer()
                        }
                        Spacer(minLength: 0.0)
                    } else {
                        HStack(spacing: 0.0) {
                            Text(info1)
                                .foregroundColor(Color.white)
                            Spacer()
                        }
                        Spacer()
                        HStack(spacing: 0.0) {
                            Text(info2)
                                .foregroundColor(Color.white)
                                .padding(.bottom, displaySize.height * 0.2)
                            Spacer()
                        }
                    }
                }
                .padding(.bottom, keyboardSize.height)//+displaySize.height*0.2)
                .padding(.leading, displaySize.height*0.4)
            }
        }
        
        //                    if viewLogic.isZoomed && !isPortrait {
        //                        LongDisplay(text: viewLogic.longText, uiFont: viewLogic.displayUIFont, isCopyingOrPasting: viewLogic.isCopyingOrPasting, color: viewLogic.textColor)
        //
        //                        MultiLineDisplay(brain: Brain(), t: TE(), isCopyingOrPasting: false)
        //                            .padding(.trailing, TE().trailingAfterDisplay)
        //                    } else {
        //                        Spacer(minLength: 0.0)
        //                        SingleLineDisplay(brain: Brain(), t: TE())
        //                            .padding(.trailing, TE().trailingAfterDisplay)

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
        Calculator(isPad: false, isPortrait: true, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            .background(Color.black)
    }
}
