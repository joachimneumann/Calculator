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
                //.foregroundColor(Color.yellow)
                    .padding(.leading, keySize.height*0.27)
                    .padding(.bottom, keySize.height*0.1)
            }
        }
    }
    
    @State private var showDetails = false
    @State var angle: Angle = .degrees(0.0)
    var body: some View {
        VStack(spacing: 0.0) {
            Spacer(minLength: 0.0)
            if !brain.zoomed {
                HStack(spacing: 0.0) {
                    SingleLineDisplay(number: brain.last, fontSize: t.displayFontSizeCandidate, length: t.digitsInDisplay)
                        .frame(height: t.displayheight, alignment: .topTrailing)
                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                    if t.isPad || !t.isPortrait {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: t.iconSize, weight: .thin))
                            .foregroundColor(t.digits_1_9.textColor)
                            .rotationEffect(angle)
                            .onTapGesture {
                                withAnimation(Animation.linear(duration: 0.3)) {
                                    angle = .degrees(-45.0)
                                }
                                withAnimation() {
                                    brain.zoomed.toggle()
                                }
                            }
                            .padding(.top, t.iconSize*0.1)
                            .frame(height: t.displayheight, alignment: .topTrailing)
                    }
                }
                Keys(brain: brain, t: t)
            } else {
                HStack(spacing: 0.0) {
                    MultiLineDisplay(number: brain.last, fontSize: t.displayFontSizeCandidate, length: t.digitsInDisplay)
                    VStack(spacing: 0.0) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: t.iconSize, weight: .thin))
                            .foregroundColor(t.digits_1_9.textColor)
                            .rotationEffect(angle)
                            .onTapGesture {
                                withAnimation(Animation.linear(duration: 0.3)) {
                                    angle = .degrees(0.0)
                                }
                                withAnimation() {
                                    brain.zoomed.toggle()
                                }
                            }
                            .padding(.top, t.iconSize*0.1)
                        Image(systemName: "switch.2")
                            .font(.system(size: t.iconSize*0.75, weight: .thin))
                            .padding(.top, t.iconSize*0.25)
                            .foregroundColor(t.digits_1_9.textColor)
                            .onTapGesture {
                                withAnimation() {
                                }
                            }
                        Spacer(minLength: 0.0)
                    }
                }
                .frame(height: t.displayheight + t.allkeysHeight)
            }
        }
    }
}

