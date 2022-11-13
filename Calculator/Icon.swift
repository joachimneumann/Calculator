//
//  Icon.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/10/22.
//

import SwiftUI

struct PlusIcon: View {
    @Binding var isZoomed: Bool
    let size: CGFloat
    let color: Color
    let topPaddingZoomed: CGFloat
    let topPaddingNotZoomed: CGFloat
    
    init(brain: Brain, t: TE, isZoomed: Binding<Bool>) {
        size = t.iconSize*0.8
        self._isZoomed = isZoomed
        color = t.digits_1_9.textColor
        self.topPaddingNotZoomed = t.zoomTopPaddingNotZoomed
        self.topPaddingZoomed = t.zoomTopPaddingZoomed
    }
    
    var body: some View {
        Image(systemName: "plus.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .font(.system(size: size, weight: .thin))
            .foregroundColor(color)
            .rotationEffect(isZoomed ? .degrees(-45.0) : .degrees(0.0))
            .onTapGesture {
                withAnimation() {
                    isZoomed.toggle()
                }
            }
            .padding(.top, isZoomed ? topPaddingZoomed : topPaddingNotZoomed)
    }
}

struct CopyIcon: View {
    @State var copying = false
    let brain: Brain
    let size: CGFloat
    let color: Color
    let topPadding: CGFloat
    
    init(brain: Brain, t: TE) {
        self.brain = brain
        size = t.iconSize
        color = t.digits_1_9.textColor
        self.topPadding = t.iconSize*0.6
    }
    
    var body: some View {
        Group() {
            if copying {
                Button(action: {
                    print("button pressed")
                    
                }) {
                    Image("wing")
                        .resizable()
//                        .frame(width: size*iconState.sizeFactor(), height: size*iconState.sizeFactor())
                }
            } else {
                Button("Copy") {
                    copying = true
//                    iconState = .noNumber
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        withAnimation() {
                            copying = false
                        }
                    }
                    var s = brain.last.singleLine(len: brain.precision)
                    s.replace(",", with: ".")
                    UIPasteboard.general.string = s
                }
                .foregroundColor(color)
                //        .opacity(iconState == .plusRotated ? 1.0 : 0.0)
            }
        }
        .frame(width: size, height: size)
        .padding(.top, topPadding)
    }
}

struct PasteIcon: View {
    @Environment(\.scenePhase) var scenePhase
    @State var hasValidNumberToPaste = false
    let brain: Brain
    let size: CGFloat
    let color: Color
    let topPadding: CGFloat
    
    init(brain: Brain, t: TE) {
        self.brain = brain
        size = t.iconSize
        color = t.digits_1_9.textColor
        self.topPadding = t.iconSize*0.4
    }
    
    var body: some View {
        VStack(spacing: 0.0) {
            Button("Paste") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    
                }
                DispatchQueue.main.async {
                    if let s = UIPasteboard.general.string {
                        let valid = Gmp.isValidGmpString(s)
                        if valid {
                            brain.asyncOperation("fromPasteboard")
                        } else {
                            /// TODO error handling
                        }
                    }
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    print("active")
                }
            }
            .frame(width: size, height: size)
            .foregroundColor(color)
            //            .opacity(iconState != .plusRotated ? 1.0 : 0.0)
            .padding(.top, topPadding)
        }
    }
}


struct ControlIcon: View {
    let size: CGFloat
    let color: Color
    let topPadding: CGFloat
    
    init(brain: Brain, t: TE) {
        size = t.iconSize
        color = t.digits_1_9.textColor
        self.topPadding = t.iconSize*0.6
    }
    
    var body: some View {
        Image(systemName: "switch.2")
            .resizable()
            .scaledToFit()
            .frame(width: size*0.8, height: size*0.8)
            .font(.system(size: size, weight: .thin))
            .foregroundColor(color)
            .onTapGesture {
                withAnimation(.easeIn) {
                    //                    isZoomed.toggle()
                }
            }
        //            .opacity(iconState == .plusRotated ? 1.0 : 0.0)
            .padding(.top, topPadding)
    }
}
