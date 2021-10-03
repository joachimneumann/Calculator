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
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .scaleEffect(1.4, anchor: .center)
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
                .foregroundColor(active ? textColor : Color(white: 0.5))
                .onTapGesture {
                    withAnimation(.easeIn) {
                        zoomed.toggle()
                    }
                }
            }
        }
        .frame(width: iconSize, height: iconSize)
    }
}


