//
//  MainView.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var brain: Brain
    @State var isZoomed = false
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
                //.foregroundColor(Color.yellow)
                    .padding(.leading, keySize.height*0.27)
                    .padding(.bottom, keySize.height*0.1)
            }
        }
    }
    
    @State private var showDetails = false
    var body: some View {
        VStack(spacing: 0.0) {
            Spacer(minLength: 0.0)
            HStack(spacing: 0.0) {
                if !isZoomed || !t.isZoomAllowed {
                    SingleLineDisplay(number: brain.last, fontSize: t.displayFontSize,
                                      withoutComma: t.digitsInDisplayWithoutComma,
                                      withComma: t.digitsInDisplayWithComma)
                        .frame(height: t.displayheight, alignment: .topTrailing)
                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                        .background(Color.yellow).opacity(0.4)
                } else {
                    MultiLineDisplay(number: brain.last, fontSize: t.displayFontSize, length: brain.precision)
                        .frame(height: t.displayheight + t.allkeysHeight)
                        .background(Color.yellow).opacity(0.4)
                }
                if t.isPad || !t.isPortrait {
                    VStack(spacing: 0.0) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: t.iconSize, height: t.iconSize)
                            .font(.system(size: t.iconSize, weight: .thin))
                            .foregroundColor(t.digits_1_9.textColor)
                            .rotationEffect(isZoomed && t.isZoomAllowed  ? .degrees(-45.0) : .degrees(0.0))
                            .onTapGesture {
                                withAnimation() {
                                    isZoomed.toggle()
                                }
                            }
                            .padding(.top, t.iconSize*0.1)
                        if isZoomed && t.isZoomAllowed  {
                            Image(systemName: "switch.2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: t.iconSize, height: t.iconSize)
                                .font(.system(size: t.iconSize*0.75, weight: .thin))
                                .padding(.top, t.iconSize*0.25)
                                .foregroundColor(t.digits_1_9.textColor)
                                .onTapGesture {
                                    withAnimation() {
                                    }
                                }
                        }
                        Spacer(minLength: 0.0)
                    }
                    .frame(height: t.displayheight + (isZoomed && t.isZoomAllowed ? t.allkeysHeight : 0.0), alignment: .topTrailing)
                }
            }
            if !isZoomed || !t.isZoomAllowed {
                Keys(brain: brain, t: t)
            }
        }
    }
}

