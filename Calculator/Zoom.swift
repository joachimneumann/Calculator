//
//  Zoom.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct Zoom: View {
    @Binding var scrollTarget: Int?
    let iconSize: CGFloat
    let scaleFactor: CGFloat
    let textColor: Color
    @Binding var zoomed: Bool
    let showCalculating: Bool
    var body: some View {
        ZStack {
            if showCalculating {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .scaleEffect(scaleFactor, anchor: .center)
            } else {
                Image(systemName: "plus.circle.fill")
                .font(.system(size: iconSize, weight: .thin))
                .foregroundColor(textColor)
                .rotationEffect(zoomed ? .degrees(-45) : .degrees(0))
                .onTapGesture {
                    withAnimation() {
                        zoomed.toggle()
                        if !zoomed {
                            scrollTarget = 1
                        }
                    }
                }
            }
        }
    }
}


