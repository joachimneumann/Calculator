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
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                Text(brain.nonScientific!)
                    .font(t.displayFont)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(TE.DigitKeyProperties.textColor)
                    .font(t.displayFont)
                    .lineLimit(100)
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

struct ScientificDisplay: View {
    @Binding var scrollTarget: Int?
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        HStack(spacing: 0.0) {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    Text(brain.scientific!.mantissa)
                        .font(t.displayFont)
                        .frame(maxWidth: .infinity)
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
