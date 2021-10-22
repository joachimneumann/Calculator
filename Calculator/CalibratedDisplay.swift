//
//  CalibratedDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 10/22/21.
//

import SwiftUI

struct IntegerOrFloatDisplay: View {
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        ScrollView {
            Text(brain.nonScientific!)
                .font(t.displayFont)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(TE.DigitKeyProperties.textColor)
                .font(t.displayFont)
                .lineLimit(100)
                .multilineTextAlignment(.trailing)
        }
        .padding(.top, 1.5) /// TODO: Unterstand why this magically persuades the Scrollview to respect the SafeArea
        .padding(.bottom, 1.5) /// TODO: Unterstand why this magically persuades the Scrollview to respect the SafeArea
        .disabled(!brain.zoomed)
    }
}

struct ScientificDisplay: View {
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        HStack(spacing: 0.0) {
            ScrollView {
                Text(brain.scientific!.mantissa)
                    .font(t.displayFont)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(TE.DigitKeyProperties.textColor)
                    //.background(Color.orange)
                    .multilineTextAlignment(.trailing)
            }
//            .padding(.top, UIApplication.shared.windows.first!.safeAreaInsets.top )
            .padding(.top, 1.5) /// TODO: Unterstand why this magically persuades the Scrollview to respect the SafeArea
            .padding(.bottom, 1.5) /// TODO: Unterstand why this magically persuades the Scrollview to respect the SafeArea
            .disabled(!brain.zoomed)
            VStack(spacing: 0.0) {
                Text(" "+brain.scientific!.exponent)
                    .font(t.displayFont)
                    .foregroundColor(TE.DigitKeyProperties.textColor)
                    //.background(Color.orange)
                    .lineLimit(1)
                Spacer(minLength: 0.0)
            }
        }
    }
}

struct CalibratedDisplay: View {
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        Group {
            if brain.displayAsString || brain.displayAsInteger || brain.displayAsFloat {
                IntegerOrFloatDisplay(brain: brain, t: t)
            } else {
                ScientificDisplay(brain: brain, t: t)
            }
        }
        .offset(x: 0, y: -0.03*t.displayFontSize)
    }
}
