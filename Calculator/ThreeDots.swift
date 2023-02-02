//
//  ThreeDots.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/17/22.
//

import SwiftUI

struct ThreeDots: View {
    private let small = 0.6
    private let large = 0.8
    private let duration = 0.4

    @State private var shouldAnimate = false

    var body: some View {
        GeometryReader { (geo) in
            let dotDiameter = geo.size.width / 3
            HStack(spacing: 0.0) {
                Circle()
                    .fill(Color.gray)
                    .frame(width: dotDiameter, height: dotDiameter)
                    .scaleEffect(shouldAnimate ? large : small)
                    .animation(Animation.easeInOut(duration: duration).repeatForever(), value: shouldAnimate)
                    .scaleEffect(shouldAnimate ? large : small)
                Circle()
                    .fill(.gray)
                    .frame(width: dotDiameter, height: dotDiameter)
                    .scaleEffect(shouldAnimate ? large : small)
                    .animation(Animation.easeInOut(duration: duration).repeatForever().delay(duration/2), value: shouldAnimate)
                    .scaleEffect(shouldAnimate ? large : small)
                Circle()
                    .fill(.gray)
                    .frame(width: dotDiameter, height: dotDiameter)
                    .scaleEffect(shouldAnimate ? large : small)
                    .animation(Animation.easeInOut(duration: duration).repeatForever().delay(duration), value: shouldAnimate)
                    .scaleEffect(shouldAnimate ? large : small)
            }
        }
        .onAppear {
            self.shouldAnimate = true
        }
    }
}

struct Dots_Previews: PreviewProvider {
    static var previews: some View {
        ThreeDots()
            .background(Color.black)
    }
}

