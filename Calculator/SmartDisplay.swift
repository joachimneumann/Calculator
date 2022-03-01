//
//  SmartDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 28.02.22.
//

import SwiftUI

struct SmartDisplay: View {

    /// does the number fit into one line?
    @State private var tooLongNumber: Bool = false

    let text: String
    let height: CGFloat

    struct DisplayScrollView: View {
        let height: CGFloat
        let text: String
        var body: some View {
            ScrollView {
                Text(text)
                    .multilineTextAlignment(.trailing)
            }
            .frame(height: height)
        }
    }
    var body: some View {
        VStack {
            // Render the real text (which might or might not be limited)
            Spacer(minLength: 0.0)
            DisplayScrollView(height: 100, text: text)
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

struct SmartDisplay_Previews: PreviewProvider {
    static var previews: some View {
        SmartDisplay(text: "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890", height: 200)
//        SmartDisplay("123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890")
//        ContentView(text: "1,23E6")
//        ContentView(text: "1,23456789012345678901234567E6")
    }
}
