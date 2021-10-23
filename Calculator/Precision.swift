//
//  Precision.swift
//  Calculator
//
//  Created by Joachim Neumann on 10/23/21.
//

import SwiftUI

struct Precision: View {
    @ObservedObject var brain: Brain
    let iconSize: CGFloat
    var body: some View {
        Group {
            if brain.isHighPrecision {
                Image(systemName: "h.circle.fill")
                    .resizable()
            } else {
                Image(systemName: "m.circle.fill")
                    .resizable()
            }
        }
        .foregroundColor(TE.DigitKeyProperties.textColor)
        .onTapGesture {
            withAnimation(.easeIn) {
                brain.isHighPrecision.toggle()
                if brain.isHighPrecision {
                    brain.precision = TE.highPrecision
                    brain.messageToUser = TE.highPrecisionString
                } else {
                    brain.precision = TE.lowPrecision
                    brain.messageToUser = TE.lowPrecisionString
                }
            }
        }
        .frame(width: iconSize, height: iconSize)
    }
}
