//
//  KeyLabel.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/19/22.
//

import SwiftUI

class KeyLabel {
    let size: CGSize
    let textColor: Color
    
    init(size: CGSize, textColor: Color) {
        self.size = size
        self.textColor = textColor
    }
    
    @ViewBuilder func of(_ symbol: String) -> some View {
        let _ = print("ViewBuilder KeyLabel.of()")
        switch symbol {
        case "√" :    RootShapeView(rootDigit: "2", color: textColor, size: size)
        case "3√":    RootShapeView(rootDigit: "3", color: textColor, size: size)
        case "y√":    RootShapeView(rootDigit: "y", color: textColor, size: size)
        case "log10": Logx(base: "10", size: size)
        case "log2":  Logx(base: "2", size: size)
        case "logy":  Logx(base: "y", size: size)
        case "One_x": One_x(color: textColor, size: size)
        case "x^2":   Pow(base:  "x",   exponent: "2", size: size)
        case "x^3":   Pow(base:  "x",   exponent: "3", size: size)
        case "x^y":   Pow(base:  "x",   exponent: "y", size: size)
        case "e^x":   Pow(base:  "e",   exponent: "x", size: size)
        case "y^x":   Pow(base:  "y",   exponent: "x", size: size)
        case "2^x":   Pow(base:  "2",   exponent: "x", size: size)
        case "10^x":  Pow(base: "10",   exponent: "x", size: size)
        case "2nd":   Pow(base: "2",    exponent: "nd", size: size)
        case "asin":  Pow(base: "sin",  exponent: "-1", size: size)
        case "acos":  Pow(base: "cos",  exponent: "-1", size: size)
        case "atan":  Pow(base: "tan",  exponent: "-1", size: size)
        case "asinD": Pow(base: "sin",  exponent: "-1", size: size)
        case "acosD": Pow(base: "cos",  exponent: "-1", size: size)
        case "atanD": Pow(base: "tan",  exponent: "-1", size: size)
        case "asinh": Pow(base: "sinh", exponent: "-1", size: size)
        case "acosh": Pow(base: "cosh", exponent: "-1", size: size)
        case "atanh": Pow(base: "tanh", exponent: "-1", size: size)
        default:
            if let sfImage = sfImageNames[symbol] {
                Image(systemName: sfImage)
                    .resizable()
                    .font(Font.title.weight(.semibold))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: (symbol == "±" || symbol == "%") ? size.height*0.25 : size.height*0.23)
            } else {
                Text(symbol)
                    .font(.system(size: size.height*0.4, weight: .none))
            }
        }
    }
    
    private let sfImageNames: [String: String] = [
        "+":   "plus",
        "-":   "minus",
        "x":   "multiply",
        "/":   "divide",
        "±": "plus.slash.minus",
        "=":   "equal",
        "%":   "percent",
    ]

    struct RootShapeView: View {
        let rootDigit: String
        let color: Color
        let size: CGSize
        var body: some View {
            let lineWidth = size.height*0.03
            ZStack {
                RootShape(part: 1)
                    .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: CGLineCap.round, lineJoin: CGLineJoin.bevel))
                    .aspectRatio(contentMode: .fit)
                RootShape(part: 2)
                    .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: CGLineCap.round, lineJoin: CGLineJoin.bevel))
                    .aspectRatio(contentMode: .fit)
                Text(rootDigit)
                    .font(.system(size: size.height*0.17, weight: .semibold))
                    .foregroundColor(color)
                    .padding(.leading, size.height * -0.26)
                    .padding(.top, size.height * -0.14)
                Text("x")
                    .font(.system(size: size.height*0.3, weight: .semibold))
                    .foregroundColor(color)
                    .padding(.leading, size.height * 0.1)
                    .padding(.top, size.height * 0.05)
            }
        }
    }
    
    struct RootShape: Shape {
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
            let sw = 0.2 * h
            let steepness: CGFloat = 1.3
            let startX: CGFloat = 0.5 * w - 0.5 * sw
            let startY: CGFloat = 0.5 * h + 0.5 * sw * steepness
            let upX: CGFloat = startX+sw
            let upY: CGFloat = startY-sw*steepness
            
            path.move(to: CGPoint(x: startX, y: startY))
            path.addLine(to: CGPoint(x: upX,   y: upY))
            return path
        }
    }
    
    struct One_x: View {
        let color: Color
        let size: CGSize
        var body: some View {
            ZStack {
                    let h: CGFloat = size.height
                    VStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        HStack(spacing: 0.0) {
                            Spacer(minLength: 0.0)
                            ZStack {
                                Text("1")
                                    .font(.system(size: h * 0.25))
                                    .offset(x: -0.1 * h, y: -0.10 * h)
                                SlashShape()
                                    .stroke(color, style: StrokeStyle(lineWidth: 1.6 * h / 47.0, lineCap: CGLineCap.square, lineJoin: CGLineJoin.bevel))
                                Text("x")
                                    .font(.system(size: h * 0.25))
                                    .offset(x: 0.1 * h, y: 0.07 * h)
                            }
                            Spacer(minLength: 0.0)
                        }
                        Spacer(minLength: 0.0)
                }
            }
        }
    }
    
    
    struct Logx: View {
        let base: String
        let size: CGSize
        var body: some View {
            ZStack {
                let s = min(size.width, size.height)
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
    
    struct Pow: View {
        let base: String
        let exponent: String
        let size: CGSize
        var body: some View {
            ZStack {
                    let s = min(size.width, size.height)
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

struct KeyLabel_Previews: PreviewProvider {
    static var previews: some View {
        let w = 131.7
        let h = 57.1
//        let h = 131.7
        let size = CGSize(width: w, height: h)
        let keyLabel = KeyLabel(size: size, textColor: Color.white)
        let keyContent2: any View = keyLabel.of("x^2")
        let keyContent1: any View = keyLabel.of("One_x")
        VStack {
            AnyView(keyContent1)
                .foregroundColor(Color.white)
                .frame(width: w, height: h)
                .background(Color.black)
                .padding(.bottom, 20)
            AnyView(keyContent2)
                .foregroundColor(Color.white)
                .frame(width: w, height: h)
                .background(Color.black)
        }
    }
}
