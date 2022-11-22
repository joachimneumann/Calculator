//
//  AnimatedDots.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/17/22.
//

import SwiftUI

struct AnimatedDots: View {
    
    @State private var shouldAnimate = false
    let color: Color
    let small = 0.5
    let large = 0.7
    let size = 15.0
    let duration = 0.5
    var body: some View {
        HStack(spacing: 0.0) {
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .scaleEffect(shouldAnimate ? large : small)
                .animation(Animation.easeInOut(duration: duration).repeatForever(), value: shouldAnimate)
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .scaleEffect(shouldAnimate ? large : small)
                .animation(Animation.easeInOut(duration: duration).repeatForever().delay(duration/2), value: shouldAnimate)
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .scaleEffect(shouldAnimate ? large : small)
                .animation(Animation.easeInOut(duration: duration).repeatForever().delay(duration), value: shouldAnimate)
        }
        .onAppear {
            self.shouldAnimate = true
        }
    }
}

struct Dots_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedDots(color: Color.red)
            .background(Color.black)
    }
}

