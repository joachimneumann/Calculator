//
//  PlusKey.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import SwiftUI

struct PlusKey: View {
    var keyInfo: Model.KeyInfo
    @Binding var zoomed: Bool
    let size: CGSize

    @State var tapped: Bool = false
    @State var enabled: Bool = true

    var body: some View {
        Image(systemName: "plus.circle.fill")
            .resizable()
            .font(Font.title.weight(.thin))
            .rotationEffect(zoomed ? .degrees(-45.0) : .degrees(0.0))
            .frame(width: size.width, height: size.height)
            .background(Color(keyInfo.colors.textColor))
            .foregroundColor(Color(keyInfo.colors.upColor))
            .clipShape(Capsule())
            .onTouchGesture(tapped: $tapped, symbol: keyInfo.symbol, callback: {
                withAnimation() {
                    zoomed.toggle()
                }
            })
    }
}

//struct Plus_Previews: PreviewProvider {
//    static var previews: some View {
//        let model = KeyModel()
//        PlusKey(model: model, textColor: Color(model.colorsOf["plusKey"]!.textColor), upColor: Color(model.colorsOf["plusKey"]!.upColor), downColor: Color(model.colorsOf["plusKey"]!.downColor), size: CGSize(width: 100, height: 100))
//    }
//}
