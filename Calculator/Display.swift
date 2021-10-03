//
//  Display.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

struct Display: View {
    let text: String
    let fontSize: CGFloat
    let textColor: Color

    var body: some View {
        HStack {
            Spacer(minLength: 0.0)
            Text(text)
                .foregroundColor(textColor)
                .font(Font.system(size: fontSize, weight: .thin).monospacedDigit())
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
}

