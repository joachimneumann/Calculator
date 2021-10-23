//
//  CalibratedDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 10/22/21.
//

import SwiftUI

struct NonScientificDisplay: View {
    @Binding var scrollTarget: Int?
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        if brain.nonScientific == nil {
            EmptyView()
        } else {
            let len = brain.nonScientific!.count
            let text = (len > 1000) ? String(brain.nonScientific!.prefix(1000)) + "... use copy to get all digits" : brain.nonScientific!
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    Text(text)
                        .font(t.displayFont)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(TE.DigitKeyProperties.textColor)
                        .font(t.displayFont)
                        .multilineTextAlignment(.trailing)
                        .id(1)
                }
                .disabled(!brain.zoomed)
                .onChange(of: scrollTarget) { target in
                    if let target = target {
                        scrollTarget = nil
                        withAnimation {
                            scrollViewProxy.scrollTo(target, anchor: .top)
                        }
                    }
                }
            }
        }
    }
}

struct ScientificDisplay: View {
    @Binding var scrollTarget: Int?
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        if brain.scientific == nil {
            EmptyView()
        } else {
            HStack(spacing: 0.0) {
                let len = brain.scientific!.mantissa.count
                let text = len > 1000 ? "\(brain.scientific!.mantissa)... use copy to get all digits" : brain.scientific!.mantissa
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        Text(text)
                            .font(t.displayFont)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(TE.DigitKeyProperties.textColor)
                            .multilineTextAlignment(.trailing)
                            .id(1)
                    }
                    .disabled(!brain.zoomed)
                    .onChange(of: scrollTarget) { target in
                        if let target = target {
                            scrollTarget = nil
                            withAnimation {
                                scrollViewProxy.scrollTo(target, anchor: .top)
                            }
                        }
                    }
                }
                VStack(spacing: 0.0) {
                    Text(" "+brain.scientific!.exponent)
                        .font(t.displayFont)
                        .foregroundColor(TE.DigitKeyProperties.textColor)
                        .lineLimit(1)
                    Spacer(minLength: 0.0)
                }
            }
        }
    }
}

struct CalibratedDisplay: View {
    @Binding var scrollTarget: Int?
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        Group {
            if brain.displayAsString || brain.displayAsInteger || brain.displayAsFloat {
                NonScientificDisplay(scrollTarget: $scrollTarget, brain: brain, t: t)
            } else {
                ScientificDisplay(scrollTarget: $scrollTarget, brain: brain, t: t)
            }
        }
        .offset(x: 0, y: -0.03*t.displayFontSize)
    }
}
