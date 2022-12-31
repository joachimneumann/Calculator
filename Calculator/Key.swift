//
//  Key.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import SwiftUI

struct Key: View {
    let symbol: String
    let size: CGSize
    let backgroundColor: Color
    let touchDown: (String) -> ()
    let touchUp: (String) -> ()
    let doubleWidth: CGFloat
    
    init(_ symbol: String,
         _ keyModel: KeyModel,
         doubleWidth: CGFloat = 0.0) {
        self.symbol = symbol
        self.size = keyModel.screen.keySize
        self.backgroundColor = keyModel.backgroundColor[symbol]!
        self.touchDown = keyModel.touchDown
        self.touchUp = keyModel.touchUp
        self.doubleWidth = doubleWidth
    }
    
    var body: some View {
        ZStack {
            if symbol == "0" {
                Label(symbol: symbol, size: size.height)
                    .offset(x: doubleWidth * -0.5 + size.width * 0.5)
                    .frame(width: doubleWidth, height: size.height)
            } else {
                Label(symbol: symbol, size: size.height)
                    .frame(width: size.width, height: size.height)
            }
        }
        .background(backgroundColor)
        .clipShape(Capsule())
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in
                touchDown(symbol)
            }
            .onEnded { _ in
                touchUp(symbol)
            })
    }
}

struct Key_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Key("√", KeyModel(screen: Screen(CGSize(width: 1400, height: 600))))
                    .foregroundColor(.white)
                Key("5", KeyModel(screen: Screen(CGSize(width: 1400, height: 600))))
                    .foregroundColor(.white)
            }
            Key("0", KeyModel(screen: Screen(CGSize(width: 1400, height: 600))), doubleWidth: 200)
                .foregroundColor(.white)
        }
    }
}
