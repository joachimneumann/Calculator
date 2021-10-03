//
//  ContentView.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var brain: Brain
    let t: TE
    @State var zoomed: Bool = false
    @State var copyPasteHighlight = false
    
    struct ZoomAndCo: View {
        @Binding var zoomed: Bool
        @Binding var copyPasteHighlight: Bool
        let active: Bool
        let showCalculating: Bool
        let t: TE
        let brain: Brain
        var body: some View {
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                ZStack {
                    VStack(spacing: 0) {
                        Spacer(minLength: 0)
                        Zoom(active: active,
                             iconSize: t.numberKeySize.height*0.75,
                             textColor: Color.white,
                             zoomed: $zoomed,
                             showCalculating: showCalculating)
                            .frame(width: t.numberKeySize.width)
                            .padding(.trailing, 0)//trailingPadding)
                    }
                    .padding(.bottom, t.allKeysHeight + t.numberKeySize.height * 0.125)
                    if zoomed {
                        VStack(spacing: 0) {
                            Spacer(minLength: 0)
                            Copy(longString: brain.combinedLongDisplayString(longDisplayString: brain.longDisplayString)) {
                                copyPasteHighlight = true
                                let now = DispatchTime.now()
                                var whenWhen: DispatchTime
                                whenWhen = now + DispatchTimeInterval.milliseconds(300)
                                DispatchQueue.main.asyncAfter(deadline: whenWhen) {
                                    copyPasteHighlight = false
                                }
                            }
                            .transition(.move(edge: .bottom))
                            .padding(.bottom, t.allKeysHeight + t.numberKeySize.height * 0.125 - 80.0)
                        }
                        VStack(spacing: 0) {
                            Spacer(minLength: 0)
                            Paste() { fromPasteboard in
                                copyPasteHighlight = true
                                let now = DispatchTime.now()
                                var whenWhen: DispatchTime
                                whenWhen = now + DispatchTimeInterval.milliseconds(300)
                                DispatchQueue.main.asyncAfter(deadline: whenWhen) {
                                    copyPasteHighlight = false
                                }
                                brain.fromPasteboard(fromPasteboard)
                            }
                            .padding(.bottom, t.allKeysHeight + t.numberKeySize.height * 0.125 - 120.0)
                        }
                    }
                }
            }
        }
    }
    
    
    
    var body: some View {
        ZStack {
            ZoomAndCo(
                zoomed: $zoomed,
                copyPasteHighlight: $copyPasteHighlight,
                active: brain.hasMoreDigits,
                showCalculating: brain.showCalculating,
                t: t,
                brain: brain)
            
            if zoomed {//} && brain.hasMoreDigits {
                AllDigitsView(
                    brain: brain,
                    textColor: copyPasteHighlight ? Color.orange : TE.DigitKeyProperties.textColor)
                    .padding(.trailing, t.numberKeySize.width + 0.5 * t.spaceBetweenkeys)

                
            } else {
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    Display(
                        text: brain.display,
                        fontSize: t.displayFontSize,
                        textColor: copyPasteHighlight ? Color.orange : TE.DigitKeyProperties.textColor)
                        .padding(.trailing, t.numberKeySize.width + 0.5 * t.spaceBetweenkeys + 0)
                        .padding(.leading, 0)
                        .padding(.bottom, t.allKeysHeight)
                }
                if brain.rad && !zoomed {
                    VStack(spacing: 0) {
                        Spacer(minLength: 0)
                        HStack(spacing: 0) {
                            let radFontSize: CGFloat = t.displayFontSize*0.33
                            Text("Rad")
                                .font(Font.system(size: radFontSize).monospacedDigit())
                                .foregroundColor(TE.DigitKeyProperties.textColor)
                                .padding(.trailing, t.numberKeySize.width + 0.5 * t.spaceBetweenkeys + 0)
                                .padding(.leading, 0 + 0.5 * t.numberKeySize.width - radFontSize)
                                .padding(.bottom, t.allKeysHeight + t.numberKeySize.height * 0.125)
                            Spacer(minLength: 0)
                        }
                    }
                    .transition(.move(edge: .bottom))
                }
                if !zoomed {
                    VStack(spacing: 0) {
                        Spacer(minLength: 0)
                        HStack(spacing: 0) {
                            Spacer(minLength: 0)
                            if t.isLandscape {
                                ScientificKeys(
                                    brain: brain, t: t)
                                    .frame(width: t.scientificPadWidth, height: t.allKeysHeight)
                                Spacer(minLength: t.spaceBetweenkeys)
                            }
                            NumberKeys(
                                brain: brain, t: t)
                                .frame(width: t.numberPadWidth, height: t.allKeysHeight)
                                .background(TE.appBackgroundColor)
                            Spacer(minLength: 0)
                        }
                        .background(TE.appBackgroundColor)
                        .transition(.move(edge: .bottom))
                    }
                    .transition(.move(edge: .bottom))
                }
            }
        }
    }
}

