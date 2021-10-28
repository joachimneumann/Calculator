//
//  AddBackGround.swift
//  Calculator
//
//  Created by Joachim Neumann on 21/09/2021.
//

import SwiftUI

private struct AddBackGround: ViewModifier {
    let keyProperties: KeyProperties
    let brain: Brain
    let isPending: Bool
    let callback: (() -> Void)?
    @State var down: Bool = false

    var bg: Color {
        if down {
//            if enabled {
                return keyProperties.downColor
//            } else {
//                return Color(
//                    red:   (229.0 / 255.0),
//                    green: ( 99.0 / 255.0),
//                    blue:  ( 97.0 / 255.0))
//            }
        } else {
            if isPending {
                return keyProperties.textColor
            } else {
                return keyProperties.bgColor
            }
        }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            TE.ButtonShape()
                .foregroundColor(bg)
            content
        }
        .gesture(
            DragGesture(minimumDistance: 0.0)
                .onChanged() { value in
                    //print("onChanged brain.isCalculating=\(brain.isCalculating)")
                    if !brain.isCalculating {
                        withAnimation(.easeIn(duration: keyProperties.downAnimationTime)) {
                            down = true
                        }
                    }
                }
                .onEnded() { value in
                    if !brain.isCalculating {
                        withAnimation(.easeIn(duration: keyProperties.upAnimationTime)) {
                            down = false
                        }
                        callback!()
                    }
                }
        )
    }
}

extension View {
    func addBackground(with keyProperties: KeyProperties, brain: Brain, isPending: Bool, callback: (() -> Void)?) -> some View {
//        print("addBackground brain.isCalculating=\(brain.isCalculating)")
        return self.modifier(AddBackGround(keyProperties: keyProperties, brain: brain, isPending: isPending, callback: callback))
    }
}
