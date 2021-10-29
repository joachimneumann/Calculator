//
//  Precision.swift
//  Calculator
//
//  Created by Joachim Neumann on 10/23/21.
//

import SwiftUI

struct Precision: View {
    @ObservedObject var brain: Brain
    let textColor: Color
    let iconSize: CGFloat
    var body: some View {
        Image(systemName: "00.circle")
            .resizable()
            .foregroundColor(textColor)
            .onTapGesture {
                withAnimation(.easeIn) {
                    if brain.precision == TE.lowPrecision {
                        brain.precision = TE.mediumPrecision
                        brain.messageToUser = TE.mediumPrecisionString
                    } else if brain.precision == TE.mediumPrecision {
                        brain.precision = TE.highPrecision
                        brain.messageToUser = TE.highPrecisionString
                    } else {
                        // high precision
                        brain.precision = TE.lowPrecision
                        brain.messageToUser = TE.lowPrecisionString
                    }
                }
            }
            .frame(width: iconSize, height: iconSize)
    }
}
