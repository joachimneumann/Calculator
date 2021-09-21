//
//  Digit.swift
//  Calculator
//
//  Created by Joachim Neumann on 21/09/2021.
//

import SwiftUI

let sfImages: [String: String] = [
    "+": "plus",
    "-": "minus",
    "x": "multiply",
    "/": "divide",
    "+/-": "plus.forwardslash.minus",
    "=": "equal",
    "%": "percent",
]

struct Key: View {
    let content: AnyView
    var body: some View {
        content
    }
    init(_ text: String) {
        if let sfImage = sfImages[text] {
            content = AnyView(Image(systemName: sfImage))
        } else {
            content = AnyView(Text(text))
        }
    }
}

struct KeyProperties {
    let textColor: Color
    let color: Color
    let downColor: Color
    let downAnimationTime: Double
    let upAnimationTime: Double
}

let DigitKeyProperties = KeyProperties(
    textColor: Color.white,
    color: Color(
        red:    51.0/255.0,
        green:  51.0/255.0,
        blue:   51.0/255.0),
    downColor: Color(
        red:   115/255.0,
        green: 115/255.0,
        blue:  115/255.0),
    downAnimationTime: 0.1,
    upAnimationTime: 0.5)


let OpKeyProperties = KeyProperties(
    textColor: Color.white,
    color: Color(
        red:    81.0/255.0,
        green: 181.0/255.0,
        blue:  235.0/255.0),
    downColor: Color(
        red:   209/255.0,
        green: 222/255.0,
        blue:  243/255.0),
    downAnimationTime: 0.1,
    upAnimationTime: 0.3)

let LightGrayKeyProperties = KeyProperties(
    textColor: Color.black,
    color: Color(
        red:   165.0/255.0,
        green: 165.0/255.0,
        blue:  165.0/255.0),
    downColor: Color(
        red:   216/255.0,
        green: 216/255.0,
        blue:  216/255.0),
    downAnimationTime: 0.1,
    upAnimationTime: 0.5)


struct Digit: ViewModifier {
    let size: CGSize
    func body(content: Content) -> some View {
        let fontsize = size.height * 0.45
        content
            .foregroundColor(DigitKeyProperties.textColor)
            .placeInCapsule(with: DigitKeyProperties)
            .font(.system(size: fontsize))
    }
}

struct Op: ViewModifier {
    let size: CGSize
    func body(content: Content) -> some View {
        let fontsize = size.height * 0.36
        content
            .foregroundColor(OpKeyProperties.textColor)
            .placeInCapsule(with: OpKeyProperties)
            .font(.system(size: fontsize, weight: .bold))
        
    }
}

struct Op2: ViewModifier {
    let size: CGSize
    func body(content: Content) -> some View {
        let fontsize = size.height * 0.33
        content
            .foregroundColor(LightGrayKeyProperties.textColor)
            .placeInCapsule(with: LightGrayKeyProperties)
            .font(.system(size: fontsize, weight: .semibold))
    }
}

struct Op3: ViewModifier {
    let size: CGSize
    func body(content: Content) -> some View {
        let fontsize = size.height * 0.42
        content
            .foregroundColor(LightGrayKeyProperties.textColor)
            .placeInCapsule(with: LightGrayKeyProperties)
            .font(.system(size: fontsize, weight: .medium))
    }
}


extension View {
    func digit(size: CGSize) -> some View {
        self
            .modifier(Digit(size: size))
            .frame(width: size.width, height: size.height)
    }
    
    func zero(size: CGSize, horizontalSpace: CGFloat) -> some View {
        HStack {
            self
                .padding(.leading, size.height * 0.4)
            Spacer()
        }
        .modifier(Digit(size: size))
        .frame(width: size.width*2+horizontalSpace, height: size.height)
    }
    
    func op(size: CGSize) -> some View {
        self
            .modifier(Op(size: size))
            .frame(width: size.width, height: size.height)
    }

    func op2(size: CGSize) -> some View {
        self
            .modifier(Op2(size: size))
            .frame(width: size.width, height: size.height)
    }

    func op3(size: CGSize) -> some View {
        self
            .modifier(Op3(size: size))
            .frame(width: size.width, height: size.height)
    }
}
