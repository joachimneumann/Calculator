//
//  Key.swift
//  Calculator
//
//  Created by Joachim Neumann on 21/09/2021.
//

import SwiftUI


struct Key: View {
    private var asText: Text? = nil
    private var asImage: Image? = nil
    private var asView: AnyView? = nil
    
    private let sfImageNames: [String: String] = [
        "+":   "plus",
        "-":   "minus",
        "x":   "multiply",
        "/":   "divide",
        "+/-": "plus.slash.minus",
        "=":   "equal",
        "%":   "percent",
    ]

    private func shape(name: String, strokeColor: Color) -> AnyView? {
        switch name {
        case "√":        return AnyView(Root("2", strokeColor: strokeColor))
        case "3√":       return AnyView(Root("3", strokeColor: strokeColor))
        case "y√":       return AnyView(Root("y", strokeColor: strokeColor))
        case "log10":    return AnyView(Log10())
        case "log2":     return AnyView(Logx("2"))
        case "logy":     return AnyView(Logx("y"))
        case "One_x":    return AnyView(One_x())
        case "x^2":      return AnyView(Pow(base:  "x",   exponent: "2",  baseXOffset: 0.0,   exponentXOffset: 0.0))
        case "x^3":      return AnyView(Pow(base:  "x",   exponent: "3",  baseXOffset: 0.0,   exponentXOffset: 0.0))
        case "x^y":      return AnyView(Pow(base:  "x",   exponent: "y",  baseXOffset: 0.0,   exponentXOffset: 0.0))
        case "e^x":      return AnyView(Pow(base:  "e",   exponent: "x",  baseXOffset: 0.0,   exponentXOffset: 0.0))
        case "y^x":      return AnyView(Pow(base:  "y",   exponent: "x",  baseXOffset: 0.0,   exponentXOffset: 0.0))
        case "2^x":      return AnyView(Pow(base:  "2",   exponent: "x",  baseXOffset: 0.0,   exponentXOffset: 0.0))
        case "10^x":     return AnyView(Pow(base: "10",   exponent: "x",  baseXOffset: 0.0,   exponentXOffset: 0.1))
        case "2nd":      return AnyView(Pow(base: "2",    exponent: "nd", baseXOffset: -0.05, exponentXOffset: 0.0))
        case "asin":     return AnyView(Pow(base: "sin",  exponent: "-1", baseXOffset: 0.0,   exponentXOffset: 0.14))
        case "acos":     return AnyView(Pow(base: "cos",  exponent: "-1", baseXOffset: 0.0,   exponentXOffset: 0.2))
        case "atan":     return AnyView(Pow(base: "tan",  exponent: "-1", baseXOffset: 0.0,   exponentXOffset: 0.18))
        case "asinh":    return AnyView(Pow(base: "sinh", exponent: "-1", baseXOffset: 0.0,   exponentXOffset: 0.25))
        case "acosh":    return AnyView(Pow(base: "cosh", exponent: "-1", baseXOffset: 0.0,   exponentXOffset: 0.30))
        case "atanh":    return AnyView(Pow(base: "tanh", exponent: "-1", baseXOffset: 0.0,   exponentXOffset: 0.29))
        default: return nil
        }
    }

    var body: some View {
        if let asImage = asImage {
            asImage
        } else if let asView = asView {
            asView
        } else if let asText = asText {
            asText
        }
    }
    
    init(_ text: String, isPending: Bool = false) {
        let strokeColor = isPending ? Configuration.shared.LightGrayKeyProperties.color : Configuration.shared.LightGrayKeyProperties.textColor
        if let sfImage = sfImageNames[text] {
            asImage = Image(systemName: sfImage)
        } else if let shape = shape(name: text, strokeColor: strokeColor) {
            asView = shape
        } else {
            asText = Text(text)
        }
    }
}

private struct Digit_0_to_9: ViewModifier {
    let size: CGSize
    let isAllowed: Bool
    let callback: (() -> Void)?
    func body(content: Content) -> some View {
        content
            .foregroundColor(callback == nil ?  Color.gray : Configuration.shared.DigitKeyProperties.textColor)
            .addBackground(with: Configuration.shared.DigitKeyProperties, isAllowed: isAllowed, isPending: false, callback: callback)
            .font(.system(size: size.height * CGFloat(0.48)))
    }
}

private struct Colorful_plus_minus_etc: ViewModifier {
    let size: CGSize
    let isAllowed: Bool
    let isPending: Bool
    let callback: (() -> Void)?
    var fg: Color {
        if callback == nil {
            return Color.gray
        } else {
            if isPending {
                return Configuration.shared.OpKeyProperties.color
            } else {
                return Configuration.shared.OpKeyProperties.textColor
            }
        }
    }
    func body(content: Content) -> some View {
        let fontsize = size.height * CGFloat(0.36)
        content
            .foregroundColor(fg)
            .addBackground(with: Configuration.shared.OpKeyProperties, isAllowed: isAllowed, isPending: isPending, callback: callback)
            .font(.system(size: fontsize, weight: .bold))
        
    }
}

private struct PlusMinus_percentage: ViewModifier {
    let size: CGSize
    let isAllowed: Bool
    let callback: (() -> Void)?
    func body(content: Content) -> some View {
        let fontsize = size.height * 0.36
        content
            .foregroundColor(callback == nil ?  Color.gray : Configuration.shared.LightGrayKeyProperties.textColor)
            .addBackground(with: Configuration.shared.LightGrayKeyProperties, isAllowed: isAllowed, isPending: false, callback: callback)
            .font(.system(size: fontsize, weight: .bold))
    }
}

private struct ScientificButton: ViewModifier {
    let size: CGSize
    let isAllowed: Bool
    let isPending: Bool
    let isActive: Bool
    let callback: (() -> Void)?
    var fg: Color {
        if callback == nil {
            return Color.gray
        } else {
            if isPending {
                return Configuration.shared.LightGrayKeyProperties.color
            } else {
                return isActive ? Configuration.shared.LightGrayKeyProperties.textColor : Color(white: 0.5)
            }
        }
    }
    func body(content: Content) -> some View {
        let fontsize = size.height * 0.40
        content
            .foregroundColor(fg)
            .addBackground(with: Configuration.shared.LightGrayKeyProperties, isAllowed: isAllowed, isPending: isPending, callback: callback)
            .font(.system(size: fontsize, weight: .regular))
    }
}


extension View {
    func digit_1_to_9(size: CGSize, isAllowed: Bool, callback: (() -> Void)? = nil) -> some View {
        self
            .modifier(Digit_0_to_9(size: size, isAllowed: isAllowed, callback: callback))
            .frame(width: size.width, height: size.height)
    }
    
    func digit_0(size: CGSize, space: CGFloat, isAllowed: Bool, callback: (() -> Void)? = nil ) -> some View {
        HStack {
            self
                .padding(.leading, size.height * 0.4)
            Spacer()
        }
        .modifier(Digit_0_to_9(size: size, isAllowed: isAllowed, callback: callback))
        .frame(width: size.width*2+space, height: size.height)
    }
    
    func op_div_mul_add_sub_eq(size: CGSize, isAllowed: Bool, isPending: Bool, callback: (() -> Void)? = nil ) -> some View {
        self
            .modifier(Colorful_plus_minus_etc(size: size, isAllowed: isAllowed, isPending: isPending, callback: callback))
            .frame(width: size.width, height: size.height)
    }
    
    func op_plusMinus_percentage(size: CGSize, isAllowed: Bool, callback: (() -> Void)? = nil ) -> some View {
        self
            .modifier(PlusMinus_percentage(size: size, isAllowed: isAllowed, callback: callback))
            .frame(width: size.width, height: size.height)
    }
    
    func scientific(size: CGSize, isAllowed: Bool, isPending: Bool, isActive: Bool = true, callback: (() -> Void)? = nil ) -> some View {
        self
            .modifier(ScientificButton(size: size, isAllowed: isAllowed, isPending: isPending, isActive: isActive, callback: callback))
            .frame(width: size.width, height: size.height)
    }
}
