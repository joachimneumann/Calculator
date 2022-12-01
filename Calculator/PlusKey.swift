//
//  PlusKey.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import SwiftUI

struct PlusKey: View {
    @Binding var isZoomed: Bool
    let keyModel: KeyModel
    let textColor: Color
    let upColor: Color
    let downColor: Color
    let size: CGSize
    let disabledColor = Color.red

    @State var tapped: Bool = false
    @State var enabled: Bool = true

    init(isZoomed: Binding<Bool>, keyModel: KeyModel, size: CGSize) {
        self._isZoomed = isZoomed
        self.keyModel = keyModel
        self.textColor = Color(uiColor: keyModel.colorsOf["plusKey"]!.textColor)
        self.upColor   = Color(uiColor: keyModel.colorsOf["plusKey"]!.upColor)
        self.downColor = Color(uiColor: keyModel.colorsOf["plusKey"]!.downColor)
        self.size = size
    }

    var body: some View {
        Image(systemName: "plus.circle.fill")
            .resizable()
            .font(Font.title.weight(.thin))
            .rotationEffect(isZoomed ? .degrees(-45.0) : .degrees(0.0))
            .frame(width: size.width, height: size.height)
            .foregroundColor(tapped ? (enabled ? downColor : disabledColor) : upColor)
            .background(textColor)//tapped ? (enabled ? downColor : disabledColor) : upColor)
            .clipShape(Capsule())
            .onTouchGesture(tapped: $tapped, enabled: $enabled, isZoomed: $isZoomed, symbol: "plusKey", keyModel: keyModel)
    }
}

fileprivate extension View {
    func onTouchGesture(tapped: Binding<Bool>, enabled: Binding<Bool>, isZoomed: Binding<Bool>, symbol: String, keyModel: KeyModel) -> some View {
        modifier(OnTouchGestureModifier(tapped: tapped, enabled: enabled, isZoomed: isZoomed, symbol: symbol, keyModel: keyModel))
    }
}

private struct OnTouchGestureModifier: ViewModifier {
    @Binding var tapped: Bool
    @Binding var enabled: Bool
    @Binding var isZoomed: Bool
    let symbol: String
    let keyModel: KeyModel
    @State var downAnimationFinished = false
    @State var upHasHappended = false
    let downTime = 0.1
    let upTime = 0.3
    
    ///  The animation will always wait for the downanimation to finish
    ///  This is a more clear visual feedback to the user that the button has been pressed
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !self.tapped {
                        enabled = keyModel.enabledDict[symbol]! /// this activated the red button background for disabled button
                        if enabled {
                            withAnimation() {
                                isZoomed.toggle()
                            }
                        } /// disabled buttons do not work (but their background color is animated)
                        
                        upHasHappended = false
                        //print("self.tapped \(self.tapped)")

                        self.downAnimationFinished = false
                        //print("onChanged downAnimationFinished \(downAnimationFinished)")
                        withAnimation(.easeIn(duration: downTime)) {
                            self.tapped = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + downTime) {
                            self.downAnimationFinished = true
                            if upHasHappended {
                                withAnimation(.easeIn(duration: upTime)) {
                                    self.tapped = false
                                }
                            }
                        }
                    }
                }
                .onEnded { _ in
                    //print("ended downAnimationFinished \(downAnimationFinished)")
                    if self.downAnimationFinished {
                        withAnimation(.easeIn(duration: upTime)) {
                            self.tapped = false
                        }
                    } else {
                        upHasHappended = true
                    }
                })
    }
}

struct Plus_Previews: PreviewProvider {
    static var previews: some View {
        PlusKey(isZoomed: .constant(false), keyModel: KeyModel(), size: CGSize(width: 100, height: 100))
    }
}
