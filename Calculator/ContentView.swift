//
//  ContentView.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var brain: Brain
    var t: TE
    
    struct Keys: View {
        let brain: Brain
        var t: TE
        var body: some View {
            // the keys
            HStack(spacing: 0.0) {
                if t.isLandscape {
                    ScientificKeys(brain: brain, t: t)
                        .padding(.trailing, t.spaceBetweenkeys)
                }
                NumberKeys(brain: brain, t: t)
                Spacer(minLength: 0.0)
            }
            .transition(.move(edge: .bottom))
        }
    }
    
    struct LandscapeZoomAndCo : View {
        @Binding var zoomed: Bool
        let brain: Brain
        var t: TE
        let active: Bool
        let iconSize: CGFloat
        let fontSize: CGFloat
        let zoomWidth: CGFloat
        let zoomHeight: CGFloat
        let copyCallback: () -> ()
        let pasteCallback: (_ s: String) -> ()
        var body: some View {
            ZStack {
                VStack(spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    Zoom(active: active,
                         iconSize: iconSize,
                         textColor: TE.DigitKeyProperties.textColor,
                         zoomed: $zoomed,
                         showCalculating: brain.showCalculating)
                        .frame(width: zoomWidth, height: zoomHeight, alignment: .center)
                        .padding(.bottom, t.allkeysHeight + t.spaceBetweenkeys)
                }
            }
        }
    }
    
    struct PortraitZoomAndCo : View {
        @Binding var zoomed: Bool
        let brain: Brain
        let active: Bool
        let iconSize: CGFloat
        let fontSize: CGFloat
        let zoomWidth: CGFloat
        let zoomHeight: CGFloat
        let copyCallback: () -> ()
        let pasteCallback: (_ s: String) -> ()
        var body: some View {
            HStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                Zoom(active: active,
                     iconSize: iconSize,
                     textColor: TE.DigitKeyProperties.textColor,
                     zoomed: $zoomed,
                     showCalculating: brain.showCalculating)
                    .frame(width: zoomWidth, height: zoomHeight, alignment: .center)
            }
        }
    }


    struct Rad: View {
        let keySize: CGSize
        var body: some View {
            VStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                Text("Rad")
                    .font(Font.system(size: keySize.height*0.27).monospacedDigit())
                    .foregroundColor(TE.DigitKeyProperties.textColor)
                    .padding(.leading, keySize.height*0.27)
                    .padding(.bottom, keySize.height*0.1)
            }
        }
    }
    
    func copyShort() {
        UIPasteboard.general.string = brain.sString(t.digitsInSmallDisplay)
    }

    func copyLong() {
        UIPasteboard.general.string = brain.lString
    }

    func paste(_ s: String) {
        brain.fromPasteboard(s)
    }
    
    var body: some View {
        ZStack {
            if t.isLandscape && !t.isPad {
                HStack(spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    LandscapeZoomAndCo(zoomed: $brain.highPrecision,
                                       brain: brain,
                                       t: t,
                                       active: brain.hasMoreDigits(t.digitsInSmallDisplay),
                                       iconSize: t.keySize.height * 0.7,
                                       fontSize: t.keySize.height*0.27,
                                       zoomWidth: t.widerKeySize.width,
                                       zoomHeight: t.keySize.height,
                                       copyCallback: copyLong,
                                       pasteCallback: paste)
                }
            }

            VStack(spacing: 0.0) {
                // everything is in here
                HStack(spacing: 0.0) {
                    // everyting above the keys
                    if brain.rad && !brain.highPrecision && t.isLandscape {
                        Rad(keySize: t.keySize)
                    }
                    Spacer(minLength: 0.0)
                    VStack(spacing: 0.0) {
                        if !t.isLandscape || t.isPad {
                        PortraitZoomAndCo(zoomed: $brain.highPrecision,
                                          brain: brain,
                                          active: brain.hasMoreDigits(t.digitsInSmallDisplay),
                                          iconSize: t.keySize.height * 0.7,
                                          fontSize: t.keySize.height*0.27,
                                          zoomWidth: t.widerKeySize.width,
                                          zoomHeight: t.keySize.height,
                                          copyCallback: copyLong,
                                          pasteCallback: paste)
                        }
                        Spacer(minLength: 0.0)
                        if !brain.highPrecision || !brain.hasMoreDigits(t.digitsInSmallDisplay) {
                            let text = brain.sString(t.digitsInSmallDisplay)
                            let fg: Color = TE.DigitKeyProperties.textColor
                            let font: Font = Font.system(size: t.displayFontSize, weight: .thin).monospacedDigit()
                            let maxHeight: CGFloat = t.remainingAboveKeys
                            let trailing: CGFloat = (t.isLandscape && !t.isPad ? t.widerKeySize.width : t.widerKeySize.width*0.2) - TE.reducedTrailing
                            let leading: CGFloat = t.keySize.width * 0.5 - t.displayFontSize * 0.28
                            let bottom: CGFloat = (brain.highPrecision ? t.allkeysHeight : 0.0)
                            HStack(spacing: 0) {
                                Spacer(minLength: 0.0)
                                Text(text)
                                    .foregroundColor(fg)
                                    .font(font)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                                    .frame(maxHeight: maxHeight, alignment: .bottom)
                                    .padding(.trailing, trailing)
                                    .padding(.leading, leading)
                                    .padding(.bottom, bottom)
                            }
                            .animation(nil, value: brain.hasMoreDigits(t.digitsInSmallDisplay))
                        } else {
                            AllDigitsView(brain: brain)
                                .padding(.trailing, (t.isLandscape && !t.isPad) ? t.widerKeySize.width : 0.0 )
                        }
                    }
                }
                if !brain.highPrecision {
                    Keys(brain: brain, t: t)
                }
            }
        }
    }
}

