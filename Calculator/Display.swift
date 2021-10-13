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

    struct DisplayText: View {
        let text: String
        let brain: Brain
        let t: TE
        var body: some View {
            let fg: Color = TE.DigitKeyProperties.textColor
            let font: Font = t.displayFont
            let maxHeight: CGFloat = t.remainingAboveKeys
            let bottom: CGFloat = (brain.highPrecision ? t.allkeysHeight : 0.0)
            Text(text)
                .foregroundColor(fg)
                .font(font)
                .lineLimit(1)
                //.minimumScaleFactor(0.1)
                .frame(maxHeight: maxHeight, alignment: .bottom)
                .padding(.bottom, bottom)
        }
    }

    
    
    var body: some View {
        let trailing: CGFloat = (t.isLandscape && !t.isPad ? t.widerKeySize.width : t.widerKeySize.width*0.2) - TE.reducedTrailing
        let leading: CGFloat = t.keySize.width * 0.5
        HStack(spacing: 0.0) {
            Spacer(minLength: 0.0)
//            if brain.highPrecision {
                ScrollView(.vertical, showsIndicators: true) {
                    Text(brain.lMantissa(TE.digitsInAllDigitsDisplay))
                        .foregroundColor(TE.DigitKeyProperties.textColor)
                        .font(t.displayFont)
                        .multilineTextAlignment(.leading)
                        .background(Color.green.opacity(0.3))
                }
                .background(Color.green.opacity(0.3))
//            } else {
//                DisplayText(text: brain.sMantissa(t.digitsInSmallDisplay), brain: brain, t: t)
//                    .background(Color.green.opacity(0.3))
//            }
            if let exponent = brain.sExponent(t.digitsInSmallDisplay) {
                DisplayText(text: " "+exponent, brain: brain, t: t)
                    .frame(maxWidth: 130)
            }
        }
        .padding(.leading, leading)
        .padding(.trailing, trailing)
//        .background(Color.yellow.opacity(0.3))
    }
    
}

