//
//  Label.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/19/22.
//

import SwiftUI

struct Label: View {
    let keyInfo: KeyModel.KeyInfo
    let height: CGFloat
    var body: some View {
        let color = Color(uiColor: keyInfo.colors.textColor)
        let symbol = keyInfo.symbol
        let _ = print("Label \(symbol)")
        switch symbol {
        case "√" :    RootShapeView(rootDigit: "2", color: color, height: height)
        case "3√":    RootShapeView(rootDigit: "3", color: color, height: height)
        case "y√":    RootShapeView(rootDigit: "y", color: color, height: height)
        case "log10": Logx(base: "10", height: height)
        case "log2":  Logx(base: "2", height: height)
        case "logy":  Logx(base: "y", height: height)
        case "One_x": One_x(color: color, height: height)
        case "x^2":   Pow(base:  "x",   exponent: "2", height: height)
        case "x^3":   Pow(base:  "x",   exponent: "3", height: height)
        case "x^y":   Pow(base:  "x",   exponent: "y", height: height)
        case "e^x":   Pow(base:  "e",   exponent: "x", height: height)
        case "y^x":   Pow(base:  "y",   exponent: "x", height: height)
        case "2^x":   Pow(base:  "2",   exponent: "x", height: height)
        case "10^x":  Pow(base: "10",   exponent: "x", height: height)
        case "2nd":   Pow(base: "2",    exponent: "nd", height: height)
        case "asin":  Pow(base: "sin",  exponent: "-1", height: height)
        case "acos":  Pow(base: "cos",  exponent: "-1", height: height)
        case "atan":  Pow(base: "tan",  exponent: "-1", height: height)
        case "asinh": Pow(base: "sinh", exponent: "-1", height: height)
        case "acosh": Pow(base: "cosh", exponent: "-1", height: height)
        case "atanh": Pow(base: "tanh", exponent: "-1", height: height)
        default:
            if let sfImage = sfImageNames[symbol] {
                Image(systemName: sfImage)
                    .resizable()
                    .font(Font.title.weight(.semibold))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: symbol == "±" || symbol == "%" ? height*0.25 : height*0.23)
            } else {
                let _ = print("of Text")
                Text(symbol)
                    .font(.system(size: height*0.4, weight: .none))
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

    private struct RootShapeView: View {
        let rootDigit: String
        let color: Color
        let height: CGFloat
        var body: some View {
            let lineWidth = height*0.03
            ZStack {
                Root(color: color, lineWidth: lineWidth, height: height)
                Text(rootDigit)
                    .font(.system(size: height*0.17, weight: .semibold))
                    .foregroundColor(color)
                    .padding(.leading, height * -0.27)
                    .padding(.top, height * -0.14)
                Text("x")
                    .font(.system(size: height*0.3, weight: .semibold))
                    .foregroundColor(color)
                    .padding(.leading, height * 0.1)
                    .padding(.top, height * 0.05)
            }
        }
    }

    private struct Root: View {
        let color: Color
        let lineWidth: CGFloat
        let height: CGFloat
        var body: some View {
            Path { path in
                // print("Root")
                let steepness: CGFloat = 2.8
                let f: CGFloat = 0.6
                let startX: CGFloat = 0.3 * height
                let startY: CGFloat = (0.5 + 0.05) * height
                let downX: CGFloat = startX + f * 0.08 * height
                let downY: CGFloat = startY + f * 0.08 * height * steepness
                let upX: CGFloat = downX + f * 0.2 * height
                let upY: CGFloat = downY - f * 0.2 * height * steepness
                let endX: CGFloat = upX + f * 0.35 * height
                let endY: CGFloat = upY
                
                path.move(to: CGPoint(x: startX, y: startY))
                path.addLine(to: CGPoint(x: downX, y: downY))
                path.addLine(to: CGPoint(x: upX,   y: upY))
                path.addLine(to: CGPoint(x: endX,  y: endY))
            }
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: CGLineCap.round, lineJoin: CGLineJoin.round))
            .aspectRatio(contentMode: .fit)
        }
    }

    private struct SlashShape: View {
        let color: Color
        let lineWidth: CGFloat
        let height: CGFloat
        var body: some View {
            Path { path in
                ///print("SlashShape \(height)")
                let sw = 0.2 * height
                let steepness: CGFloat = 1.3
                let startX: CGFloat = 0.5 * height - 0.5 * sw
                let startY: CGFloat = 0.5 * height + 0.5 * sw * steepness
                let upX: CGFloat = startX + sw
                let upY: CGFloat = startY - sw * steepness
                
                path.move(to: CGPoint(x: startX, y: startY))
                path.addLine(to: CGPoint(x: upX,   y: upY))
            }
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: CGLineCap.round))
            .aspectRatio(contentMode: .fit)
        }
    }

    private struct One_x: View {
        let color: Color
        let height: CGFloat
        var body: some View {
            ///let _ = print("One_x \(height)")
            ZStack {
                VStack(spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    HStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        ZStack {
                            Text("1")
                                .font(.system(size: height * 0.25))
                                .offset(x: -0.1 * height, y: -0.10 * height)
                            SlashShape(color: color, lineWidth: height * 0.034, height: height)
                            Text("x")
                                .font(.system(size: height * 0.25))
                                .offset(x: 0.1 * height, y: 0.07 * height)
                        }
                        Spacer(minLength: 0.0)
                    }
                    Spacer(minLength: 0.0)
                }
            }
        }
    }


    private struct Logx: View {
        let base: String
        let height: CGFloat
        var body: some View {
            ZStack {
                VStack(spacing:0.0) {
                    Spacer(minLength: 0.0)
                    HStack(spacing:0.0) {
                        Spacer(minLength: 0.0)
                        Text("log")
                            .font(.system(size: height * 0.4))
                        Text(base)
                            .font(.system(size: height * 0.22))
                            .offset(x: 0.0, y: 0.13 * height)
                        Spacer(minLength: 0.0)
                    }
                    Spacer(minLength: 0.0)
                }
            }
        }
    }

    private struct Pow: View {
        let base: String
        let exponent: String
        let height: CGFloat
        var body: some View {
            ZStack {
                VStack(spacing:0.0) {
                    Spacer(minLength: 0.0)
                    HStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        Text(base)
                            .font(.system(size: height * 0.4))
                        Text(exponent)
                            .font(.system(size: height * 0.22))
                            .offset(x: 0.0, y: -0.13 * height)
                        Spacer(minLength: 0.0)
                    }
                    Spacer(minLength: 0.0)
                }
            }
        }
    }
}


struct Label_Previews: PreviewProvider {
    static var previews: some View {
        let h = 131.1
        let keyInfo = KeyModel.KeyInfo(symbol: "One_x", colors: C.getKeyColors(for: "One_x"))
        VStack {
            Label(keyInfo: keyInfo, height: h)
                .foregroundColor(Color.white)
                .frame(width: h, height: h)
                .background(Color.black)
                .clipShape(Capsule())
                .padding(.bottom, 20)
            Label(keyInfo: keyInfo, height: h)
                .foregroundColor(Color.white)
                .frame(width: h*2, height: h)
                .background(Color.black)
                .clipShape(Capsule())
                .padding(.bottom, 20)
            Label(keyInfo: keyInfo, height: h)
                .foregroundColor(Color.white)
                .frame(width: h*3, height: h)
                .background(Color.black)
                .clipShape(Capsule())
                .padding(.bottom, 20)
        }
    }
}