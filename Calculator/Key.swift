//
//  Key.swift
//  Calculator
//
//  Created by Joachim Neumann on 21/09/2021.
//

import SwiftUI

struct Key: View {
    let symbol: String
    let requiresValidNuber: Bool
    let brain: Brain
    let t: TE
    let keyProperties: KeyProperties
    private var button: AnyView?
    @State var down: Bool = false
    //@State var enabled: Bool = true

    private let sfImageNames: [String: String] = [
        "+":   "plus",
        "-":   "minus",
        "x":   "multiply",
        "/":   "divide",
        "+/-": "plus.slash.minus",
        "=":   "equal",
        "%":   "percent",
    ]
    
    @ViewBuilder func makeButton(strokeColor: Color) -> some View {
        switch symbol {
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
        case "asinD":  Pow(base: "sin",  exponent: "-1")
        case "acosD":  Pow(base: "cos",  exponent: "-1")
        case "atanD":  Pow(base: "tan",  exponent: "-1")
        case "asinh": Pow(base: "sinh", exponent: "-1")
        case "acosh": Pow(base: "cosh", exponent: "-1")
        case "atanh": Pow(base: "tanh", exponent: "-1")
        default:
            if let sfImage = sfImageNames[symbol] {
                Image(systemName: sfImage)
            } else {
                if symbol.hasSuffix("D") {
                    Text(symbol.prefix(symbol.count-1))
                } else {
                    Text(symbol)
                }
            }
        }
    }
    
    var body: some View {
        let enabled = (!requiresValidNuber || brain.isValidNumber) && !brain.isCalculating && (symbol != "mr" || brain.memory != nil)
        ZStack {
            TE.ButtonShape()
                .foregroundColor(bgColor(enabled: enabled, pending: brain.isPending(symbol)))
                .frame(width: keyProperties.size.width, height: keyProperties.size.height)
            button
                .font(keyProperties.font)
                .foregroundColor(fgColor(enabled: enabled, pending: brain.isPending(symbol)))
        }
        .gesture(
            DragGesture(minimumDistance: 0.0)
                .onChanged() { value in
                    if !down {
                        withAnimation(.easeIn(duration: keyProperties.downAnimationTime)) {
                            if !brain.isCalculating && enabled {
                                //print("down true")
                                down = true
                            }
                        }
                    }
                }
                .onEnded() { value in
                    withAnimation(.easeIn(duration: keyProperties.upAnimationTime)) {
                        //print("down false")
                        down = false
                    }
                    if !brain.isCalculating && enabled {
                        brain.asyncOperation(symbol)
                    }
                }
        )
    }
    
    func bgColor(enabled: Bool, pending: Bool) -> Color {
        if pending {
            return keyProperties.textColor
        } else if down {
            return keyProperties.downBgColor
        } else {
            return keyProperties.bgColor
        }
    }
    func fgColor(enabled: Bool, pending: Bool) -> Color {
        if enabled {
            if pending {
                return keyProperties.bgColor
            } else {
                return keyProperties.textColor
            }
        } else {
            return Color.gray
        }
    }
    
    init(_ symbol: String, requiresValidNuber: Bool, brain: Brain, t: TE, keyProperties: KeyProperties) {
        self.symbol = symbol
        self.requiresValidNuber = requiresValidNuber
        self.brain = brain
        self.t = t
        self.keyProperties = keyProperties
        let enabled = (!requiresValidNuber || brain.isValidNumber) && !brain.isCalculating
        button = AnyView(makeButton(strokeColor: fgColor(enabled: enabled, pending: false)))
    }
}

//private struct Digit_0_to_9: ViewModifier {
//    let keyProperties: KeyProperties
//    let size: CGSize
//    let brain: Brain
//    let callback: (() -> Void)?
//    func body(content: Content) -> some View {
//        content
//            .foregroundColor(brain.isCalculating ?  Color.gray : keyProperties.textColor)
//            .addBackground(with: keyProperties, brain: brain, isPending: false, callback: callback)
//            .font(Font.system(size: size.height * 0.48))
//    }
//}
//
//private struct Colorful_plus_minus_etc: ViewModifier {
//    let keyProperties: KeyProperties
//    let size: CGSize
//    let brain: Brain
//    let isPending: Bool
//    let callback: (() -> Void)?
//    var fg: Color {
//        if brain.isCalculating {
//            return Color.gray
//        } else {
//            if isPending {
//                return keyProperties.bgColor
//            } else {
//                return keyProperties.textColor
//            }
//        }
//    }
//    func body(content: Content) -> some View {
//        let fontsize = size.height * 0.36
//        content
//            .foregroundColor(fg)
//            .addBackground(with: keyProperties, brain: brain, isPending: isPending, callback: callback)
//            .font(Font.system(size: fontsize, weight: .bold))
//
//    }
//}
//
//private struct PlusMinus_percentage: ViewModifier {
//    let keyProperties: KeyProperties
//    let size: CGSize
//    let brain: Brain
//    let callback: (() -> Void)?
//    func body(content: Content) -> some View {
//        let fontsize = size.height * 0.36
//        content
//            .foregroundColor(brain.isCalculating ?  Color.gray : keyProperties.textColor)
//            .addBackground(with: keyProperties, brain: brain, isPending: false, callback: callback)
//            .font(Font.system(size: fontsize, weight: .bold))
//    }
//}
//
//private struct ScientificButton: ViewModifier {
//    let keyProperties: KeyProperties
//    let fontSize: CGFloat
//    let brain: Brain
//    let isPending: Bool
//    let callback: (() -> Void)?
//    var fg: Color {
//        //print("ScientificButton fg brain.isCalculating = \(brain.isCalculating)")
//        if brain.isCalculating || !brain.isValidNumber{
//            return Color.gray
//        } else {
//            if isPending {
//                return keyProperties.bgColor
//            } else {
//                return keyProperties.textColor // brain.isCalculating ? keyProperties.textColor : Color(white: 0.5)
//            }
//        }
//    }
//    func body(content: Content) -> some View {
//        content
//            .foregroundColor(fg)
//            .addBackground(with: keyProperties, brain: brain, isPending: isPending, callback: callback)
//            .font(Font.system(size: fontSize, weight: .regular))
//    }
//}
//
//
//extension Key {
//    func digit_1_to_9(size: CGSize, brain: Brain, callback: (() -> Void)? = nil) -> some View {
//        self
//            .modifier(Digit_0_to_9(keyProperties: keyProperties, size: size, brain: brain, callback: callback))
//            .frame(width: size.width, height: size.height)
//    }
//
//    func digit_0(size: CGSize, space: CGFloat, brain: Brain, callback: (() -> Void)? = nil ) -> some View {
//        HStack {
//            self
//                .padding(.leading, size.height * 0.4)
//            Spacer()
//        }
//        .modifier(Digit_0_to_9(keyProperties: keyProperties, size: size, brain: brain, callback: callback))
//        .frame(width: size.width*2.0+space, height: size.height)
//    }
//
//    func op_div_mul_add_sub_eq(size: CGSize, brain: Brain, isPending: Bool, callback: (() -> Void)? = nil ) -> some View {
//        self
//            .modifier(Colorful_plus_minus_etc(keyProperties: keyProperties, size: size, brain: brain, isPending: isPending, callback: callback))
//            .frame(width: size.width, height: size.height)
//    }
//
//    func op_plusMinus_percentage(size: CGSize, brain: Brain, callback: (() -> Void)? = nil ) -> some View {
//        self
//            .modifier(PlusMinus_percentage(keyProperties: keyProperties, size: size, brain: brain, callback: callback))
//            .frame(width: size.width, height: size.height)
//    }
//
//    func scientific(size: CGSize, fontSize: CGFloat, brain: Brain, isPending: Bool, callback: (() -> Void)? = nil ) -> some View {
//        return self
//            .modifier(ScientificButton(keyProperties: keyProperties, fontSize: fontSize, brain: brain, isPending: isPending, callback: callback))
//            .frame(width: size.width, height: size.height)
//    }
//}
