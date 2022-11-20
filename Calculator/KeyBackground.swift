//
//  KeyBackground.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/20/22.
//

import SwiftUI

struct KeyBackground<Content: View>: View {
    @State var tapped: Bool = false
    var callback : () -> ()
    let keyColors: KeyColors
    let content: Content
    init(callback: @escaping () -> (), keyColors: KeyColors, @ViewBuilder content: () -> Content) {
        self.callback = callback
        self.keyColors = keyColors
        self.content = content()
    }
    var body: some View {
        ZStack {
            Capsule()
                .foregroundColor(tapped ? keyColors.downColor : keyColors.upColor)
            content
        }
        .onTouchUpGesture(tapped: $tapped, callback: callback)
    }
    
}

fileprivate extension View {
    func onTouchUpGesture(tapped: Binding<Bool>, callback: @escaping () -> Void) -> some View {
        modifier(OnTouchUpGestureModifier(tapped: tapped, callback: callback))
    }
}

private struct OnTouchUpGestureModifier: ViewModifier {
    @Binding var tapped: Bool
    let callback: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !self.tapped {
                        self.tapped = true
                    }
                }
                .onEnded { _ in
                    self.tapped = false
                    self.callback()
                })
    }
}
