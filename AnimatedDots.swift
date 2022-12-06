//
//  AnimatedDots.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/17/22.
//

import SwiftUI

struct AnimatedDots: View {
    let color: Color

    let small = 0.6
    let large = 0.8
    let size = 15.0
    let duration = 0.4

    @State private var shouldAnimate = false
    @State private var shouldShow = false

    var body: some View {
        let color = shouldShow ? color : Color.black
        HStack(spacing: 0.0) {
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .scaleEffect(shouldAnimate ? large : small)
                .animation(Animation.easeInOut(duration: duration).repeatForever(), value: shouldAnimate)
                .scaleEffect(shouldAnimate ? large : small)
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .scaleEffect(shouldAnimate ? large : small)
                .animation(Animation.easeInOut(duration: duration).repeatForever().delay(duration/2), value: shouldAnimate)
                .scaleEffect(shouldAnimate ? large : small)
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .scaleEffect(shouldAnimate ? large : small)
                .animation(Animation.easeInOut(duration: duration).repeatForever().delay(duration), value: shouldAnimate)
                .scaleEffect(shouldAnimate ? large : small)
        }
        .onAppear {
            self.shouldAnimate = true
            withAnimation() {
                self.shouldShow = true
            }
        }
    }
}

struct Dots_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedDots(color: Color.gray)
            .background(Color.black)
    }
}

