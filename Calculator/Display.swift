//
//  Display.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

struct Display: View {
    let text: String
    let textColor: Color

    var body: some View {
        HStack {
            Spacer(minLength: 0)
            Text(text)
                .foregroundColor(textColor)
                .font(Font.system(size: Configuration.shared.displayFontSize, weight: .thin).monospacedDigit())
                .lineLimit(1)
        }
    }
}

struct Display_Previews: PreviewProvider {
    static var previews: some View {
        Display(text: "0", textColor: Color.white)
    }
}
