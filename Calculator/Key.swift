//
//  Key.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import SwiftUI

struct Key: View {
    @ObservedObject var keyInfo: KeyModel.KeyInfo
    var keyModel: KeyModel
    let size: CGSize

    @State var tapped: Bool = false
    @State var enabled: Bool = true

    var body: some View {
        let _ = print("Key body \(keyInfo.symbol) with color \(tapped ? keyInfo.colors.downColor : keyInfo.colors.upColor)")
        ZStack {
            Label(keyInfo: keyInfo, height: size.height)
                .font(.largeTitle)
                .frame(width: size.width, height: size.height)
                .foregroundColor(Color(uiColor: keyInfo.colors.textColor))
                .background(Color(uiColor: tapped ? (enabled ? keyInfo.colors.downColor : C.disabledColor) : keyInfo.colors.upColor))
                .clipShape(Capsule())
                .onTouchGesture(tapped: $tapped, keyInfo: keyInfo, keyModel: keyModel)
        }
    }
}

extension View {
    func onTouchGesture(tapped: Binding<Bool>, keyInfo: KeyModel.KeyInfo, keyModel: KeyModel) -> some View {
        modifier(OnTouchGestureModifier(tapped: tapped, keyInfo: keyInfo, keyModel: keyModel))
    }
}

private struct OnTouchGestureModifier: ViewModifier {
    @Binding var tapped: Bool
    let keyInfo: KeyModel.KeyInfo
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
//                        keyInfo._enabled = keyModel.enabledDict[symbol]! /// this activated the red button background for disabled button
                        if keyInfo._enabled {
                            if keyInfo.symbol == "plusKey" {
                                withAnimation(.easeIn(duration: upTime)) {
                                    keyModel.keyDownCallback(keyInfo.symbol)
                                }
                            } else {
                                keyModel.keyDownCallback(keyInfo.symbol)
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

//struct Key_Previews: PreviewProvider {
//    static var previews: some View {
//        Key(symbol: "5", keyModel: KeyModel(), textColor: Color.white, upColor: Color.green, downColor: Color.yellow, size: CGSize(width: 100, height: 100))
//    }
//}
