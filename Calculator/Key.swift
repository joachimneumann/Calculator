//
//  Key.swift
//  Calculator
//
//  Created by Joachim Neumann on 21/09/2021.
//

import SwiftUI


struct Key: View {
    private let asText: Text
    private var asImage: Image? = nil

    private let sfImageNames: [String: String] = [
        "+":   "plus",
        "-":   "minus",
        "x":   "multiply",
        "/":   "divide",
        "+/-": "plus.forwardslash.minus",
        "=":   "equal",
        "%":   "percent",
    ]

    var body: some View {
        if let asImage = asImage {
            asImage
        } else {
            asText
        }
    }
    init(_ text: String) {
        asText = Text(text)
        if let sfImage = sfImageNames[text] {
            asImage = Image(systemName: sfImage)
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
        red:   105.0/255.0,
        green: 183.0/255.0,
        blue:  191.0/255.0),
    downColor: Color(
        red:   203/255.0,
        green: 230/255.0,
        blue:  232/255.0),
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


private struct Digit_0_to_9: ViewModifier {
    let size: CGSize
    let callback: () -> Void
    func body(content: Content) -> some View {
        let fontsize = size.height * 0.45
        content
            .foregroundColor(DigitKeyProperties.textColor)
            .placeInCapsule(with: DigitKeyProperties, callback: callback)
            .font(.system(size: fontsize))
    }
}

private struct Colorful_plus_minus_etc: ViewModifier {
    let size: CGSize
    let callback: () -> Void
    func body(content: Content) -> some View {
        let fontsize = size.height * 0.36
        content
            .foregroundColor(OpKeyProperties.textColor)
            .placeInCapsule(with: OpKeyProperties, callback: callback)
            .font(.system(size: fontsize, weight: .bold))
        
    }
}

private struct PlusMinus_percentage: ViewModifier {
    let size: CGSize
    let callback: () -> Void
    func body(content: Content) -> some View {
        let fontsize = size.height * 0.33
        content
            .foregroundColor(LightGrayKeyProperties.textColor)
            .placeInCapsule(with: LightGrayKeyProperties, callback: callback)
            .font(.system(size: fontsize, weight: .semibold))
    }
}

private struct ClearButton: ViewModifier {
    let size: CGSize
    let callback: () -> Void
    func body(content: Content) -> some View {
        let fontsize = size.height * 0.42
        content
            .foregroundColor(LightGrayKeyProperties.textColor)
            .placeInCapsule(with: LightGrayKeyProperties, callback: callback)
            .font(.system(size: fontsize, weight: .medium))
    }
}


extension View {
    func digit_1_to_9(size: CGSize, callback: @escaping () -> Void) -> some View {
        self
            .modifier(Digit_0_to_9(size: size, callback: callback))
            .frame(width: size.width, height: size.height)
    }
    
    func digit_0(size: CGSize, horizontalSpace: CGFloat, callback: @escaping () -> Void) -> some View {
        HStack {
            self
                .padding(.leading, size.height * 0.4)
            Spacer()
        }
        .modifier(Digit_0_to_9(size: size, callback: callback))
        .frame(width: size.width*2+horizontalSpace, height: size.height)
    }
    
    func op_div_mul_add_sub_eq(size: CGSize, callback: @escaping () -> Void) -> some View {
        self
            .modifier(Colorful_plus_minus_etc(size: size, callback: callback))
            .frame(width: size.width, height: size.height)
    }

    func op_plusMinus_percentage(size: CGSize, callback: @escaping () -> Void) -> some View {
        self
            .modifier(PlusMinus_percentage(size: size, callback: callback))
            .frame(width: size.width, height: size.height)
    }

    func op_clear(size: CGSize, callback: @escaping () -> Void) -> some View {
        self
            .modifier(ClearButton(size: size, callback: callback))
            .frame(width: size.width, height: size.height)
    }
}
