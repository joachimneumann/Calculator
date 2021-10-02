//
//  Zoom.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct Zoom: View {
    var active: Bool
    let iconSize: CGFloat
    let textColor: Color
    @Binding var zoomed: Bool
    let showCalculating: Bool
    var body: some View {
        ZStack {
            if showCalculating {
                ProgressView()
                    .scaleEffect(1.5, anchor: .center)
                    .frame(width: iconSize, height: iconSize)
            } else {
                Group {
                    if zoomed {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                    } else {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                    }
                }
                .onTapGesture {
                    withAnimation(.easeIn) {
                        zoomed.toggle()
                    }
                }
            }
        }
        .foregroundColor(active ? textColor : Color(white: 0.5))
        .font(Font.system(size: 100, weight: .bold).monospacedDigit())
        .minimumScaleFactor(0.01)
        .frame(width: iconSize, height: iconSize)
    }
}


