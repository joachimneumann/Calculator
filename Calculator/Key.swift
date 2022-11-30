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

    @State var tapped: Bool = false
    
    init(_ symbol: String, keyModel: KeyModel, size: CGSize) {
        self.symbol = symbol
        self.keyModel = keyModel
        self.textColor = Color(uiColor: keyModel.colorsOf[symbol]!.textColor)
        self.upColor   = Color(uiColor: keyModel.colorsOf[symbol]!.upColor)
        self.downColor = Color(uiColor: keyModel.colorsOf[symbol]!.downColor)
        self.size = size
    }

    var body: some View {
//        let _ = print("Key \(symbol) with color \(tapped ? downColor : upColor)")
        ZStack {
            AnyView(KeyLabel(height: size.height, textColor: textColor).of(symbol))
                .font(.largeTitle)
                .frame(width: size.width, height: size.height)
                .foregroundColor(textColor)
                .background(tapped ? downColor : upColor)
                .clipShape(Capsule())
                .onTouchGesture(tapped: $tapped, symbol: symbol, keyModel: keyModel)
        }
    }
}

fileprivate extension View {
    func onTouchGesture(tapped: Binding<Bool>, symbol: String, keyModel: KeyModel) -> some View {
        modifier(OnTouchGestureModifier(tapped: tapped, symbol: symbol, keyModel: keyModel))
    }
}

private struct OnTouchGestureModifier: ViewModifier {
    @Binding var tapped: Bool
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
                    
                    keyModel.keyUpCallback(symbol)
                    
                    self.downAnimationFinished = false
                    upHasHappended = false
                    if !self.tapped {
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
        Key("5", keyModel: KeyModel(), size: CGSize(width: 100, height: 100))
    }
}
