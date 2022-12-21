//
//  AnimatedDots.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/17/22.
//

import SwiftUI

struct AnimatedDots: View {
    let dotDiamater: CGFloat

    let small = 0.6
    let large = 0.8
    let duration = 0.4

    @State private var shouldAnimate = false

    var body: some View {
        HStack(spacing: 0.0) {
            Circle()
                .fill(Color.gray)
                .frame(width: dotDiamater, height: dotDiamater)
                .scaleEffect(shouldAnimate ? large : small)
                .animation(Animation.easeInOut(duration: duration).repeatForever(), value: shouldAnimate)
                .scaleEffect(shouldAnimate ? large : small)
            Circle()
                .fill(.gray)
                .frame(width: dotDiamater, height: dotDiamater)
                .scaleEffect(shouldAnimate ? large : small)
                .animation(Animation.easeInOut(duration: duration).repeatForever().delay(duration/2), value: shouldAnimate)
                .scaleEffect(shouldAnimate ? large : small)
            Circle()
                .fill(.gray)
                .frame(width: dotDiamater, height: dotDiamater)
                .scaleEffect(shouldAnimate ? large : small)
                .animation(Animation.easeInOut(duration: duration).repeatForever().delay(duration), value: shouldAnimate)
                .scaleEffect(shouldAnimate ? large : small)
        }
        .onAppear {
            self.shouldAnimate = true
        }
    }
}

struct Dots_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedDots(dotDiamater: 15)
            .background(Color.black)
    }
}

