//
//  Zoom.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct Zoom: View {
    var active: Bool
    @Binding var zoomed: Bool
    let showCalculating: Bool
    var body: some View {
        ZStack {
            if showCalculating {
                ProgressView()
                    .scaleEffect(1.5, anchor: .center)
                    .frame(width: Configuration.zoomIconSize, height: Configuration.zoomIconSize)
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
        .foregroundColor(active ? Configuration.DigitKeyProperties.textColor : Color(white: 0.5))
        .font(Font.system(size: 100, weight: .bold).monospacedDigit())
        .minimumScaleFactor(0.01)
        .frame(width: Configuration.zoomIconSize, height: Configuration.zoomIconSize)
    }
}


struct Zoom_Previews: PreviewProvider {
    static var previews: some View {
        Zoom(active: true, zoomed: .constant(false), showCalculating: true)
    }
}

