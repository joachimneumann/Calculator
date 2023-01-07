//
//  Backgrounds.swift
//  Calculator
//
//  Created by Joachim Neumann on 1/4/23.
//

import SwiftUI

struct Backgrounds: ViewModifier {
    /// Note: place   .onTapGesture { }   BEFORE   .modifier(Backgrounds( ))
    @State var color: Color = .white
    @State var upHasHappended = false
    @State var downAnimationFinished = false
    let upColor: Color
    let downColor: Color
    let downTime = 0.1
    let upTime = 0.6


    init(up upColor: Color, down downColor: Color) {
        self.color = upColor
        self.upColor = upColor
        self.downColor = downColor
        //print("BG colors:", self.upColor, self.downColor, self.color)
    }
    
    func body(content: Content) -> some View {
        content
            .background(color)
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    Task {
                        upHasHappended = false
                        downAnimationFinished = false
                        withAnimation(.easeIn(duration: downTime)) {
                            color = downColor
                        }
                        try await Task.sleep(nanoseconds: UInt64(downTime * 1_000_000_000))
                        downAnimationFinished = true
                        // print("down: upHasHappended", upHasHappended)
                        if upHasHappended {
                            withAnimation(.easeIn(duration: upTime)) {
                                color = upColor
                            }
                        }
                    }
                }
                .onEnded { _ in
                    upHasHappended = true
                    if downAnimationFinished {
                        withAnimation(.easeIn(duration: upTime)) {
                            color = upColor
                        }
                    }
                })
    }
}


struct Backgrounds_Previews: PreviewProvider {
    
    static var previews: some View {
        Text("XX")
            .modifier(Backgrounds(up: .gray, down: .white))
    }
}
