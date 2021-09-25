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
                    .font(.custom("CourierNewPSMT", size: 20)).fontWeight(.ultraLight)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}

struct AllDigitsView_Previews: PreviewProvider {
    static var previews: some View {
        AllDigitsView(text: "xx")
    }
}
