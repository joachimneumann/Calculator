//
//  Key.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import SwiftUI

struct Key: View {
    let screen: Screen
    let symbol: String
    let keySize: CGSize
    let backgroundColor: Color
    let touchDown: (String) -> ()
    let touchUp: (String, Screen) -> ()
    let doubleWidth: CGFloat
    
    init(_ screen: Screen,
         _ symbol: String,
         _ keyModel: KeyModel,
         _ keySize: CGSize,
         doubleWidth: CGFloat = 0.0) {
        self.screen = screen
        self.symbol = symbol
        self.keySize = keySize
        self.backgroundColor = keyModel.backgroundColor[symbol]!
        self.touchDown = keyModel.touchDown
        self.touchUp = keyModel.touchUp
//        self.touchUp = keyModel.touchUp
        self.doubleWidth = doubleWidth
    }
    
    var body: some View {
        ZStack {
            if symbol == "0" {
                Label(symbol: symbol, size: keySize.height)
                    .offset(x: doubleWidth * -0.5 + keySize.width * 0.5)
                    .frame(width: doubleWidth, height: keySize.height)
            } else {
                Label(symbol: symbol, size: keySize.height)
                    .frame(width: keySize.width, height: keySize.height)
            }
        }
        .background(backgroundColor)
        .clipShape(Capsule())
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in
                touchDown(symbol)
            }
            .onEnded { _ in
                touchUp(symbol, screen)
            })
    }
}

//struct Key_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            HStack {
//                Key("√", KeyModel(screen: Screen(CGSize(width: 1400, height: 600))))
//                    .foregroundColor(.white)
//                Key("5", KeyModel(screen: Screen(CGSize(width: 1400, height: 600))))
//                    .foregroundColor(.white)
//            }
//            Key("0", KeyModel(screen: Screen(CGSize(width: 1400, height: 600))), doubleWidth: 200)
//                .foregroundColor(.white)
//        }
//    }
//}
