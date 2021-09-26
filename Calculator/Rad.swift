//
//  Rad.swift
//  Calculator
//
//  Created by Joachim Neumann on 26/09/2021.
//

import SwiftUI

struct Rad: View {
    @Binding var rad: Bool
    var body: some View {
        let radSize = Configuration.shared.displayFontSize*0.24
        let yPadding = Configuration.shared.displayFontSize - radSize
        HStack {
            VStack {
                if rad {
                    Text("Rad")
                        .font(Font.system(size: radSize).monospacedDigit())
                        .foregroundColor(Color.white)
                } else {
                    EmptyView()
                }
                Spacer(minLength: 0)
            }
            .padding(.leading, radSize/2)
            .padding(.top, yPadding)
            Spacer()
        }
    }
}

struct Rad_Previews: PreviewProvider {
    static var previews: some View {
        Rad(rad: .constant(true))
    }
}
