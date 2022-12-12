//
//  Label.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/19/22.
//

import SwiftUI

struct Label: View {
    let keyInfo: Model.KeyInfo
    let size: CGFloat
    let color: Color
    var sizeFactor: CGFloat
    init(keyInfo: Model.KeyInfo, size: CGFloat, color: Color = Color.white) {
        self.keyInfo = keyInfo
        self.size = size
        self.color = color
        sizeFactor = Label.sizeFactorText
        if C.digitOperators.contains(keyInfo.symbol) ||  keyInfo.symbol == "C" || keyInfo.symbol == "AC" {
            sizeFactor = Label.sizeFactorDigits
        } else if C.sfImageNames.keys.contains(keyInfo.symbol) {
            if keyInfo.symbol == "±" || keyInfo.symbol == "%" {
                sizeFactor = Label.sizeFactorSpecialOperator
            } else {
                sizeFactor = Label.sizeFactorOperator
            }
        }
    }

    static let factor = 1.0
    static let sizeFactorText = 0.3 * factor
    static let sizeFactorDigits = 0.4 * factor
    static let sizeFactorSpecialOperator = 0.28 * factor
    static let sizeFactorOperator = 0.26 * factor
    static let sizeFactorSmallText = 0.22 * factor
    static let sizeFactorLargeText = 0.4 * factor
//    static let sizeFactorText = 0.35
//    static let sizeFactorSpecialOperator = 0.25
//    static let sizeFactorOperator = 0.23
//    static let sizeFactorSmallText = 0.22
//    static let sizeFactorLargeText = 0.4

    var body: some View {
        let symbol = keyInfo.symbol
        //let _ = print("Label \(symbol)")
        switch symbol {
        case "√" :    RootShapeView(rootDigit: "2", color: color, size: size, factor: Label.factor)
        case "3√":    RootShapeView(rootDigit: "3", color: color, size: size, factor: Label.factor)
        case "y√":    RootShapeView(rootDigit: "y", color: color, size: size, factor: Label.factor)
        case "log10": Logx(base: "10", size: size * Label.factor)
        case "log2":  Logx(base: "2", size: size * Label.factor)
        case "logy":  Logx(base: "y", size: size * Label.factor)
        case "One_x": One_x(color: color, size: size, factor: Label.factor)
        case "x^2":   Pow(base:  "x",   exponent: "2", size: size * Label.factor)
        case "x^3":   Pow(base:  "x",   exponent: "3", size: size * Label.factor)
        case "x^y":   Pow(base:  "x",   exponent: "y", size: size * Label.factor)
        case "e^x":   Pow(base:  "e",   exponent: "x", size: size * Label.factor)
        case "y^x":   Pow(base:  "y",   exponent: "x", size: size * Label.factor)
        case "2^x":   Pow(base:  "2",   exponent: "x", size: size * Label.factor)
        case "10^x":  Pow(base: "10",   exponent: "x", size: size * Label.factor)
        case "2nd":   Pow(base: "2",    exponent: "nd", size: size * Label.factor)
        case "asin":  Pow(base: "sin",  exponent: "-1", size: size * Label.factor)
        case "acos":  Pow(base: "cos",  exponent: "-1", size: size * Label.factor)
        case "atan":  Pow(base: "tan",  exponent: "-1", size: size * Label.factor)
        case "asinh": Pow(base: "sinh", exponent: "-1", size: size * Label.factor)
        case "acosh": Pow(base: "cosh", exponent: "-1", size: size * Label.factor)
        case "atanh": Pow(base: "tanh", exponent: "-1", size: size * Label.factor)
        default:
            if let sfImage = C.sfImageNames[symbol] {
                Image(systemName: sfImage)
                    .resizable()
                    .font(Font.title.weight(.semibold))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size * sizeFactor)
            } else {
                Text(symbol)
                    .font(.system(size: size*sizeFactor, weight: .none))
            }
        }
    }
    
    private struct RootShapeView: View {
        let rootDigit: String
        let color: Color
        let size: CGFloat
        let factor: CGFloat
        var body: some View {
            let rootSize = size * factor * 0.8
            let rootFontSize = rootSize * 0.2
            let xFontSize = rootSize * 0.3
            Root(color: color, keySize: size, rootSize: rootSize)
            .overlay() {
                Text(rootDigit)
                    .font(.system(size: rootFontSize, weight: .semibold))
                    .foregroundColor(color)
                    .padding(.leading, rootSize * -0.27)
                    .padding(.top, rootSize * -0.14)
            }
            .overlay() {
                Text("x")
                    .font(.system(size: xFontSize, weight: .semibold))
                    .foregroundColor(color)
                    .padding(.leading, rootSize * 0.2)
                    .padding(.top, rootSize * 0.1)
            }
        }
    }

    private struct Root: View {
        let color: Color
        let keySize: CGFloat
        let rootSize: CGFloat
        var body: some View {
            let lineWidth = rootSize * 0.03
            Path { path in
                // print("Root")
                let steepness: CGFloat = 2.8
                let f: CGFloat = 0.6
                let startX: CGFloat = 0.5 * keySize - 0.17 * rootSize
                let startY: CGFloat = 0.5 * keySize + 0.07 * rootSize
                let downX: CGFloat = startX + f * 0.08 * rootSize
                let downY: CGFloat = startY + f * 0.08 * rootSize * steepness
                let upX: CGFloat = downX + f * 0.2 * rootSize
                let upY: CGFloat = downY - f * 0.2 * rootSize * steepness
                let endX: CGFloat = upX + f * 0.35 * rootSize
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
        let keySize: CGFloat
        let factor: CGFloat
        var body: some View {
            let slashSize = keySize * 0.2 * factor
            let lineWidth = slashSize * 0.17
            Path { path in
                ///print("SlashShape \(height)")
                let steepness: CGFloat = 1.3
                let startX: CGFloat = 0.5 * keySize - 0.5 * slashSize
                let startY: CGFloat = 0.5 * keySize + 0.5 * slashSize * steepness
                let upX: CGFloat = startX + slashSize
                let upY: CGFloat = startY - slashSize * steepness
                
                path.move(to: CGPoint(x: startX, y: startY))
                path.addLine(to: CGPoint(x: upX,   y: upY))
            }
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: CGLineCap.round))
            .aspectRatio(contentMode: .fit)
        }
    }

    private struct One_x: View {
        let color: Color
        let size: CGFloat
        let factor: CGFloat
        var body: some View {
            let slashSize = size * factor * 0.8
            let fontSize = slashSize * 0.3
            SlashShape(color: color, keySize: size, factor: factor * 0.8)
                .overlay() {
                    Text("1")
                        .font(.system(size: fontSize))
                        .offset(x: -0.14 * slashSize, y: -0.10 * slashSize)
                }
                .overlay() {
                    Text("x")
                        .font(.system(size: fontSize))
                        .offset(x: 0.13 * slashSize, y: 0.07 * slashSize)
                }
        }
    }


    private struct Logx: View {
        let base: String
        let size: CGFloat
        var body: some View {
            ZStack {
                VStack(spacing:0.0) {
                    Spacer(minLength: 0.0)
                    HStack(spacing:0.0) {
                        Spacer(minLength: 0.0)
                        Text("log")
                            .font(.system(size: size * 0.3))
                        Text(base)
                            .font(.system(size: size * 0.22))
                            .offset(x: 0.0, y: 0.13 * size)
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
        let size: CGFloat
        var body: some View {
            ZStack {
                VStack(spacing:0.0) {
                    Spacer(minLength: 0.0)
                    HStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        Text(base)
                            .font(.system(size: size * 0.3))
                        Text(exponent)
                            .font(.system(size: size * 0.22))
                            .offset(x: 0.0, y: -0.1 * size)
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
        let keyInfo1 = Model.KeyInfo(symbol: "log10", colors: C.getKeyColors(for: "log10"))
        let keyInfo2 = Model.KeyInfo(symbol: "Rand", colors: C.getKeyColors(for: "One_x"))
        let keyInfo3 = Model.KeyInfo(symbol: "x", colors: C.getKeyColors(for: "x"))
        HStack {
            VStack {
                Label(keyInfo: keyInfo1, size: h)
                    .foregroundColor(Color.white)
                    .frame(width: h, height: h)
                    .background(Color.black)
                    .clipShape(Capsule())
                    .padding(.bottom, 20)
                Label(keyInfo: keyInfo1, size: h)
                    .foregroundColor(Color.white)
                    .frame(width: h*2, height: h)
                    .background(Color.black)
                    .clipShape(Capsule())
                    .padding(.bottom, 20)
            }
            VStack {
                Label(keyInfo: keyInfo2, size: h)
                    .foregroundColor(Color.white)
                    .frame(width: h, height: h)
                    .background(Color.black)
                    .clipShape(Capsule())
                    .padding(.bottom, 20)
                Label(keyInfo: keyInfo2, size: h)
                    .foregroundColor(Color.white)
                    .frame(width: h*2, height: h)
                    .background(Color.black)
                    .clipShape(Capsule())
                    .padding(.bottom, 20)
            }
            VStack {
                Label(keyInfo: keyInfo3, size: h)
                    .foregroundColor(Color.white)
                    .frame(width: h, height: h)
                    .background(Color.black)
                    .clipShape(Capsule())
                    .padding(.bottom, 20)
                Label(keyInfo: keyInfo3, size: h)
                    .foregroundColor(Color.white)
                    .frame(width: h*2, height: h)
                    .background(Color.black)
                    .clipShape(Capsule())
                    .padding(.bottom, 20)
            }
        }
    }
}
