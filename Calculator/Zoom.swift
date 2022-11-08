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
        if showCalculating {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                .scaleEffect(scaleFactor, anchor: .center)
        } else {
            VStack(spacing: 0.0) {
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
                if zoomed {
                    Image(systemName: "switch.2")
                        .font(.system(size: iconSize*0.75, weight: .thin))
                        .padding(.top, iconSize*0.25)
                        .foregroundColor(textColor)
                        .onTapGesture {
                            withAnimation() {
                            }
                        }
                }
            }
        }
    }
}


