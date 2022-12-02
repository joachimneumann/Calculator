//
//  PlusKey.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import SwiftUI

struct PlusKey: View {
    var keyInfo: KeyModel.KeyInfo
    let keyModel: KeyModel
    let size: CGSize

    @State var tapped: Bool = false
    @State var enabled: Bool = true

    var body: some View {
        Image(systemName: "plus.circle.fill")
            .resizable()
            .font(Font.title.weight(.thin))
            .rotationEffect(keyModel.zoomed ? .degrees(-45.0) : .degrees(0.0))
            .animation(.linear(duration: 0.2).delay(0), value: keyModel.zoomed)
            .frame(width: size.width, height: size.height)
            .foregroundColor(Color(uiColor: tapped ? (enabled ? keyInfo.colors.downColor : C.disabledColor) : keyInfo.colors.upColor))
            .background(Color(uiColor: keyInfo.colors.textColor))
            .clipShape(Capsule())
            .onTouchGesture(tapped: $tapped, keyInfo: keyInfo, keyModel: keyModel)
    }
}

//struct Plus_Previews: PreviewProvider {
//    static var previews: some View {
//        let keyModel = KeyModel()
//        PlusKey(keyModel: keyModel, textColor: Color(uiColor: keyModel.colorsOf["plusKey"]!.textColor), upColor: Color(uiColor: keyModel.colorsOf["plusKey"]!.upColor), downColor: Color(uiColor: keyModel.colorsOf["plusKey"]!.downColor), size: CGSize(width: 100, height: 100))
//    }
//}
