//
//  SmartDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 28.02.22.
//

import SwiftUI

struct SmartDisplay: View {

    /* Indicates whether the text has been truncated in its display. */
    @State private var tooLongNumber: Bool = false


    private var text: String

    init(_ text: String) {
        self.text = text
    }

    struct DisplayScrollView: View {
        let text: String
        var body: some View {
            Text(text)
                .multilineTextAlignment(.trailing)
        }
    }
    var body: some View {
        VStack {
            // Render the real text (which might or might not be limited)
            DisplayScrollView(text: text)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .background(tooLongNumber ? .yellow : .green).opacity(0.4)

                .background(
                    // Render and measure its size
                    Text(text).lineLimit(1)
                        .background(GeometryReader { displayedGeometry in

                            // Render the text without restrictions and measure its size
                            ZStack {
                                Text(self.text)
                                    .background(GeometryReader { fullGeometry in
                                        Color.clear.onAppear {
                                            self.tooLongNumber = fullGeometry.size.height > displayedGeometry.size.height
                                        }
                                    })
                            }
                            .frame(height: .greatestFiniteMagnitude)
                        })
                        .hidden() // Hide the background
            )
        }
    }
}
