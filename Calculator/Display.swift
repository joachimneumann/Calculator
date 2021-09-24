//
//  Display.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

struct Display: View {
    let text: String
    
    var body: some View {
        HStack {
            Spacer(minLength: 0)
            Text(text)
                .foregroundColor(Color.white)
                // CourierNewPSMT: space has same width as digit
                .font(.custom("CourierNewPSMT", size: Configuration.shared.displayFontSize)).fontWeight(.ultraLight)
                .lineLimit(1)
        }
    }
}

struct Display_Previews: PreviewProvider {
    static var previews: some View {
        Display(text: "0")
    }
}
