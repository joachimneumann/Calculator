//
//  ContentView.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var brain: Brain
    @State var zoomed: Bool = false
    @State var copyPasteHighlight = false

    
    struct Keys: View {
        let brain: Brain
        var body: some View {
            // the keys
            HStack(spacing: 0.0) {
                if brain.t.isLandscape {
                    ScientificKeys(brain: brain)
                        .padding(.trailing, brain.t.spaceBetweenkeys)
                }
                NumberKeys(brain: brain)
                Spacer(minLength: 0.0)
            }
            .transition(.move(edge: .bottom))
        }
    }
    
    struct LandscapeZoomAndCo : View {
        @Binding var copyPasteHighlight: Bool
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
            ZStack {
                VStack(spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    Zoom(active: active,
                         iconSize: iconSize,
                         textColor: TE.DigitKeyProperties.textColor,
                         zoomed: $zoomed,
                         showCalculating: brain.showCalculating)
                        .frame(width: zoomWidth, height: zoomHeight, alignment: .center)
                        .padding(.bottom, brain.t.allkeysHeight + brain.t.spaceBetweenkeys)
                }
                if zoomed {
                    VStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        Copy(longString: brain.lString,
                             fontSize: fontSize,
                             copyCallback: copyCallback,
                             copyPasteHighlight: $copyPasteHighlight)
                            .padding(.bottom, brain.t.allkeysHeight + brain.t.spaceBetweenkeys - 2.0 * fontSize)
                    }
                    VStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        Paste(fontSize: fontSize,
                              copyPasteHighlight: $copyPasteHighlight,
                              pasteCallback: pasteCallback)
                            .padding(.bottom, brain.t.allkeysHeight + brain.t.spaceBetweenkeys - 4.0 * fontSize)
                    }
                }
            }
        }
    }
    
    struct PortraitZoomAndCo : View {
        @Binding var copyPasteHighlight: Bool
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
                if zoomed {
                    Copy(longString: brain.lString,
                         fontSize: fontSize,
                         copyCallback: copyCallback,
                         copyPasteHighlight: $copyPasteHighlight)
                        .padding(.trailing, 20)
                    Paste(fontSize: fontSize,
                          copyPasteHighlight: $copyPasteHighlight,
                          pasteCallback: pasteCallback)
                        .padding(.trailing, 20)
                }
                Zoom(active: active,
                     iconSize: iconSize,
                     textColor: TE.DigitKeyProperties.textColor,
                     zoomed: $zoomed,
                     showCalculating: brain.showCalculating)
                    .frame(width: zoomWidth, height: zoomHeight, alignment: .center)
            }
        }
    }
    
    struct SmallDisplay: View {
        let text: String
        let fg: Color
        let font: Font
        let maxHeight: CGFloat
        let trailing: CGFloat
        let leading: CGFloat
        let bottom: CGFloat
        var body: some View {
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
        UIPasteboard.general.string = brain.sString
    }

    func copyLong() {
        UIPasteboard.general.string = brain.lString
    }

    func paste(_ s: String) {
        brain.fromPasteboard(s)
    }
    
    struct KeyboardShortcuts: View {
        var zoomed: Bool
        let copyLongCallback: () -> ()
        let copyShortCallback: () -> ()
        let pasteShortCallback: (_ s: String) -> ()

        var body: some View {
            /// ⌘C copy the display, except when zoomed, then get all digits
            if zoomed {
                Button("") {
                    copyLongCallback()
                }
                .keyboardShortcut("c")
            } else {
                Button("") {
                    copyShortCallback()
                }
                .keyboardShortcut("c")
            }
            
            /// ⬆⌘C get all digits
            Button("") {
                copyLongCallback()
            }
            .keyboardShortcut("c", modifiers: [.command, .shift])
            
            /// ⌘V paste
            Button("") {
                if let content = UIPasteboard.general.string {
                    pasteShortCallback(content)
                }
            }
            .keyboardShortcut("v")
        }
    }
    var body: some View {
        ZStack {
            KeyboardShortcuts(
                zoomed: zoomed,
                copyLongCallback: copyLong,
                copyShortCallback: copyShort,
                pasteShortCallback: paste)
            if brain.t.isLandscape && !brain.t.isPad {
                HStack(spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    LandscapeZoomAndCo(copyPasteHighlight: $copyPasteHighlight,
                                       zoomed: $zoomed,
                                       brain: brain,
                                       active: brain.hasMoreDigits,
                                       iconSize: brain.t.keySize.height * 0.7,
                                       fontSize: brain.t.keySize.height*0.27,
                                       zoomWidth: brain.t.widerKeySize.width,
                                       zoomHeight: brain.t.keySize.height,
                                       copyCallback: copyLong,
                                       pasteCallback: paste)
                }
            }
            
            VStack(spacing: 0.0) {
                // everything is in here
                HStack(spacing: 0.0) {
                    // everyting above the keys
                    if brain.rad && !zoomed && brain.t.isLandscape {
                        Rad(keySize: brain.t.keySize)
                    }
                    Spacer(minLength: 0.0)
                    VStack(spacing: 0.0) {
                        if !brain.t.isLandscape || brain.t.isPad {
                            PortraitZoomAndCo(copyPasteHighlight: $copyPasteHighlight,
                                              zoomed: $zoomed,
                                              brain: brain,
                                              active: brain.hasMoreDigits,
                                              iconSize: brain.t.keySize.height * 0.7,
                                              fontSize: brain.t.keySize.height*0.27,
                                              zoomWidth: brain.t.widerKeySize.width,
                                              zoomHeight: brain.t.keySize.height,
                                              copyCallback: copyLong,
                                              pasteCallback: paste)
                        }
                        Spacer(minLength: 0.0)
                        if !zoomed || !brain.hasMoreDigits {
                            SmallDisplay(text: brain.sString,
                                         fg: (copyPasteHighlight ? Color.orange : TE.DigitKeyProperties.textColor),
                                         font: Font.system(size: brain.t.displayFontSize, weight: .thin).monospacedDigit(),
                                         maxHeight: brain.t.remainingAboveKeys,
                                         trailing: (brain.t.isLandscape && !brain.t.isPad ? brain.t.widerKeySize.width : brain.t.widerKeySize.width*0.2) - TE.reducedTrailing,
                                         leading: brain.t.keySize.width * 0.5 - brain.t.displayFontSize * 0.28,
                                         bottom: (zoomed ? brain.t.allkeysHeight : 0.0))
                                .animation(nil, value: brain.hasMoreDigits)
                        } else {
                            AllDigitsView(brain: brain)
                                .padding(.trailing, (brain.t.isLandscape && !brain.t.isPad) ? brain.t.widerKeySize.width : 0.0 )
                        }
                    }
                }
                if !zoomed {
                    Keys(brain: brain)
                }
            }
        }
    }
}

