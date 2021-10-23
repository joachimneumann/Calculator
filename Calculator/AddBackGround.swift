//
//  AddBackGround.swift
//  Calculator
//
//  Created by Joachim Neumann on 21/09/2021.
//

import SwiftUI

private struct AddBackGround: ViewModifier {
    let keyProperties: KeyProperties
    let isAllowed: Bool
    let isPending: Bool
    let callback: (() -> Void)?
    var bg: Color {
        if down {
            if isAllowed {
                return keyProperties.downColor
            } else {
                return Color(
                    red:   229.0/255.0,
                    green:  99.0/255.0,
                    blue:   97.0/255.0)
            }
        } else {
            if isPending {
                return keyProperties.textColor
            } else {
                return keyProperties.bgColor
            }
        }
    }
    @State var down: Bool = false
    func body(content: Content) -> some View {
        ZStack {
            TE.ButtonShape()
                .foregroundColor(bg)
            content
        }
        .gesture(
            DragGesture(minimumDistance: 0.0)
                .onChanged() { value in
                    if isAllowed && callback != nil {
                        withAnimation(.easeIn(duration: keyProperties.downAnimationTime)) {
                            down = true
                        }
                    }
                }
                .onEnded() { value in
                    if isAllowed && callback != nil {
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
    func addBackground(with keyProperties: KeyProperties, isAllowed: Bool, isPending: Bool, callback: (() -> Void)?) -> some View {
        return self.modifier(AddBackGround(keyProperties: keyProperties, isAllowed: isAllowed, isPending: isPending, callback: callback))
    }
}
