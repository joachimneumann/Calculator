//
//  PlusKey.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import SwiftUI

struct PlusKey: View {
    var keyInfo: Model.KeyInfo
    let model: Model
    let size: CGSize

    @State var tapped: Bool = false
    @State var enabled: Bool = true

    var body: some View {
        Image(systemName: "plus.circle.fill")
            .resizable()
            .font(Font.title.weight(.thin))
            .rotationEffect(model.zoomed ? .degrees(-45.0) : .degrees(0.0))
            .animation(.linear(duration: 0.2).delay(0), value: model.zoomed)
            .frame(width: size.width, height: size.height)
            .foregroundColor(Color(uiColor: tapped ? (enabled ? keyInfo.colors.downColor : C.disabledColor) : keyInfo.colors.upColor))
            .background(Color(uiColor: keyInfo.colors.textColor))
            .clipShape(Capsule())
            .onTouchGesture(tapped: $tapped, keyInfo: keyInfo, model: model)
    }
}

//struct Plus_Previews: PreviewProvider {
//    static var previews: some View {
//        let model = KeyModel()
//        PlusKey(model: model, textColor: Color(uiColor: model.colorsOf["plusKey"]!.textColor), upColor: Color(uiColor: model.colorsOf["plusKey"]!.upColor), downColor: Color(uiColor: model.colorsOf["plusKey"]!.downColor), size: CGSize(width: 100, height: 100))
//    }
//}
