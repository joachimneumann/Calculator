//
//  Key.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI

struct ZeroKey: View {
    let fontSize: CGFloat
    let properties: TextKeyproperties
    let callback: () -> Void
    @State var pressed = false
    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .clipped()
                .foregroundColor(pressed ? properties.downColor : properties.color)
                .animation(.easeIn(duration: 0.1), value: pressed)
            Text("0")
                .foregroundColor(properties.textColor)
            //.background(Color.orange)
                .font(Font.system(size: fontSize))
                .padding(.leading, fontSize)
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

struct CKey: View {
    @Binding var AC: Bool
    let fontSize: CGFloat
    let properties: TextKeyproperties
    let callback: () -> Void
    @State var pressed = false
    var body: some View {
        ZStack {
            Capsule()
                .clipped()
                .foregroundColor(pressed ? properties.downColor : properties.color)
                .animation(.easeIn(duration: 0.1), value: pressed)
            Text(AC ? "AC" : "C")
                .foregroundColor(properties.textColor)
                .font(Font.system(size: fontSize))
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    pressed = true
                    AC = true
                }
                .onEnded { value in
                    pressed = false
                    callback()
                }
        )
    }
}

struct OpKey: View {
    @Binding var waiting: Bool
    let text: String
    let fontSize: CGFloat
    let properties: TextKeyproperties
    let callback: () -> Void

    let sfImages: [String: String] = [
        "+/-": "plus.forwardslash.minus",
        "+": "plus",
        "-": "minus",
        "x": "multiply",
        "/": "divide",
        "=": "equal",
        "%": "percent",
    ]
    @State var pressed = false
    var textColor: Color {
        waiting ? properties.color : properties.textColor
    }
    var bgColor: Color {
        waiting ? properties.textColor : properties.color
    }
    var body: some View {
        ZStack {
            Capsule()
                .clipped()
                .foregroundColor(pressed ? properties.downColor : bgColor)
                .animation(.easeIn(duration: 0.1), value: pressed)
            let font = properties.bold ? Font.system(size: fontSize).bold() : Font.system(size: fontSize)
            if let sfImage = sfImages[text] {
                Image(systemName: sfImage)
                    .foregroundColor(textColor)
                    .font(font)
            } else {
                Text(text)
                    .foregroundColor(textColor)
                    .font(font)
            }
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

struct Key: View {
    let sfImages: [String: String] = [
        "+/-": "plus.forwardslash.minus",
        "+": "plus",
        "-": "minus",
        "x": "multiply",
        "/": "divide",
        "=": "equal",
        "%": "percent",
    ]
    let text: String
    let fontSize: CGFloat
    let properties: TextKeyproperties
    let callback: () -> Void
    @State var pressed = false
    var body: some View {
        ZStack {
            Capsule()
                .clipped()
                .foregroundColor(pressed ? properties.downColor : properties.color)
                .animation(.easeIn(duration: 0.1), value: pressed)
            let font = properties.bold ? Font.system(size: fontSize).bold() : Font.system(size: fontSize)
            if let sfImage = sfImages[text] {
                Image(systemName: sfImage)
                    .foregroundColor(properties.textColor)
                    .font(font)
            } else {
                Text(text)
                    .foregroundColor(properties.textColor)
                //.background(Color.orange)
                    .font(font)
            }
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
        VStack {
            ZeroKey(fontSize: 100,
                    properties: TextKeyproperties(
                        textColor: Color.white,
                        bold: true,
                        color: Color(white: 0.6),
                        downColor: Color(white: 0.7))) {}
                        .background(Color.green)
            Key(text: "6",
                fontSize: 100,
                properties: TextKeyproperties(
                    textColor: Color.white,
                    bold: true,
                    color: Color(white: 0.6),
                    downColor: Color(white: 0.7))) {}
                    .background(Color.green)
            CKey(AC: .constant(false),
                 fontSize: 100,
                 properties: TextKeyproperties(
                    textColor: Color.white,
                    bold: true,
                    color: Color(white: 0.6),
                    downColor: Color(white: 0.7))) {}
                    .background(Color.green)
            OpKey(waiting: .constant(false),
                  text: "/",
                 fontSize: 100,
                 properties: TextKeyproperties(
                    textColor: Color.yellow,
                    bold: true,
                    color: Color(white: 0.6),
                    downColor: Color(white: 0.7))) {}
                    .background(Color.green)
        }
    }
}
