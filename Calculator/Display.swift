//
//  Display.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

struct Display: View {
    @ObservedObject var brain: Brain
    let t: TE
    @State var hasMoreLines: Bool = false
    @Binding var mantissaTextSize: CGSize

    struct ExponentText: View {
        let text: String
        let brain: Brain
        let t: TE
        var body: some View {
            let fg: Color = TE.DigitKeyProperties.textColor
            let font: Font = t.displayFont
            let maxHeight: CGFloat = t.remainingAboveKeys
            let bottom: CGFloat = 0.0//(brain.zoomed ? t.allkeysHeight : 0.0)
            Text(text)
                .foregroundColor(fg)
                .font(font)
                .lineLimit(1)
                //.minimumScaleFactor(0.1)
                .frame(maxHeight: maxHeight, alignment: .bottom)
                .padding(.bottom, bottom)
        }
    }

    struct LongText: View {

        /* Indicates whether the user want to see all the text or not. */
        @State private var expanded: Bool = false

        /* Indicates whether the text has been truncated in its display. */
        @State private var truncated: Bool = false

        private var text: String

        var lineLimit = 1

        init(_ text: String) {
            self.text = text
        }

        var body: some View {
            VStack(alignment: .leading) {
                // Render the real text (which might or might not be limited)
                Text(text)
                    .lineLimit(expanded ? nil : lineLimit)

                    .background(

                        // Render the limited text and measure its size
                        Text(text).lineLimit(lineLimit)
                            .background(GeometryReader { displayedGeometry in

                                // Create a ZStack with unbounded height to allow the inner Text as much
                                // height as it likes, but no extra width.
                                ZStack {

                                    // Render the text without restrictions and measure its size
                                    Text(self.text)
                                        .background(GeometryReader { fullGeometry in

                                            // And compare the two
                                            Color.clear.onAppear {
                                                self.truncated = fullGeometry.size.height > displayedGeometry.size.height
                                            }
                                        })
                                }
                                .frame(height: .greatestFiniteMagnitude)
                            })
                            //.hidden() // Hide the background
                )
                if truncated { toggleButton }
            }
        }
        var toggleButton: some View {
            Button(action: { self.expanded.toggle() }) {
                Text(self.expanded ? "Show less" : "Show more")
                    .font(.caption)
            }
        }
    }
    
    @State private var offset : CGPoint = .zero

    func rectReader() -> some View {
        return GeometryReader { (geometry) -> AnyView in
            let offset : CGPoint = CGPoint.init(
                x: -geometry.frame(in: .global).minX,
                y: -geometry.frame(in: .global).minY
            )
            if self.offset == .zero {
                DispatchQueue.main.async {
                    self.offset = offset
                    print("offset \(offset)")
                }
            }
            return AnyView(Rectangle().fill(Color.clear))
        }
    }
    
    var body: some View {
        let trailing: CGFloat = (t.isLandscape && !t.isPad ? t.widerKeySize.width : t.widerKeySize.width*0.2) - TE.reducedTrailing
        let leading: CGFloat = t.keySize.width * 0.5
        HStack(spacing: 0.0) {
            Spacer(minLength: 0.0)
            let mantissa = brain.mantissa(t.digitsInSmallDisplay)!
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                                Text(mantissa)
                                    .padding(8)
                                    .frame(width: 1024, height: 1024)
                                    .background(Color.orange)
                                    .border(Color.red)
                            }
                            .background(rectReader())
                            .offset(x: self.offset.x, y: self.offset.y)
//
////                LongText(mantissa)
//                Text("s"+mantissa)
//                    .foregroundColor(TE.DigitKeyProperties.textColor)
//                    .font(t.displayFont)
//                    .multilineTextAlignment(.leading)
//                    .background(GeometryReader { displayedGeometry in
//                        Color.red.onAppear {
//                            mantissaTextSize = displayedGeometry.size
//                            let _ = print("displayedGeometry inside = \(displayedGeometry.size)")
//                        }
//                    })
                    //.background(Color.green.opacity(0.3))

//                        // Create a ZStack with unbounded height to allow the inner Text as much
//                        // height as it likes, but no extra width.
//                        ZStack {
//
//                            // Render the text without restrictions and measure its size
//                            let _ = print("hasMoreLines0 \(hasMoreLines)")
//                            Text(mantissa)//+mantissa+mantissa+mantissa+mantissa+mantissa)
//                                .background(GeometryReader { fullGeometry in
//                                    // And compare the two
//                                    Color.clear.onAppear {
//                                        let _ = print("hasMoreLines1 \(hasMoreLines) \(fullGeometry.size.height) \(displayedGeometry.size.height)")
//                                        hasMoreLines = fullGeometry.size.height < displayedGeometry.size.height
//                                        print("hasMoreLines2 \(hasMoreLines)")
//                                    }
//                                })
//                        }
//                        .frame(height: .greatestFiniteMagnitude)
//                        //.hidden() // Hide the background
//                    })
                                
                    .background(Color.green.opacity(0.3))
            }
            //.disabled(!brain.zoomed || !brain.hasMoreDigits(t.digitsInSmallDisplay))
            if let exponent = brain.exponent(t.digitsInSmallDisplay) {
                ExponentText(text: " "+exponent, brain: brain, t: t)
            }
        }
        .padding(.leading, leading)
        .padding(.trailing, trailing)
//        .background(Color.yellow.opacity(0.3))
    }
    
}

