//
//  Rad.swift
//  Calculator
//
//  Created by Joachim Neumann on 26/09/2021.
//

import SwiftUI

struct Rad: View {
    let radSize: CGFloat
    let yPadding: CGFloat
    var body: some View {
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
