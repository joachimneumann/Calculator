//
//  IOSContentView.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

#if targetEnvironment(macCatalyst)
// nothing to compile here...
#else
struct IOSContentView: View {
    @ObservedObject var brain: Brain
    let c: Configuration
    @State var zoomed: Bool = false
    @State var copyPasteHighlight = false
    
    struct ZoomAndCo: View {
        @Binding var zoomed: Bool
        @Binding var copyPasteHighlight: Bool
        let active: Bool
        let showCalculating: Bool
        let c: Configuration
        let brain: Brain
        var body: some View {
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                ZStack {
                    VStack(spacing: 0) {
                        Spacer(minLength: 0)
                        Zoom(active: active,
                             iconSize: c.numberKeySize.height*0.75,
                             textColor: Color.white,
                             zoomed: $zoomed,
                             showCalculating: showCalculating)
                            .frame(width: c.numberKeySize.width)
                            .padding(.trailing, 0)//trailingPadding)
                    }
                    .padding(.bottom, c.allKeysHeight + c.numberKeySize.height * 0.125)
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
                            .padding(.bottom, c.allKeysHeight + c.numberKeySize.height * 0.125 - 80.0)
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
                            .padding(.bottom, c.allKeysHeight + c.numberKeySize.height * 0.125 - 120.0)
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
                c: c,
                brain: brain)
            
            if zoomed {//} && brain.hasMoreDigits {
                AllDigitsView(
                    brain: brain,
                    textColor: copyPasteHighlight ? Color.orange : Configuration.DigitKeyProperties.textColor)
                    .padding(.trailing, c.numberKeySize.width + 0.5 * c.spaceBetweenkeys)

                
            } else {
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    Display(
                        text: brain.display,
                        fontSize: c.displayFontSize,
                        textColor: copyPasteHighlight ? Color.orange : Configuration.DigitKeyProperties.textColor)
                    //.background(Color.red)
                        .padding(.trailing, c.numberKeySize.width + 0.5 * c.spaceBetweenkeys + 0)
                        .padding(.leading, 0)
                        .padding(.bottom, c.allKeysHeight)// + c.numberKeySize.height * 0.125)
                }
                if brain.rad && !zoomed {
                    VStack(spacing: 0) {
                        Spacer(minLength: 0)
                        HStack(spacing: 0) {
                            let radFontSize: CGFloat = c.displayFontSize*0.33
                            Text("Rad")
                                .font(Font.system(size: radFontSize).monospacedDigit())
                                .foregroundColor(Configuration.DigitKeyProperties.textColor)
                                .padding(.trailing, c.numberKeySize.width + 0.5 * c.spaceBetweenkeys + 0)
                                .padding(.leading, 0 + 0.5 * c.numberKeySize.width - radFontSize)
                                .padding(.bottom, c.allKeysHeight + c.numberKeySize.height * 0.125)
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
                            if c.isLandscape {
                                ScientificKeys(
                                    brain: brain, c: c)
                                    .frame(width: c.scientificPadWidth, height: c.allKeysHeight)
                                Spacer(minLength: c.spaceBetweenkeys)
                            }
                            NumberKeys(
                                brain: brain, c: c)
                                .frame(width: c.numberPadWidth, height: c.allKeysHeight)
                            Spacer(minLength: 0)
                        }
                        .background(Configuration.appBackgroundColor)
                        .transition(.move(edge: .bottom))
                    }
                    .transition(.move(edge: .bottom))
                }
            }
        }
    }
}

#endif
