//
//  KeysView.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct KeysView: View {
    let bottomPadding: CGFloat
    let isScientific: Bool
    let scientificTrailingPadding: CGFloat
    let height: CGFloat
//    if !t.isPad && t.isPortrait {
//        bottomPadding = t.allkeysHeight * 0.07
//    } else {
//        bottomPadding = 0
//    }

    var body: some View {
        VStack(spacing: 0.0) {
            Spacer(minLength: 0.0)
            HStack(spacing: 0.0) {
                if isScientific {
                    ScientificView(spaceBetweenKeys: 5)
                        .padding(.trailing, scientificTrailingPadding)
                }
//                NumberKeysView()
            }
        }
        .frame(height: height)
        .background(Color.black)
        .transition(.move(edge: .bottom))
        .padding(.bottom, bottomPadding)
    }
}

struct Keys_Previews: PreviewProvider {
    static var previews: some View {
        KeysView(bottomPadding: 100, isScientific: true, scientificTrailingPadding: 100, height: 100)
    }
}
