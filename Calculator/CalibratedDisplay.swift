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
        if let nonScientific = brain.nonScientific {
            let len: Int = nonScientific.count
            let abrivated: String = "\(nonScientific.prefix(1000))...\n\nCopy to get \(brain.precisionMessage)"
            let text = (len > 1000) ? abrivated : nonScientific
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
                .onChange(of: brain.globalScrollViewTarget) { target in
                    if let target = target {
                        brain.globalScrollViewTarget = nil
                        withAnimation {
                            scrollViewProxy.scrollTo(target, anchor: .top)
                        }
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct ScientificDisplay: View {
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        if let scientific = brain.scientific {
            HStack(spacing: 0.0) {
                let len = scientific.mantissa.count
                let text = (len > 1000) ? "\(scientific.mantissa.prefix(1000))...\n\nCopy to get \(brain.precisionMessage)" : scientific.mantissa
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
                    .onChange(of: brain.globalScrollViewTarget) { target in
                        if let target = target {
                            brain.globalScrollViewTarget = nil
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
            }
        } else {
            EmptyView()
        }
    }
}

struct CalibratedDisplay: View {
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        Group {
            if brain.displayAsString || brain.displayAsInteger || brain.displayAsFloat {
                NonScientificDisplay(brain: brain, t: t)
            } else {
                ScientificDisplay(brain: brain, t: t)
            }
        }
        .offset(x: 0, y: -0.03*t.displayFontSize)
        .contextMenu {
            Button(action: {
                if brain.nonScientific != nil && (brain.displayAsString || brain.displayAsInteger || brain.displayAsFloat ) {
                    UIPasteboard.general.string = brain.nonScientific!
                } else {
                    UIPasteboard.general.string = brain.scientific?.combined
                }
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
        }    }
}
