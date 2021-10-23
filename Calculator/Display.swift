//
//  Display.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

struct DisplayText: View {
    let text: String
    let font: Font
    var body: some View {
        Text(text)
            .font(font)

    }
}
struct Display: View {
    @Binding var scrollTarget: Int?
    @ObservedObject var brain: Brain
    let t: TE
    @State var initialHeight: CGFloat? = nil

    var body: some View {
        if !brain.calibrated {
            VStack(alignment: .leading) {
                DisplayText(text: "0", font: t.displayFont)
                    .overlay(
                        GeometryReader { proxy in
                            Color.clear.onAppear {
                                initialHeight = proxy.size.height
//                                print("initialHeight \(initialHeight ?? -1)")
                            }
                        }
                    )
                if let initialHeight = initialHeight {
                    ForEach((1..<40), id: \.self) { i in
                        let s = String(repeating: "1", count: i)
                        ScrollView {
                            DisplayText(text: s, font: t.displayFont)
                                .overlay(
                                    GeometryReader { proxy in
                                        Color.clear.onAppear {
                                            if proxy.size.height > initialHeight {
                                                if i-1 < brain.digitsInDisplayInteger {
                                                    brain.digitsInDisplayInteger = i-1
                                                }
//                                                print("i \(i) \(s.count) digitsInDisplayInteger \(brain.digitsInDisplayInteger) proxy.size.height \(proxy.size.height) \(initialHeight) \(s)")
                                            }
                                        }
                                    }
                                )
                        }
                    }

                    ForEach((3..<40), id: \.self) { i in
                        let s = "1,"+String(repeating: "1", count: i-1)
                        ScrollView {
                            DisplayText(text: s, font: t.displayFont)
                                .overlay(
                                    GeometryReader { proxy in
                                        Color.clear.onAppear {
                                            if proxy.size.height > initialHeight {
                                                if i-1 < brain.digitsInDisplayFloat {
                                                    brain.digitsInDisplayFloat = i-1
                                                }
                                            }
//                                            print("i \(i) digitsInDisplayFloat \(brain.digitsInDisplayFloat) \(s.count) proxy.size.height \(proxy.size.height) \(initialHeight) \(s)")
                                        }
                                    }
                                )
                        }
                    }

                    ForEach((5..<40), id: \.self) { i in
                        let s = "1,"+String(repeating: "1", count: i-1-3)+" e77"
                        ScrollView {
                            DisplayText(text: s, font: t.displayFont)
                                .overlay(
                                    GeometryReader { proxy in
                                        Color.clear.onAppear {
                                            if proxy.size.height > initialHeight {
                                                if i-1 < brain.digitsInDisplayScientific {
                                                    brain.digitsInDisplayScientific = i-1
                                                }
                                            }
//                                            print("i \(i) digitsInDisplayScientific \(brain.digitsInDisplayScientific) \(s.count) proxy.size.height \(proxy.size.height) \(initialHeight) \(s)")
                                            brain.calibrated = true
                                        }
                                    }
                                )
                        }
                    }

                }
            }
        } else {
//            let _ = print("len \(brain.digitsInDisplayInteger)")
            CalibratedDisplay(scrollTarget: $scrollTarget, brain: brain, t: t)
        }
    }
    
}

