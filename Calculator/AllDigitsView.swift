//
//  AllDigitsView.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct AllDigitsView: View {
    var brain: Brain
    
    var body: some View {
        let _ = print(brain.longDisplayString)
        ScrollView(.vertical, showsIndicators: true) {
            Text(brain.longDisplayString)
                .foregroundColor(Color.white)
                .font(.custom("CourierNewPSMT", size: 19))
                .multilineTextAlignment(.leading)
        }
        .padding(.top, 0.2) /// This magically persuads the Scrollview to respect the SafeArea
    }
}

struct AllDigitsView_Previews: PreviewProvider {
    static var previews: some View {
        AllDigitsView(brain: Brain())
    }
}
