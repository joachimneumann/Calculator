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
    let textColor: Color
    let touchDown: (String) -> ()
    let touchUp: (String, Screen) -> ()
    let doubleWidth: CGFloat
    
    init(_ symbol: String,
         _ screen: Screen,
         _ keyModel: KeyModel,
         doubleWidth: CGFloat = 0.0) {
        self.screen = screen
        self.symbol = symbol
        self.keySize = screen.keySize
        self.backgroundColor = keyModel.backgroundColor[symbol]!
        self.textColor = keyModel.textColor[symbol]!
        self.touchDown = keyModel.touchDown
        self.touchUp = keyModel.touchUp
//        self.touchUp = keyModel.touchUp
        self.doubleWidth = doubleWidth
    }
    
    var body: some View {
        let _ = print("Key body", symbol)
        let _ = Self._printChanges()
        ZStack {
            if symbol == "0" {
                Label(symbol: symbol, size: keySize.height, color: textColor)
                    .offset(x: doubleWidth * -0.5 + keySize.width * 0.5)
                    .foregroundColor(textColor)
                    .frame(width: doubleWidth, height: keySize.height)
            } else {
                Label(symbol: symbol, size: keySize.height, color: textColor)
                    .frame(width: keySize.width, height: keySize.height)
                    .foregroundColor(textColor)
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

struct Key_Previews: PreviewProvider {
    static var previews: some View {
        let screen = Screen(CGSize(width: 1400, height: 600))
        let keyModel = KeyModel()
        VStack {
            HStack {
                Key("√", screen, keyModel)
                Key("5", screen, keyModel)
            }
            Key("0", screen, keyModel, doubleWidth: 200)
        }
        .foregroundColor(.white)
    }
}
