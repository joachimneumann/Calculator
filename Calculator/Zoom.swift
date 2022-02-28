//
//  Zoom.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct Zoom: View {
    @Binding var scrollTarget: Int?
    let iconName: String
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
                Image(systemName: iconName)
                .resizable()
                .foregroundColor(textColor)
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
        .frame(width: iconSize, height: iconSize)
    }
}


