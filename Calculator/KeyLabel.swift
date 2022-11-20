//
//  KeyLabel.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/19/22.
//

import SwiftUI

let TE_iPhoneSymbolFontSizeReduction = 1.0

class KeyLabel {
    let size: CGSize
    let textColor: Color
    
    init(size: CGSize, textColor: Color) {
        self.size = size
        self.textColor = textColor
    }
    
    @ViewBuilder func of(_ symbol: String) -> some View {
        switch symbol {
        case "√" : RootShape(rootDigit: "2", color: textColor, size: size)
        default:
            if let sfImage = sfImageNames[symbol] {
                Image(systemName: sfImage)
            } else {
                AnyView(Text(symbol))
                    .font(.system(size: size.height*0.4, weight: .semibold))
            }
        }
    }
    
    @ViewBuilder func RootShape(rootDigit: String, color: Color, size: CGSize) -> some View {
        let lineWidth = size.height*0.03
        ZStack {
            RootShape1(part: 1)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: CGLineCap.round, lineJoin: CGLineJoin.bevel))
                .aspectRatio(contentMode: .fit)
            RootShape1(part: 2)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: CGLineCap.round, lineJoin: CGLineJoin.bevel))
                .aspectRatio(contentMode: .fit)
            Text(rootDigit)
                .font(.system(size: size.height*0.17)).bold()
                .foregroundColor(textColor)
                .padding(.leading, size.height * -0.26)
                .padding(.top, size.height * -0.14)
            Text("x")
                .font(.system(size: size.height*0.3)).bold()
                .foregroundColor(textColor)
                .padding(.leading, size.height * 0.1)
                .padding(.top, size.height * 0.05)
        }
    }
    
    private let sfImageNames: [String: String] = [
        "+":   "plus",
        "-":   "minus",
        "x":   "multiply",
        "/":   "divide",
        "+/-": "plus.slash.minus",
        "=":   "equal",
        "%":   "percent",
    ]

    
    struct RootShape1: Shape {
        let part: Int
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let w: CGFloat = rect.size.width
            let h: CGFloat = rect.size.height
            let steepness: CGFloat = 2.8
            let f: CGFloat = 0.6
            let startX: CGFloat = (0.5 - 0.2) * w
            let startY: CGFloat = (0.5 + 0.05) * h
            let downX: CGFloat = startX + f * 0.08 * w
            let downY: CGFloat = startY + f * 0.08 * h * steepness
            let upX: CGFloat = downX + f * 0.2 * w
            let upY: CGFloat = downY - f * 0.2 * h * steepness
            let endX: CGFloat = upX + f * 0.35 * w
            let endY: CGFloat = upY
            
            if part == 1 {
                path.move(to: CGPoint(x: startX, y: startY))
                path.addLine(to: CGPoint(x: downX, y: downY))
                path.addLine(to: CGPoint(x: upX,   y: upY))
            }
            if part == 2 {
                path.move(to: CGPoint(x: upX,  y: upY))
                path.addLine(to: CGPoint(x: endX,  y: endY))
            }
            return path
        }
    }
    
    struct SlashShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let w: CGFloat = rect.size.width
            let h: CGFloat = rect.size.height
            var sw = 0.2 * w
            let steepness: CGFloat = 1.3
            let startX: CGFloat = 0.5 * w - 0.5 * sw * TE_iPhoneSymbolFontSizeReduction
            let startY: CGFloat = 0.5 * h + 0.5 * sw * steepness * TE_iPhoneSymbolFontSizeReduction
            sw *= TE_iPhoneSymbolFontSizeReduction
            let upX: CGFloat = startX+sw
            let upY: CGFloat = startY-sw*steepness
            
            path.move(to: CGPoint(x: startX, y: startY))
            path.addLine(to: CGPoint(x: upX,   y: upY))
            return path
        }
    }
    
//    struct RootShape: Shape {
//        func path(in rect: CGRect) -> Path {
//            var path = Path()
//            let w: CGFloat = rect.size.width
//            let h: CGFloat = rect.size.height
//            let steepness: CGFloat = 2.8
//            let f: CGFloat = 0.6
//            let startX: CGFloat = (0.5 - 0.2) * w
//            let startY: CGFloat = (0.5 + 0.05) * h
//            let downX: CGFloat = startX + f * 0.08 * w
//            let downY: CGFloat = startY + f * 0.08 * h * steepness
//            let upX: CGFloat = downX + f * 0.2 * w
//            let upY: CGFloat = downY - f * 0.2 * h * steepness
//            let endX: CGFloat = upX + f * 0.35 * w
//            let endY: CGFloat = upY
//
//            path.move(to: CGPoint(x: startX, y: startY))
//            path.addLine(to: CGPoint(x: downX, y: downY))
//            path.addLine(to: CGPoint(x: upX,   y: upY))
//            path.addLine(to: CGPoint(x: endX,  y: endY))
//            return path
//        }
//    }
    
    
    
//    struct Root: View {
//        let root: String
//        let strokeColor: Color
//        var body: some View {
//            ZStack {
//                GeometryReader { geo in
//                    let w = geo.size.width * TE_iPhoneSymbolFontSizeReduction
//                    let h = geo.size.height * TE_iPhoneSymbolFontSizeReduction
//                    VStack(spacing:0.0) {
//                        Spacer(minLength: 0.0)
//                        HStack(spacing:0.0) {
//                            ZStack {
//                                Spacer(minLength: 0.0)
//                                let fontSize1:CGFloat = 0.21276 * h
//                                let fontSize2:CGFloat = 0.27659 * h
//                                Text(root)
//                                    .font(.system(size: fontSize1, weight: .semibold))
//                                    .offset(x: -0.18 * w, y: -0.10 * h)
//                                RootShape()
//                                    .stroke(strokeColor, style: StrokeStyle(lineWidth: 1.6 * h / 47.0, lineCap: CGLineCap.square, lineJoin: CGLineJoin.bevel))
//                                Text("X")
//                                    .font(.system(size: fontSize2, weight: .semibold))
//                                    .offset(x: 0.08 * w, y: 0.05 * h)
//                            }
//                            Spacer(minLength: 0.0)
//                        }
//                        Spacer(minLength: 0.0)
//                    }
//                }
//            }
//        }
//        init(_ root: String, strokeColor: Color) {
//            self.strokeColor = strokeColor
//            self.root = root
//        }
//    }
    
    struct One_x: View {
        let strokeColor: Color
        var body: some View {
            ZStack {
                GeometryReader { geo in
                    let w: CGFloat = geo.size.width*TE_iPhoneSymbolFontSizeReduction
                    let h: CGFloat = geo.size.height*TE_iPhoneSymbolFontSizeReduction
                    VStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        HStack(spacing: 0.0) {
                            Spacer(minLength: 0.0)
                            ZStack {
                                Text("1")
                                    .font(.system(size: h * 0.25))
                                    .offset(x: -0.10 * w, y: -0.10 * h)
                                SlashShape()
                                    .stroke(strokeColor, style: StrokeStyle(lineWidth: 1.6 * w / 47.0, lineCap: CGLineCap.square, lineJoin: CGLineJoin.bevel))
                                Text("x")
                                    .font(.system(size: h * 0.25))
                                    .offset(x: 0.10 * w, y: 0.07 * h)
                            }
                            Spacer(minLength: 0.0)
                        }
                        Spacer(minLength: 0.0)
                    }
                }
            }
        }
    }
    
    
    struct Logx: View {
        let base: String
        var body: some View {
            ZStack {
                GeometryReader { geo in
                    let s = min(geo.size.width, geo.size.height)*TE_iPhoneSymbolFontSizeReduction
                    VStack(spacing:0.0) {
                        Spacer(minLength: 0.0)
                        HStack(spacing:0.0) {
                            Spacer(minLength: 0.0)
                            Text("log")
                                .font(.system(size: s * 0.4))
                            Text(base)
                                .font(.system(size: s * 0.22))
                                .offset(x: 0.0, y: 0.13 * s)
                            Spacer(minLength: 0.0)
                        }
                        Spacer(minLength: 0.0)
                    }
                }
            }
        }
        init(_ base: String) { self.base = base }
    }
    
    struct Pow: View {
        let base: String
        let exponent: String
        var body: some View {
            ZStack {
                GeometryReader { geo in
                    let s = min(geo.size.width, geo.size.height) * TE_iPhoneSymbolFontSizeReduction
                    VStack(spacing:0.0) {
                        Spacer(minLength: 0.0)
                        HStack(spacing: 0.0) {
                            Spacer(minLength: 0.0)
                            Text(base)
                                .font(.system(size: s * 0.4))
                            Text(exponent)
                                .font(.system(size: s * 0.22))
                                .offset(x: 0.0, y: -0.13 * s)
                            Spacer(minLength: 0.0)
                        }
                        Spacer(minLength: 0.0)
                    }
                }
            }
        }
    }
    
}

/*private extension ContentView {
    @ViewBuilder func makeButton(symbol: String, strokeColor: Color) -> some View {
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
//            if let sfImage = sfImageNames[symbol] {
//                Image(systemName: sfImage)
//            } else {
//                if symbol.hasSuffix("D") {
//                    Text(symbol.prefix(symbol.count-1))
//                } else {
                    Text(symbol)
//                }
//            }
        }
    }
    
    func makeButtonLabel(symbol: String) -> any View {
        Text(symbol)
    }
}
*/
