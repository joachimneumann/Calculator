//
//  AllDigitsView.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct AllDigitsView: View {
    var text: String
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            ScrollView(.vertical, showsIndicators: true) {
                Text(text)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: Configuration.shared.displayFontSize, weight: .thin).monospacedDigit())
                    //.font(.custom("CourierNewPSMT", size: Configuration.shared.displayFontSize)).fontWeight(.ultraLight)
                    .multilineTextAlignment(.trailing)
                //                    .padding(.trailing, 10)
            }
        }
    }
}

struct AllDigitsView_Previews: PreviewProvider {
    static var previews: some View {
        AllDigitsView(text: "xx")
    }
}
