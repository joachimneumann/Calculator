//
//  Label.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/19/22.
//

import SwiftUI

func ~=<T: Equatable>(pattern: [T], value: T) -> Bool {
    return pattern.contains(value)
}

struct Label: View {
    let symbol: String
    let size: CGFloat
    let color: Color
    var sizeFactor: CGFloat
    let sfImageforKey: [String: String] = [
        "+": "plus",
        "-": "minus",
        "x": "multiply",
        "/": "divide",
        "±": "plus.slash.minus",
        "=": "equal",
        "%": "percent",
    ]
    
    init(symbol: String, size: CGFloat, color: Color) {
        // let _ = print("LABEL for", symbol)
        self.symbol = symbol
        self.color = color
        
#if os(macOS)
        /// in MacOS, the key shape is a rectangle, which allows for larger labels.
        /// However, I don't want to emphesize the digits as much as on iOS
        let sizeFactorDigits          = 1.5
        let sizeFactorCAC             = 1.4
        let sizeFactorSpecialOperator = 1.12
        let sizeFactorOperator        = 1.04
        let sizeFactorOperatorX       = sizeFactorOperator * 0.86
        let sizeFactorComma           = 1.8
        let sizeFactorScientific      = 1.2
#else
        let sizeFactorDigits          = 1.5
        let sizeFactorCAC             = sizeFactorDigits
        let sizeFactorSpecialOperator = 0.9333
        let sizeFactorOperator        = 0.8666
        let sizeFactorOperatorX       = sizeFactorOperator
        let sizeFactorComma           = 1.5
        let sizeFactorScientific      = 1.0
#endif

        switch symbol {
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            sizeFactor = sizeFactorDigits
        case "C", "AC":
            sizeFactor = sizeFactorCAC
        case "±", "%":
            sizeFactor = sizeFactorSpecialOperator
        case "x":
            sizeFactor = sizeFactorOperatorX
        case _ where sfImageforKey.keys.contains(symbol):
            sizeFactor = sizeFactorOperator
        case ",", ".":
            sizeFactor = sizeFactorComma
        case "One_x":
            sizeFactor = 0.9
        default:
            sizeFactor = sizeFactorScientific
        }
        self.size = size * sizeFactor
    }

    var body: some View {
        // let _ = print("Label \(symbol)")
        switch symbol {
        case "√2":    RootShapeView(rootDigit: "", color: color, size: size, underTheRoot: "2")
        case "√" :    RootShapeView(rootDigit: "2", color: color, size: size)
        case "3√":    RootShapeView(rootDigit: "3", color: color, size: size)
        case "y√":    RootShapeView(rootDigit: "y", color: color, size: size)
        case "log10": Logx(base: "10", size: size)
        case "log2":  Logx(base: "2", size: size)
        case "logy":  Logx(base: "y", size: size)
        case "One_x": One_x(color: color, size: size)
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
        case "asinh": Pow(base: "sinh", exponent: "-1", size: size)
        case "acosh": Pow(base: "cosh", exponent: "-1", size: size)
        case "atanh": Pow(base: "tanh", exponent: "-1", size: size)
        default:
            if let sfImage = sfImageforKey[symbol] {
                Image(systemName: sfImage)
                    .resizable()
                    .font(Font.title.weight(.semibold))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size * 0.3)
                    .accessibilityIdentifier("KeyID_"+symbol)
            } else {
                Text(symbol)
                    .font(.system(size: size * 0.3))
                    .accessibilityIdentifier("KeyID_"+symbol)
            }
        }
    }
    
    private struct Root: View {
        let color: Color
        let size: CGFloat
        var body: some View {
            let lineWidth = size * 0.03
            Path { path in
                // print("Root")
                let steepness: CGFloat = 2.8
                let f: CGFloat = 0.6
                let startX: CGFloat = 0.5 * size - 0.17 * size
                let startY: CGFloat = 0.5 * size + 0.07 * size
                let downX: CGFloat = startX + f * 0.08 * size
                let downY: CGFloat = startY + f * 0.08 * size * steepness
                let upX: CGFloat = downX + f * 0.2 * size
                let upY: CGFloat = downY - f * 0.2 * size * steepness
                let endX: CGFloat = upX + f * 0.35 * size
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

    private struct RootShapeView: View {
        let rootDigit: String
        let color: Color
        let size: CGFloat
        let underTheRoot: String
        
        init(rootDigit: String, color: Color, size: CGFloat, underTheRoot: String = "x") {
            self.rootDigit = rootDigit
            self.color = color
            self.size = size
            self.underTheRoot = underTheRoot
        }
        
        var body: some View {
            let rootSize = size * 0.8
            let fontSize = rootSize * 0.2
            let xFontSize = rootSize * 0.3
            Root(color: color, size: rootSize)
                .frame(width: rootSize, height: rootSize)
            .overlay() {
                Text(rootDigit)
                    .font(.system(size: fontSize, weight: .semibold))
                    .foregroundColor(color)
                    .padding(.leading, rootSize * -0.23)
                    .padding(.top, rootSize * -0.14)
            }
            .overlay() {
                Text(underTheRoot)
                    .font(.system(size: xFontSize, weight: .semibold))
                    .foregroundColor(color)
                    .padding(.leading, rootSize * 0.2)
                    .padding(.top, rootSize * 0.1)
            }
        }
    }

    private struct SlashShape: View {
        let color: Color
        let size: CGFloat
        var body: some View {
            let lineWidth = size * 0.17
            Path { path in
                ///print("SlashShape \(height)")
                let steepness: CGFloat = 1.3
                let startX: CGFloat = 0.5 * size - 0.5 * size
                let startY: CGFloat = 0.5 * size + 0.5 * size * steepness
                let upX: CGFloat = startX + size
                let upY: CGFloat = startY - size * steepness
                
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
        var body: some View {
            let slashSize = size * 0.16
            let fontSize = slashSize * 1.5
            SlashShape(color: color, size: slashSize)
                .frame(width: slashSize, height: slashSize)
                .overlay() {
                    Text("1")
                        .font(.system(size: fontSize))
                        .offset(x: -0.7 * slashSize, y: -0.4 * slashSize)
                }
                .overlay() {
                    Text("x")
                        .font(.system(size: fontSize))
                        .offset(x: 0.6 * slashSize, y: 0.3 * slashSize)
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
                            .font(.system(size: size * 0.18))
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
                            .accessibilityIdentifier("KeyID_"+base+"^"+exponent)
                        Text(exponent)
                            .font(.system(size: size * 0.18))
                            .offset(x: 0.0, y: -0.08 * size)
                        Spacer(minLength: 0.0)
                    }
                    Spacer(minLength: 0.0)
                }
            }
        }
    }
}

