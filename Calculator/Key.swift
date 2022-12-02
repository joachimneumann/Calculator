//
//  Key.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import SwiftUI

struct Key: View {
    let symbol: String
    let keyModel: KeyModel
    let textColor: Color
    let upColor: Color
    let downColor: Color
    let size: CGSize
    let disabledColor = Color.red

    @State var tapped: Bool = false
    @State var enabled: Bool = true

    var body: some View {
        let _ = print("Key body \(symbol) with color \(tapped ? downColor : upColor)")
        ZStack {
            AnyView(of(symbol: symbol, height: size.height, textColor: textColor))
                .font(.largeTitle)
                .frame(width: size.width, height: size.height)
                .foregroundColor(textColor)
                .background(tapped ? (enabled ? downColor : disabledColor) : upColor)
                .clipShape(Capsule())
                .onTouchGesture(tapped: $tapped, enabled: $enabled, symbol: symbol, keyModel: keyModel)
        }
    }
}

extension View {
    func onTouchGesture(tapped: Binding<Bool>, enabled: Binding<Bool>, symbol: String, keyModel: KeyModel) -> some View {
        modifier(OnTouchGestureModifier(tapped: tapped, enabled: enabled, symbol: symbol, keyModel: keyModel))
    }
}

private struct OnTouchGestureModifier: ViewModifier {
    @Binding var tapped: Bool
    @Binding var enabled: Bool
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
                            if symbol == "plusKey" {
                                withAnimation(.easeIn(duration: upTime)) {
                                    keyModel.keyUpCallback(symbol)
                                }
                            } else {
                                keyModel.keyUpCallback(symbol)
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

struct Key_Previews: PreviewProvider {
    static var previews: some View {
        Key(symbol: "5", keyModel: KeyModel(), textColor: Color.white, upColor: Color.green, downColor: Color.yellow, size: CGSize(width: 100, height: 100))
    }
}
