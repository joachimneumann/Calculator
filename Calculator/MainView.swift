//
//  MainView.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct MainView: View {
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
                    Zoom(scrollTarget: $brain.scrollViewTarget,
                         iconName: brain.zoomed ? brain.precisionIconName : "plus.circle.fill",
                         iconSize: t.keySize.height * 0.7,
                         textColor: TE.DigitKeyProperties.textColor,
                         zoomed: $brain.zoomed,
                         showCalculating: brain.showCalculating)
                        .frame(width: t.widerKeySize.width, height: t.keySize.height, alignment: .center)
                        .padding(.bottom, t.allkeysHeight + t.spaceBetweenkeys)
                }
            }
            if true {
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
            Display(brain: brain, t: t)
                .padding(.trailing, t.keySize.width * 1.0)
                .animation(nil, value: UUID())
        )
    }
}

