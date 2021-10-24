//
//  Key.swift
//  Calculator
//
//  Created by Joachim Neumann on 21/09/2021.
//

import SwiftUI

struct KeyProperties {
    let textColor: Color
    let bgColor: Color
    let downColor: Color
    let downAnimationTime: Double
    let upAnimationTime: Double
}

struct Key: View {
    private let keyProperties: KeyProperties
    private var button: AnyView?
    
    private let sfImageNames: [String: String] = [
        "+":   "plus",
        "-":   "minus",
        "x":   "multiply",
        "/":   "divide",
        "+/-": "plus.slash.minus",
        "=":   "equal",
        "%":   "percent",
    ]

    @ViewBuilder func makeButton(label: String, strokeColor: Color) -> some View {
        switch label {
        case "√":     Root("2", strokeColor: strokeColor)
        case "3√":    Root("3", strokeColor: strokeColor)
        case "y√":    Root("y", strokeColor: strokeColor)
        case "log10": Logx("10")
        case "log2":  Logx("2")
        case "logy":  Logx("y")
        case "One_x": One_x(strokeColor: strokeColor)
        case "x^2":   Pow(base:  "x",   exponent: "2")
        case "x^3":   Pow(base:  "x",   exponent: "3")
        case "x^y":   Pow(base:  "x",   exponent: "y")
        case "e^x":   Pow(base:  "e",   exponent: "x")
        case "y^x":   Pow(base:  "y",   exponent: "x")
        case "2^x":   Pow(base:  "2",   exponent: "x")
        case "10^x":  Pow(base: "10",   exponent: "x")
        case "2nd":   Pow(base: "2",    exponent: "nd")
        case "asin":  Pow(base: "sin",  exponent: "-1")
        case "acos":  Pow(base: "cos",  exponent: "-1")
        case "atan":  Pow(base: "tan",  exponent: "-1")
        case "asinh": Pow(base: "sinh", exponent: "-1")
        case "acosh": Pow(base: "cosh", exponent: "-1")
        case "atanh": Pow(base: "tanh", exponent: "-1")
        default:
            if let sfImage = sfImageNames[label] {
                Image(systemName: sfImage)
            } else {
                Text(label)
            }
        }
    }

    var body: some View {
        button
    }
    
    init(_ text: String, keyProperties: KeyProperties, isPending: Bool = false, isAllowed: Bool = true) {
        self.keyProperties = keyProperties
        let strokeColor = !isAllowed ? Color.gray : (isPending ? keyProperties.bgColor : keyProperties.textColor)
        button = AnyView(makeButton(label: text, strokeColor: strokeColor))
    }
}

private struct Digit_0_to_9: ViewModifier {
    let keyProperties: KeyProperties
    let size: CGSize
    let isAllowed: Bool
    let callback: (() -> Void)?
    func body(content: Content) -> some View {
        content
            .foregroundColor((callback == nil || !isAllowed) ?  Color.gray : keyProperties.textColor)
            .addBackground(with: keyProperties, isAllowed: isAllowed, isPending: false, callback: callback)
            .font(Font.system(size: size.height * 0.48))
    }
}

private struct Colorful_plus_minus_etc: ViewModifier {
    let keyProperties: KeyProperties
    let size: CGSize
    let isAllowed: Bool
    let isPending: Bool
    let callback: (() -> Void)?
    var fg: Color {
        if callback == nil || !isAllowed {
            return Color.gray
        } else {
            if isPending {
                return keyProperties.bgColor
            } else {
                return keyProperties.textColor
            }
        }
    }
    func body(content: Content) -> some View {
        let fontsize = size.height * 0.36
        content
            .foregroundColor(fg)
            .addBackground(with: keyProperties, isAllowed: isAllowed, isPending: isPending, callback: callback)
            .font(Font.system(size: fontsize, weight: .bold))
        
    }
}

private struct PlusMinus_percentage: ViewModifier {
    let keyProperties: KeyProperties
    let size: CGSize
    let isAllowed: Bool
    let callback: (() -> Void)?
    func body(content: Content) -> some View {
        let fontsize = size.height * 0.36
        content
            .foregroundColor((callback == nil || !isAllowed) ?  Color.gray : keyProperties.textColor)
            .addBackground(with: keyProperties, isAllowed: isAllowed, isPending: false, callback: callback)
            .font(Font.system(size: fontsize, weight: .bold))
    }
}

private struct ScientificButton: ViewModifier {
    let keyProperties: KeyProperties
    let fontSize: CGFloat
    let isAllowed: Bool
    let isPending: Bool
    let callback: (() -> Void)?
    var fg: Color {
        if callback == nil || !isAllowed {
            return Color.gray
        } else {
            if isPending {
                return keyProperties.bgColor
            } else {
                return isAllowed ? keyProperties.textColor : Color(white: 0.5)
            }
        }
    }
    func body(content: Content) -> some View {
        content
            .foregroundColor(fg)
            .addBackground(with: keyProperties, isAllowed: isAllowed, isPending: isPending, callback: callback)
            .font(Font.system(size: fontSize, weight: .regular))
    }
}


extension Key {
    func digit_1_to_9(size: CGSize, isAllowed: Bool, callback: (() -> Void)? = nil) -> some View {
        self
            .modifier(Digit_0_to_9(keyProperties: keyProperties, size: size, isAllowed: isAllowed, callback: callback))
            .frame(width: size.width, height: size.height)
    }
    
    func digit_0(size: CGSize, space: CGFloat, isAllowed: Bool, callback: (() -> Void)? = nil ) -> some View {
        HStack {
            self
                .padding(.leading, size.height * 0.4)
            Spacer()
        }
        .modifier(Digit_0_to_9(keyProperties: keyProperties, size: size, isAllowed: isAllowed, callback: callback))
        .frame(width: size.width*2.0+space, height: size.height)
    }
    
    func op_div_mul_add_sub_eq(size: CGSize, isAllowed: Bool, isPending: Bool, callback: (() -> Void)? = nil ) -> some View {
        self
            .modifier(Colorful_plus_minus_etc(keyProperties: keyProperties, size: size, isAllowed: isAllowed, isPending: isPending, callback: callback))
            .frame(width: size.width, height: size.height)
    }
    
    func op_plusMinus_percentage(size: CGSize, isAllowed: Bool, callback: (() -> Void)? = nil ) -> some View {
        self
            .modifier(PlusMinus_percentage(keyProperties: keyProperties, size: size, isAllowed: isAllowed, callback: callback))
            .frame(width: size.width, height: size.height)
    }
    
    func scientific(size: CGSize, fontSize: CGFloat, isAllowed: Bool, isPending: Bool, callback: (() -> Void)? = nil ) -> some View {
        return self
            .modifier(ScientificButton(keyProperties: keyProperties, fontSize: fontSize, isAllowed: isAllowed, isPending: isPending, callback: callback))
            .frame(width: size.width, height: size.height)
    }
}
