//
//  MainView.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct MainView: View {
    @State var scrollTarget: Int? = nil
    @ObservedObject var brain: Brain
    var t: TE
    
    struct Keys: View {
        let brain: Brain
        var t: TE
        var body: some View {
            // the keys
            HStack(spacing: 0.0) {
                ScientificKeys(brain: brain, t: t)
                    .padding(.trailing, t.spaceBetweenkeys)
                NumberKeys(brain: brain, t: t)
                Spacer(minLength: 0.0)
            }
            .transition(.move(edge: .bottom))
        }
    }
    
    struct LandscapeZoomAndCo : View {
        @Binding var scrollTarget: Int?
        @Binding var zoomed: Bool
        let brain: Brain
        var t: TE
        let active: Bool
        let iconSize: CGFloat
        let fontSize: CGFloat
        let zoomWidth: CGFloat
        let zoomHeight: CGFloat
        var body: some View {
            Zoom(scrollTarget: $scrollTarget,
                 iconSize: iconSize,
                 textColor: TE.DigitKeyProperties.textColor,
                 zoomed: $zoomed,
                 showCalculating: brain.calculating)
                .frame(width: zoomWidth, height: zoomHeight, alignment: .center)
                .padding(.bottom, t.allkeysHeight + t.spaceBetweenkeys)
        }
    }
    
    struct PortraitZoomAndCo : View {
        @Binding var scrollTarget: Int?
        @Binding var zoomed: Bool
        let brain: Brain
        let active: Bool
        let iconSize: CGFloat
        let fontSize: CGFloat
        let zoomWidth: CGFloat
        let zoomHeight: CGFloat
        var body: some View {
            HStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                Zoom(scrollTarget: $scrollTarget,
                     iconSize: iconSize,
                     textColor: TE.DigitKeyProperties.textColor,
                     zoomed: $zoomed,
                     showCalculating: brain.calculating)
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
    
    var body: some View {
        ZStack {
            if !t.isPad {
                HStack(spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    Zoom(scrollTarget: $scrollTarget,
                         iconSize: t.keySize.height * 0.7,
                         textColor: TE.DigitKeyProperties.textColor,
                         zoomed: $brain.zoomed,
                         showCalculating: brain.calculating)
                        .frame(width: t.widerKeySize.width, height: t.keySize.height, alignment: .center)
                        .padding(.bottom, t.allkeysHeight + t.spaceBetweenkeys)
                }
            }
            if true { // showPrecisionButton {
                HStack(spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    Precision(brain: brain,
                              iconSize: t.keySize.height * 0.7)
                        .frame(width: t.widerKeySize.width, height: t.keySize.height, alignment: .center)
                        .padding(.bottom, t.allkeysHeight + t.spaceBetweenkeys - t.keySize.height * 2.5)
                }
            }
            
            VStack(spacing: 0.0) {
                // everything is in here
                HStack(spacing: 0.0) {
                    // everyting above the keys
                    if brain.rad && !brain.zoomed {
                        Rad(keySize: t.keySize)
                    }
                    Spacer(minLength: 0.0)
                    VStack(spacing: 0.0) {
                        if t.isPad {
                            PortraitZoomAndCo(scrollTarget: $scrollTarget,
                                              zoomed: $brain.zoomed,
                                              brain: brain,
                                              active: true,// brain.hasMoreDigits(t.digitsInSmallDisplay),
                                              iconSize: t.keySize.height * 0.7,
                                              fontSize: t.keySize.height*0.27,
                                              zoomWidth: t.widerKeySize.width,
                                              zoomHeight: t.keySize.height)
                        }
                        Spacer(minLength: 0.0)
                    }
                }
                if !brain.zoomed {
                    Keys(brain: brain, t: t)
                        .background(TE.appBackgroundColor)
                }
            }
        }
        .background(
            Display(scrollTarget: $scrollTarget, brain: brain, t: t)
                .padding(.trailing, t.keySize.width * 1.0)
        )
    }
}

