//
//  SmartDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 28.02.22.
//

import SwiftUI

struct SmartDisplay: View {
    let height: CGFloat
    let smallFont: Font
    let largeFont: Font
    let fontFactor: Double
    var r: SingleLengthRepresentation

    @ObservedObject var smartDisplayData = SmartDisplayData(Number("0"))
    init(r: SingleLengthRepresentation, t: TE) {
        self.height = t.allkeysHeight + t.displayheight
        self.smallFont = t.smallDisplayFont
        self.largeFont = t.largeDisplayFont
        self.fontFactor = 0.7
        self.r = r
    }
    
    var body: some View {
        VStack {
            Spacer(minLength: 0.0)
            ScrollView {
                if let right = r.right {
                    let _ = print(r.left + right)
                    HStack {
                        Text(r.left)
                        VStack {
                            Text(right)
                            Spacer(minLength: 0)
                        }
                    }
                    .font(smallFont)
                    .multilineTextAlignment(.trailing)
                } else {
                    if r.isAbreviated {
                        Text(r.left)
                            .font(smallFont)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(1)
                    } else {
                        Text(r.left)
                            .font(largeFont)
                            .multilineTextAlignment(.trailing)
                            .minimumScaleFactor(fontFactor)
                            .lineLimit(1)
                    }
                }
            }
            .frame(height: height)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct SmartDisplay_Previews: PreviewProvider {
    static var previews: some View {
        let r = SingleLengthRepresentation(length: 9)
        let _ = r.update(Number("1231383222222222"))
        SmartDisplay(r: r, t: TE(appFrame: CGSize(width: 414,height: 814), isPad: false, isPortrait: true))
//        SmartDisplay("123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890")
//        ContentView(text: "1,23E6")
//        ContentView(text: "1,23456789012345678901234567E6")
    }
}


//                .background(
//                    // Render and measure its size
//                    Text(smartDisplayData.left).lineLimit(1)
//                        .background(GeometryReader { displayedGeometry in
//                            Text(smartDisplayData.left)
//                                .background(GeometryReader { fullGeometry in
//                                    Color.clear.onAppear {
//                                        self.tooLongNumber = fullGeometry.size.height > displayedGeometry.size.height
//                                        print("tooLongNumber \(self.tooLongNumber)")
//
//                                    }
//                                })
//
//                            .frame(height: .greatestFiniteMagnitude)
//                        })
//            )
//            .hidden() // Hide the background
