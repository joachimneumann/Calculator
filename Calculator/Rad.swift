//
//  Rad.swift
//  Calculator
//
//  Created by Joachim Neumann on 26/09/2021.
//

import SwiftUI

struct Rad: View {
    var body: some View {
        let radSize = Configuration.displayFontSize*0.25
        let yPadding = Configuration.displayFontSize - radSize*1.4
        HStack {
            VStack {
                Text("Rad")
                    .font(Font.system(size: radSize).monospacedDigit())
                    .foregroundColor(Color.white)
                Spacer(minLength: 0)
            }
            .padding(.leading, radSize)
            .padding(.top, yPadding)
            Spacer()
        }
    }
}

struct Rad_Previews: PreviewProvider {
    static var previews: some View {
        Rad()
    }
}
