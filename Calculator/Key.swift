//
//  Key.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import SwiftUI

struct Key: View {
    @ObservedObject var keyInfo: Model.KeyInfo
    let modelCallback: (String) -> ()
    let size: CGSize
    let doubleWidth: CGFloat

    init(keyInfo: Model.KeyInfo,
         modelCallback: @escaping (String) -> (),
         size: CGSize,
         doubleWidth: CGFloat = 0.0) {
        self.keyInfo = keyInfo
        self.modelCallback = modelCallback
        self.size = size
        self.doubleWidth = doubleWidth
    }
    
    @State var tapped: Bool = false

    var body: some View {
        //let _ = print("Key: keyinfo ", keyInfo.symbol, keyInfo.enabled)
        // use this to print to make sure that keys are not redrawn too often
        // let _ = print("Key \(keyInfo.symbol)")
        ZStack {
            if keyInfo.symbol == "0" {
                Label(keyInfo: keyInfo, size: size.height)
                    .offset(x: doubleWidth * -0.5 + size.width * 0.5)
                    .frame(width: doubleWidth, height: size.height)
            } else {
                Label(keyInfo: keyInfo, size: size.height)
                    .frame(width: size.width, height: size.height)
            }
       }
        .background(Color(tapped ? (keyInfo.enabled ? keyInfo.colors.downColor : C.disabledColor) : keyInfo.colors.upColor))
        .clipShape(Capsule())
        .onTouchGesture(tapped: $tapped, symbol: keyInfo.symbol, callback: callback)
    }

    func callback() {
        if keyInfo.enabled { modelCallback(keyInfo.symbol) }
    }
}

extension View {
    func onTouchGesture(tapped: Binding<Bool>, symbol: String, callback: @escaping () -> ()) -> some View {
        modifier(OnTouchGestureModifier(tapped: tapped, symbol: symbol, callback: callback))
    }
}

private struct OnTouchGestureModifier: ViewModifier {
    @Binding var tapped: Bool
    let symbol: String
    let callback: () -> ()

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
                        callback()

                        upHasHappended = false
                        //print("self.tapped \(self.tapped)")

                        self.downAnimationFinished = false
                        //print("onChanged downAnimationFinished \(downAnimationFinished)")
                        withAnimation(.easeIn(duration: downTime)) {
                            self.tapped = true
                        }
                        keyDone()
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
    @MainActor func keyDone() {
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

//struct Key_Previews: PreviewProvider {
//    static var previews: some View {
//        Key(symbol: "5", model: KeyModel(), textColor: Color.white, upColor: Color.green, downColor: Color.yellow, size: CGSize(width: 100, height: 100))
//    }
//}
