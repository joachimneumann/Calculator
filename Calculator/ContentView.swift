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
    
    //    struct ZoomAndCo: View {
    //        @Binding var zoomed: Bool
    //        @Binding var copyPasteHighlight: Bool
    //        let active: Bool
    //        let showCalculating: Bool
    //        let t: TE
    //        let brain: Brain
    //        var body: some View {
    //            let iconSize = t.keySize.height * 0.7
    //            HStack(spacing: 0.0) {
    //                Spacer(minLength: 0.0)
    //                ZStack {
    //                    VStack(spacing: 0.0) {
    //                        if t.isLandscape {
    //                            Spacer(minLength: 0.0)
    //                        }
    //                        Zoom(active: active,
    //                             iconSize: iconSize,
    //                             textColor: TE.DigitKeyProperties.textColor,
    //                             zoomed: $zoomed,
    //                             showCalculating: showCalculating)
    //                            .frame(width: t.widerKeySize.width, height: t.widerKeySize.height, alignment: .center)
    //                            .background(Color.yellow.opacity(0.3))
    //                        Spacer(minLength: 0.0)
    //                    }
    //                    if zoomed {
    //                        VStack(spacing: 0.0) {
    //                            if t.isLandscape {
    //                                Spacer(minLength: 0.0)
    //                            }
    //                            Copy(
    //                                longString: brain.combinedLongDisplayString(longDisplayString: brain.longDisplayString),
    //                                copyPasteHighlight: $copyPasteHighlight)
    //                                .transition(.move(edge: .bottom))
    //                            //.background(Color.yellow.opacity(0.3))
    //                            Spacer(minLength: 0.0)
    //                        }
    //                        VStack(spacing: 0.0) {
    //                            if t.isLandscape {
    //                                Spacer(minLength: 0.0)
    //                            }
    //                            Paste(copyPasteHighlight: $copyPasteHighlight, brain: brain)
    //                            Spacer(minLength: 0.0)
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    
    
    //    var body: some View {
    //        ZStack {
    //            ZoomAndCo(
    //                zoomed: $zoomed,
    //                copyPasteHighlight: $copyPasteHighlight,
    //                active: brain.hasMoreDigits,
    //                showCalculating: brain.showCalculating,
    //                t: t,
    //                brain: brain)
    //
    //            if zoomed {//} && brain.hasMoreDigits {
    //                AllDigitsView(
    //                    brain: brain,
    //                    textColor: copyPasteHighlight ? Color.orange : TE.DigitKeyProperties.textColor)
    //            } else {
    //                VStack(spacing: 0.0) {
    //                    Spacer(minLength: 0.0)
    //                    Display(
    //                        text: brain.display,
    //                        fontSize: t.displayFontSize,
    //                        textColor: copyPasteHighlight ? Color.orange : TE.DigitKeyProperties.textColor)
    //                }
    //                if brain.rad && !zoomed {
    //                    VStack(spacing: 0.0) {
    //                        Spacer(minLength: 0.0)
    //                        HStack(spacing: 0.0) {
    //                            let radFontSize: CGFloat = t.displayFontSize*0.33
    //                            Text("Rad")
    //                                .font(Font.system(size: radFontSize).monospacedDigit())
    //                                .foregroundColor(TE.DigitKeyProperties.textColor)
    //                            Spacer(minLength: 0.0)
    //                        }
    //                    }
    //                    .transition(.move(edge: .bottom))
    //                }
    //                if !zoomed {
    //                    VStack(spacing: 0.0) {
    //                        Spacer(minLength: 0.0)
    //                        HStack(spacing: 0.0) {
    //                            Spacer(minLength: 0.0)
    //                            if t.isLandscape {
    //                                ScientificKeys(
    //                                    brain: brain, t: t)
    //                                Spacer(minLength: t.spaceBetweenkeys)
    //                            }
    //                            NumberKeys(
    //                                brain: brain, t: t)
    //                                //.background(TE.appBackgroundColor)
    //                                .background(Color.yellow.opacity(0.3))
    //                            Spacer(minLength: 0.0)
    //                        }
    //                        .background(TE.appBackgroundColor)
    //                        .transition(.move(edge: .bottom))
    //                    }
    //                    .transition(.move(edge: .bottom))
    //                }
    //            }
    //        }
    //    }
    
    //    struct Rad: View {
    //        let keySize: CGSize
    //        var body: some View {
    //        }
    //    }
    
    var body: some View {
        let _dd: DisplayData = DisplayData(number: brain.last, digits: t.digitsInSmallDisplay)
        let _ = brain.inPlaceAllowed = _dd.isValidNumber
        VStack(spacing: 0.0) {
            // everything is in here
            HStack(spacing: 0.0) {
                // everyting above the keys
                if brain.rad && !zoomed && t.isLandscape {
                    VStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        Text("Rad")
                            .font(Font.system(size: t.keySize.height*0.27).monospacedDigit())
                            .foregroundColor(TE.DigitKeyProperties.textColor)
                            .padding(.leading, t.keySize.height*0.27)
                            .padding(.bottom, t.keySize.height*0.1)
                    }
                }
                Spacer(minLength: 0.0)
                VStack(spacing: 0.0) {
                    if !t.isLandscape {
                        HStack(spacing: 0.0) {
                            Spacer(minLength: 0.0)
                            Zoom(active: _dd.hasMoreDigits,
                                 iconSize: t.keySize.height * 0.7,
                                 textColor: TE.DigitKeyProperties.textColor,
                                 zoomed: $zoomed,
                                 showCalculating: brain.showCalculating)
                                .frame(width: t.widerKeySize.width, height: t.keySize.height, alignment: .center)
                        }
                    }
                    Spacer(minLength: 0.0)
                    HStack(spacing: 0) {
                        Spacer(minLength: 0.0)
                        Text(_dd.string)
                            .foregroundColor(TE.DigitKeyProperties.textColor)
                            .font(Font.system(size: t.displayFontSize, weight: .thin).monospacedDigit())
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .frame(maxHeight: t.remainingAboveKeys, alignment: .bottom)
                            .padding(.trailing, t.keySize.width * 0.5 - t.displayFontSize * 0.28 - TE.reducedTrailing)
                            .padding(.leading, t.keySize.width * 0.5 - t.displayFontSize * 0.28)
                            .padding(.bottom, zoomed ? t.allkeysHeight : 0.0)
                            .animation(nil, value: _dd.hasMoreDigits)
                    }
                }
                if t.isLandscape {
                    VStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        Zoom(active: _dd.hasMoreDigits,
                             iconSize: t.keySize.height * 0.7,
                             textColor: TE.DigitKeyProperties.textColor,
                             zoomed: $zoomed,
                             showCalculating: brain.showCalculating)
                            .frame(width: t.widerKeySize.width, height: t.keySize.height, alignment: .center)
                            .padding(.bottom, t.spaceBetweenkeys + TE.additionalBottomSpacing + (zoomed ? t.allkeysHeight : 0.0))
                    }
                }
            }
            if !zoomed {
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
    }
}

