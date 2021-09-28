//
//  AddBackGround.swift
//  Calculator
//
//  Created by Joachim Neumann on 21/09/2021.
//

import SwiftUI

private struct AddBackGround: ViewModifier {
    let properties: Configuration.KeyProperties
    let callback: (() -> Void)?
    let isValidKey: Bool
    @State var down: Bool = false
    func body(content: Content) -> some View {
        ZStack {
            Configuration.Background()
                .foregroundColor(down ? (isValidKey ? properties.downColor : Color.red) : properties.color)
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
                        callback!()
                    }
                }
        )
    }
}

extension View {
    func addBackground(with properties: Configuration.KeyProperties, callback: (() -> Void)?, isValidKey: Bool) -> some View {
        return self.modifier(AddBackGround(properties: properties, callback: callback, isValidKey: isValidKey))
    }
}
