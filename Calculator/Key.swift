//
//  Key.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI

struct Key: View {
    let text: String
    let fontSize: CGFloat
    let properties: TextKeyproperties
    let callback: () -> Void
    @State var pressed = false
    var body: some View {
        return ZStack {
            Capsule()
                .clipped()
                .foregroundColor(pressed ? properties.downColor : properties.color)
                .animation(.easeIn(duration: 0.1), value: pressed)
            Text(text)
                .foregroundColor(properties.textColor)
                .font(.system(size: fontSize))
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    pressed = true
                }
                .onEnded { value in
                    pressed = false
                    callback()
                }
        )
    }
}

struct Key_Previews: PreviewProvider {
    static var previews: some View {
        Key(text: "1",
                fontSize: 30,
                properties: TextKeyproperties(
                    textColor: Color.white,
                    color: Color(white: 0.6),
                    downColor: Color(white: 0.7))) {}
                .background(Color.green)
    }
}
