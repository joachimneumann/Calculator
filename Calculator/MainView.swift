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
            VStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                HStack(spacing: 0.0) {
                    if t.isPad || !t.isPortrait {
                        ScientificKeys(brain: brain, t: t)
                            .padding(.trailing, t.spaceBetweenKeys)
                    }
                    NumberKeys(brain: brain, t: t)
                }
            }
            .frame(height: t.allkeysHeight)
            .transition(.move(edge: .bottom))
        }
    }
    
    struct Rad: View {
        let keySize: CGSize
        let textColor: Color
        var body: some View {
            VStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                Text("Rad")
                    .font(Font.system(size: keySize.height*0.27).monospacedDigit())
                    .foregroundColor(Color.yellow)
                    .padding(.leading, keySize.height*0.27)
                    .padding(.bottom, keySize.height*0.1)
            }
        }
    }
    
    @State private var showDetails = false
    var body: some View {
        ZStack { // buttons: + and OO
            HStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                VStack {
                    Zoom(scrollTarget: $brain.scrollViewTarget,
                         iconName: brain.zoomed ? brain.precisionIconName : "plus.circle.fill",
                         iconSize: t.iconSize,
                         scaleFactor: t.circularProgressViewScaleFactor,
                         textColor: t.digits_1_9.textColor,
                         zoomed: $brain.zoomed,
                         showCalculating: brain.showCalculating && brain.isCalculating)
                        .frame(width: t.colorOpProperties.size.width, height: t.colorOpProperties.size.height, alignment: .center)
//                        .padding(.top, t.zoomTopPadding)
                    Precision(brain: brain, textColor: t.digits_1_9.textColor,
                              iconSize: t.iconSize)
                        .frame(width: t.colorOpProperties.size.width, height: t.colorOpProperties.size.height, alignment: .center)
                    Spacer(minLength: 0.0)
                }
            }
//        }
//        .background(
//            VStack {
//                Spacer(minLength: 0.0)
//                Text("xx")
//                    .padding(.bottom, 0.0)
//                    .background(Color.yellow)
//            }
////        )
        VStack {
            if !brain.zoomed {
                Spacer(minLength: 0.0)
                Keys(brain: brain, t: t)
                    .transition(.move(edge: .bottom))
            }
        }
        
        VStack {
            Spacer(minLength:0)
            Text("characters = \(t.nnn)")
            //SingleLineDisplay(r: brain.representations.r1, t: t)
                .background(Color.black)
                .foregroundColor(Color.white)
                .animation(nil, value: UUID())
                .frame(minHeight: t.displayheight, maxHeight: t.displayheight)
            Spacer(minLength: t.allkeysHeight)
        }


        
            VStack(spacing: 0.0) {
                HStack(spacing: 0.0) {
                    if brain.rad && !brain.zoomed {
                        Rad(keySize: t.digits_1_9.size, textColor: t.digits_1_9.textColor)
                    }
                    Spacer(minLength: 0.0)
                    VStack(spacing: 0.0) {
                        if t.isPad {
                        }
                        Spacer(minLength: 0.0)
                    }
                }
//                if !brain.zoomed || t.isPad {
//                    HStack(spacing: 0.0) {
//                        Keys(brain: brain, t: t)
//                    }
//                }
            }
        }
    }
}

