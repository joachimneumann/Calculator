//
//  Key.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import SwiftUI

struct Key: View {
    let symbol: String
    let keyColors: ColorsOf
    let size: CGSize
//    private let keyContent: any View

    @State var tapped: Bool = false
    
    init(_ symbol: String, keyColors: ColorsOf, size: CGSize) {
        self.symbol = symbol
        self.keyColors = keyColors
        self.size = size
//        let keyLabel = KeyLabel(size: size, textColor: Color(uiColor: keyColors.textColor))
//        keyContent = keyLabel.of(symbol)
    }

    var body: some View {
//        let _ = print("Key \(symbol) with color \(Color(uiColor: tapped ? keyColors.downColor : keyColors.upColor))")
        ZStack {
            AnyView(KeyLabel(size: size, textColor: Color(uiColor: keyColors.textColor)).of(symbol))
                .font(.largeTitle)
                .frame(width: size.width, height: size.height)
                .foregroundColor(Color(uiColor: keyColors.textColor))
                .background(Color(uiColor: tapped ? keyColors.downColor : keyColors.upColor))
                .clipShape(Capsule())
                .onTouchGesture(tapped: $tapped, symbol: symbol)
        }
    }
}

fileprivate extension View {
    func onTouchGesture(tapped: Binding<Bool>, symbol: String) -> some View {
        modifier(OnTouchGestureModifier(tapped: tapped, symbol: symbol))
    }
}

private struct OnTouchGestureModifier: ViewModifier {
    @Binding var tapped: Bool
    let symbol: String
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
                    let notificationDictionary: [String: String] = [C.notificationDictionaryKey: symbol]
                    NotificationCenter.default.post(name: Notification.Name(C.notificationNameDown), object: nil, userInfo: notificationDictionary)
                    //                    self.tapped.toggle()
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
                    let notificationDictionary: [String: String] = [C.notificationDictionaryKey: symbol]
                    NotificationCenter.default.post(name: Notification.Name(C.notificationNameUp), object: nil, userInfo: notificationDictionary)
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
        Key("5", keyColors: C.digitColors, size: CGSize(width: 100, height: 100))
    }
}
