//
//  KeyBackground.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/20/22.
//

import SwiftUI

struct KeyBackground<Content: View>: View {
    @State var tapped: Bool = false
    @State var illegal: Bool = false
    let enabled: Bool
    var callback : () -> ()
    let keyColors: KeyColors
    let content: Content
    init(enabled: Bool, callback: @escaping () -> (), keyColors: KeyColors, @ViewBuilder content: () -> Content) {
        self.callback = callback
        self.keyColors = keyColors
        self.content = content()
        self.enabled = enabled
        self.illegal = false
    }
    var body: some View {
        ZStack {
            Capsule()
                .foregroundColor(illegal ? Color.red : tapped ? Color(uiColor: keyColors.downColor) : Color(uiColor: keyColors.upColor))
            content
        }
        .onTouchUpGesture(enabled: enabled, tapped: $tapped, illegal: $illegal, callback: callback)
    }
    
}

fileprivate extension View {
    func onTouchUpGesture(enabled: Bool, tapped: Binding<Bool>, illegal: Binding<Bool>, callback: @escaping () -> Void) -> some View {
        modifier(OnTouchUpGestureModifier(enabled: enabled, tapped: tapped, illegal: illegal, callback: callback))
    }
}

private struct OnTouchUpGestureModifier: ViewModifier {
    let enabled: Bool
    @Binding var tapped: Bool
    @Binding var illegal: Bool
    let callback: () -> Void
    @State var downAnimationFinished = false
    @State var upHasHappended = false
    let downTime = 0.1
    let upTime = 0.3
    
    ///  The animation will always wait for the downanimation to finish
    ///  This is a more clear visual feedback to the user that the button has been pressed
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if self.enabled {
                        self.downAnimationFinished = false
                        upHasHappended = false
                        if !self.tapped {
                            withAnimation(.easeIn(duration: downTime)) {
                                self.tapped = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + downTime) {
                                self.downAnimationFinished = true
                                if upHasHappended {
                                    withAnimation(.easeIn(duration: upTime)) {
                                        self.tapped = false
                                    }
                                }
                            }
                        }
                    } else {
                        withAnimation(.easeIn(duration: downTime)) {
                            illegal = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + downTime) {
                                illegal = false
                            }
                        }
                    }
                }
                .onEnded { _ in
                    if self.enabled {
                        self.callback()
                        if self.downAnimationFinished {
                            withAnimation(.easeIn(duration: upTime)) {
                                self.tapped = false
                            }
                        } else {
                            upHasHappended = true
                        }
                    } else {
                        withAnimation(.easeIn(duration: downTime)) {
                            illegal = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + downTime) {
                                illegal = false
                            }
                        }
                    }
                })
    }
}
