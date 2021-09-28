//
//  AddBackGround.swift
//  Calculator
//
//  Created by Joachim Neumann on 21/09/2021.
//

import SwiftUI

private struct AddBackGround: ViewModifier {
    let properties: Configuration.KeyProperties
    let isAllowed: Bool
    let callback: (() -> Void)?
    @State var down: Bool = false
    func body(content: Content) -> some View {
        ZStack {
            Configuration.Background()
                .foregroundColor(down ? (isAllowed ? properties.downColor : Color.red) : properties.color)
            content
        }
        .gesture(
            DragGesture(minimumDistance: 0.0)
                .onChanged() { value in
                    if callback != nil {
                        withAnimation(.easeIn(duration: properties.downAnimationTime)) {
                            down = true
                        }
                    }
                }
                .onEnded() { value in
                    if callback != nil {
                        withAnimation(.easeIn(duration: properties.upAnimationTime)) {
                            down = false
                        }
                        if isAllowed { callback!() }
                    }
                }
        )
    }
}

extension View {
    func addBackground(with properties: Configuration.KeyProperties, isAllowed: Bool, callback: (() -> Void)?) -> some View {
        return self.modifier(AddBackGround(properties: properties, isAllowed: isAllowed, callback: callback))
    }
}
