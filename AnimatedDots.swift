//
//  AnimatedDots.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/17/22.
//

import SwiftUI

struct AnimatedDots: View {
    
    @State private var shouldAnimate = false
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.white)
                .frame(width: 15, height: 15)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.3).repeatForever(), value: shouldAnimate)
            Circle()
                .fill(Color.white)
                .frame(width: 15, height: 15)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.3).repeatForever().delay(0.3), value: shouldAnimate)
            Circle()
                .fill(Color.white)
                .frame(width: 15, height: 15)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.3).repeatForever().delay(0.6), value: shouldAnimate)
        }
        .onAppear {
            self.shouldAnimate = true
        }
    }
}
