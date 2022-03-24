//
//  SmartDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 28.02.22.
//

import SwiftUI

struct SmartDisplay: View {
    @State var tooLongNumber: Bool = false
    let height: CGFloat
    let font: Font

    @ObservedObject var smartDisplayData = SmartDisplayData(Number("0"))
    init(_ n: Number, t: TE) {
        self.height = t.allkeysHeight + t.displayheight
        self.font = t.displayFont
        update(n)
    }
    
    mutating func update(_ n: Number) {
        smartDisplayData = SmartDisplayData(n)
    }
    var left: String { smartDisplayData.left }
    var right: String? { smartDisplayData.right }

    struct DisplayScrollView: View {
        let height: CGFloat
        let text: String
        let font: Font
        var body: some View {
            ScrollView {
                Text(text)
                    .font(font)
                    .multilineTextAlignment(.trailing)
            }
            .frame(height: height)
        }
    }
    var body: some View {
        VStack {
            // Render the real text (which might or might not be limited)
            Spacer(minLength: 0.0)
            DisplayScrollView(height: height, text: smartDisplayData.left, font: font)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .background(tooLongNumber ? .yellow : .green).opacity(0.4)

                .background(
                    // Render and measure its size
                    Text(smartDisplayData.left).lineLimit(1)
                        .background(GeometryReader { displayedGeometry in
                            Text(smartDisplayData.left)
                                .background(GeometryReader { fullGeometry in
                                    Color.clear.onAppear {
                                        self.tooLongNumber = fullGeometry.size.height > displayedGeometry.size.height
                                        print("tooLongNumber \(self.tooLongNumber)")

                                    }
                                })

                            .frame(height: .greatestFiniteMagnitude)
                        })
            )
            .hidden() // Hide the background
        }
    }
}

struct SmartDisplay_Previews: PreviewProvider {
    static var previews: some View {
        SmartDisplay(Number( "1234567345345343333453"), t: TE(appFrame: CGSize(width: 414,height: 814), isPad: false, isPortrait: true))
//        SmartDisplay("123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890")
//        ContentView(text: "1,23E6")
//        ContentView(text: "1,23456789012345678901234567E6")
    }
}
