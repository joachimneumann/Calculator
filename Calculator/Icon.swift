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
        size = t.iconSize
        color = t.digits_1_9.textColor
        self._isZoomed = isZoomed
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
            .rotationEffect(isZoomed  ? .degrees(-45.0) : .degrees(0.0))
            .onTapGesture {
                withAnimation(.easeIn) {
                    isZoomed.toggle()
                }
            }
            .padding(.top, isZoomed ? topPaddingZoomed : topPaddingNotZoomed)
    }
}

struct ControlIcon: View {
    @Binding var isZoomed: Bool
    let size: CGFloat
    let color: Color
    let topPadding: CGFloat

    init(brain: Brain, t: TE, isZoomed: Binding<Bool>) {
        size = t.iconSize
        color = t.digits_1_9.textColor
        self._isZoomed = isZoomed
        self.topPadding = t.iconSize*0.6
    }
    
    var body: some View {
        Image(systemName: "switch.2")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .font(.system(size: size, weight: .thin))
            .foregroundColor(color)
            .onTapGesture {
                withAnimation(.easeIn) {
//                    isZoomed.toggle()
                }
            }
            .opacity(isZoomed ? 1.0 : 0.0)
            .padding(.top, topPadding)
    }
}

struct CopyIcon: View {
    @Binding var isZoomed: Bool
    let size: CGFloat
    let color: Color
    let topPadding: CGFloat

    init(brain: Brain, t: TE, isZoomed: Binding<Bool>) {
        size = t.iconSize
        color = t.digits_1_9.textColor
        self._isZoomed = isZoomed
        self.topPadding = t.iconSize*0.6
    }
    
    var body: some View {
        Button(action: {}) {
            Text("Copy")
                .scaledToFill()
        }
            .frame(width: size, height: size)
            .foregroundColor(color)
            .opacity(isZoomed ? 1.0 : 0.0)
            .padding(.top, topPadding)
    }
}

struct PasteIcon: View {
    @Binding var isZoomed: Bool
    let size: CGFloat
    let color: Color
    let topPadding: CGFloat

    init(brain: Brain, t: TE, isZoomed: Binding<Bool>) {
        size = t.iconSize
        color = t.digits_1_9.textColor
        self._isZoomed = isZoomed
        self.topPadding = t.iconSize*0.4
    }
    
    var body: some View {
        Button(action: {}) {
            Text("Paste")
                .scaledToFill()
        }
            .frame(width: size, height: size)
            .foregroundColor(color)
            .opacity(isZoomed ? 1.0 : 0.0)
            .padding(.top, topPadding)
    }
}
