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
        HStack(spacing: 0.0) {
            VStack(spacing: 0.0) {
                ScrollView(.vertical, showsIndicators: true) {
                    Text(brain.lString.combined)
                        .foregroundColor(TE.DigitKeyProperties.textColor)
                        .font(TE.allDigitsFont)
                        .multilineTextAlignment(.leading)
                        .contextMenu {
                            Button(action: {
                                UIPasteboard.general.string = brain.lString.combined
                            }) {
                                Text("Copy to clipboard")
                                Image(systemName: "doc.on.doc")
                            }
                            if UIPasteboard.general.hasStrings {
                                Button(action: {
                                    brain.fromPasteboard()
                                }) {
                                    Text("Paste from clipboard")
                                    Image(systemName: "doc.on.clipboard")
                                }
                            }
                        }
                }
//                if brain.longDisplayString.1 != nil {
//                    Text(brain.longDisplayString.1!)
//                }
                Spacer(minLength: 0.0)
            }
            Spacer(minLength: 0.0)
        }
        .padding(.top, 0.5) /// TODO: Unterstand why this magically persuades the Scrollview to respect the SafeArea
        .padding(.bottom, 0.5) /// TODO: Unterstand why this magically persuades the Scrollview to respect the SafeArea
    }
}
