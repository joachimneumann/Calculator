//
//  Keys.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI

struct ZeroKey: View {
    let fontSize: CGFloat
    let callback: () -> Void
    
    @State var pressed = false
    let textColor = Color.white
    let color = Color(
        red:    52.0/255.0,
        green:  52.0/255.0,
        blue:   52.0/255.0)
    let downColor = Color(
        red:   115/255.0,
        green: 115/255.0,
        blue:  115/255.0)
    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .clipped()
                .foregroundColor(pressed ? downColor : color)
                .animation(.easeIn(duration: 0.1), value: pressed)
            Text("0")
                .foregroundColor(textColor)
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
    var AC: Bool
    let fontSize: CGFloat
    let callback: () -> Void
    
    let textColor = Color.white
    let color = Color(
        red:    81.0/255.0,
        green: 181.0/255.0,
        blue:  235.0/255.0)
    let downColor = Color(
        red:   209/255.0,
        green: 222/255.0,
        blue:  243/255.0)
    @State var pressed = false
    var body: some View {
        ZStack {
            Capsule()
                .clipped()
                .foregroundColor(pressed ? downColor : color)
                .animation(.easeIn(duration: 0.1), value: pressed)
            Text(AC ? "AC" : "C")
                .foregroundColor(textColor)
                .font(Font.system(size: fontSize))
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

struct OpKey: View {
    var waiting: Bool
    let text: String
    let fontSize: CGFloat
    let callback: () -> Void
    
    let sfImages: [String: String] = [
        "+": "plus",
        "-": "minus",
        "x": "multiply",
        "/": "divide",
    ]
    let normalTextColor = Color.white
    let normalColor = Color(
        red:    81.0/255.0,
        green: 181.0/255.0,
        blue:  235.0/255.0)
    let downColor = Color(
        red:   209/255.0,
        green: 222/255.0,
        blue:  243/255.0)
    @State var pressed = false

    var textColor: Color {
        waiting ? normalColor : normalTextColor
    }
    var bgColor: Color {
        waiting ? normalTextColor : normalColor
    }
    var body: some View {
        ZStack {
            Capsule()
                .clipped()
                .foregroundColor(pressed ? downColor : bgColor)
                .animation(.easeIn(duration: 0.1), value: pressed)
            if let sfImage = sfImages[text] {
                Image(systemName: sfImage)
                    .foregroundColor(textColor)
            } else {
                Text(text)
                    .foregroundColor(textColor)
            }
        }
        .font(Font.system(size: fontSize).bold())
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

struct GrayKey: View {
    let sfImages: [String: String] = [
        "+/-": "plus.forwardslash.minus",
        "=": "equal",
        "%": "percent",
    ]
    let text: String
    let fontSize: CGFloat
    let callback: () -> Void
    
    @State var pressed = false
    let textColor = Color.white
    let color = Color(
        red:    52.0/255.0,
        green:  52.0/255.0,
        blue:   52.0/255.0)
    let downColor = Color(
        red:   115/255.0,
        green: 115/255.0,
        blue:  115/255.0)
    
    var body: some View {
        ZStack {
            Capsule()
                .clipped()
                .foregroundColor(pressed ? downColor : color)
                .animation(.easeIn(duration: 0.1), value: pressed)
            if let sfImage = sfImages[text] {
                Image(systemName: sfImage)
                    .foregroundColor(textColor)
            } else {
                Text(text)
                    .foregroundColor(textColor)
            }
        }
        .font(Font.system(size: fontSize))
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

struct LightgrayKey: View {
    let sfImages: [String: String] = [
        "+/-": "plus.forwardslash.minus",
        "=": "equal",
        "%": "percent",
    ]
    let text: String
    let fontSize: CGFloat
    let callback: () -> Void
    
    @State var pressed = false
    let textColor = Color.white
    let color = Color(
        red:    52.0/255.0,
        green:  52.0/255.0,
        blue:   52.0/255.0)
    let downColor = Color(
        red:   115/255.0,
        green: 115/255.0,
        blue:  115/255.0)
    
    var body: some View {
        ZStack {
            Capsule()
                .clipped()
                .foregroundColor(pressed ? downColor : color)
                .animation(.easeIn(duration: 0.1), value: pressed)
            if let sfImage = sfImages[text] {
                Image(systemName: sfImage)
                    .foregroundColor(textColor)
            } else {
                Text(text)
                    .foregroundColor(textColor)
            }
        }
        .font(Font.system(size: fontSize))
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
            ZeroKey(fontSize: 100) {}
                        .background(Color.green)
            GrayKey(text: "6",
                    fontSize: 100) {}
                        .background(Color.green)
            CKey(AC: false,
                 fontSize: 100) {}
                    .background(Color.green)
            OpKey(waiting: false,
                  text: "/",
                  fontSize: 100) {}
                    .background(Color.green)
        }
    }
}
