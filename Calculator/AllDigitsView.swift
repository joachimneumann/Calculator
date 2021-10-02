//
//  AllDigitsView.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct AllDigitsView: View {
    var brain: Brain
    let textColor: Color // for copy/paste animation
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: true) {
                    Text(brain.longDisplayString.0)
                        .foregroundColor(textColor)
                        .font(Configuration.allDigitsFont)
                        .multilineTextAlignment(.leading)
                }
                if brain.longDisplayString.1 != nil {
                    Text(brain.longDisplayString.1!)
                }
                Spacer(minLength: 0)
            }
            Spacer(minLength: 0)
        }
        .padding(.top, 0.2) /// TODO: Unterstand why this magically persuades the Scrollview to respect the SafeArea
    }
}

struct AllDigitsView_Previews: PreviewProvider {
    static var previews: some View {
        AllDigitsView(brain: Brain(), textColor: Color.white)
    }
}
