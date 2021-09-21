//
//  PlaceInCapsule.swift
//  Calculator
//
//  Created by Joachim Neumann on 21/09/2021.
//

import SwiftUI

struct PlaceInCapsule: ViewModifier {
    let properties: KeyProperties
    @State var down: Bool = false
    func body(content: Content) -> some View {
        ZStack {
            Capsule()
                .foregroundColor(down ? properties.downColor : properties.color)
            content
        }
        .gesture(
            DragGesture(minimumDistance: 0.0)
                .onChanged() { value in
                    withAnimation(.easeIn(duration: properties.downAnimationTime)) {
                        down = true
                    }
                }
                .onEnded() { value in
                    withAnimation(.easeIn(duration: properties.upAnimationTime)) {
                        down = false
                    }
                }
        )
    }
}

extension View {
    func placeInCapsule(with properties: KeyProperties) -> some View {
        return self.modifier(PlaceInCapsule(properties: properties))
    }
}
