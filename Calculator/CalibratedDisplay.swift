//
//  CalibratedDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 10/22/21.
//

import SwiftUI

struct NonScientificDisplay: View {
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        if let text = brain.displayData.nonScientific {
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
                .onChange(of: brain.scrollViewTarget) { target in
                    if let target = target {
                        brain.scrollViewTarget = nil
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
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        if let scientific = brain.displayData.scientific {
            HStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        Text(scientific.mantissa)
                            .font(t.displayFont)
                            .foregroundColor(TE.DigitKeyProperties.textColor)
                            .multilineTextAlignment(.trailing)
                            .id(1)
                    }
                    .disabled(!brain.zoomed)
                    .onChange(of: brain.scrollViewTarget) { target in
                        if let target = target {
                            brain.scrollViewTarget = nil
                            withAnimation {
                                scrollViewProxy.scrollTo(target, anchor: .top)
                            }
                        }
                    }
                }
                VStack(spacing: 0.0) {
                    Text(" "+scientific.exponent)
                        .font(t.displayFont)
                        .foregroundColor(TE.DigitKeyProperties.textColor)
                        .lineLimit(1)
                    Spacer(minLength: 0.0)
                }
                .layoutPriority(1)
            }
        }
    }
}

struct CalibratedDisplay: View {
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        Group {
            if brain.displayData.nonScientific != nil {
                NonScientificDisplay(brain: brain, t: t)
            } else if brain.displayData.scientific != nil {
                ScientificDisplay(brain: brain, t: t)
            } else {
                EmptyView()
            }
        }
        .offset(x: 0, y: -0.03*t.displayFontSize)
        .contextMenu {
            Button(action: {
                if brain.displayData.nonScientific != nil {
                    UIPasteboard.general.string = brain.displayData.nonScientific!
                } else {
                    UIPasteboard.general.string = brain.displayData.scientific?.combined
                }
            }) {
                Text("Copy to clipboard")
                Image(systemName: "doc.on.doc")
            }
            if UIPasteboard.general.hasStrings {
                Button(action: {
                    brain.asyncOperation("fromPasteboard")
                }) {
                    Text("Paste from clipboard")
                    Image(systemName: "doc.on.clipboard")
                }
            }
        }
    }
}
