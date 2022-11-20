//
//  KeyModelOld.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/19/22.
//

import SwiftUI

class KeyModelOld: ObservableObject {
    let shape: any View = Capsule()
    @ViewBuilder func makeC() -> some View {
        Capsule()
    }

    @ViewBuilder func makeButton(strokeColor: Color) -> some View {
//        switch symbol {
//        case "√":     Root("2", strokeColor: strokeColor)
//        case "3√":    Root("3", strokeColor: strokeColor)
//        case "y√":    Root("y", strokeColor: strokeColor)
//        case "log10": Logx("10")
//        case "log2":  Logx("2")
//        case "logy":  Logx("y")
//        case "One_x": One_x(strokeColor: strokeColor)
//        case "x^2":   Pow(base:  "x",   exponent: "2")
//        case "x^3":   Pow(base:  "x",   exponent: "3")
//        case "x^y":   Pow(base:  "x",   exponent: "y")
//        case "e^x":   Pow(base:  "e",   exponent: "x")
//        case "y^x":   Pow(base:  "y",   exponent: "x")
//        case "2^x":   Pow(base:  "2",   exponent: "x")
//        case "10^x":  Pow(base: "10",   exponent: "x")
//        case "2nd":   Pow(base: "2",    exponent: "nd")
//        case "asin":  Pow(base: "sin",  exponent: "-1")
//        case "acos":  Pow(base: "cos",  exponent: "-1")
//        case "atan":  Pow(base: "tan",  exponent: "-1")
//        case "asinD":  Pow(base: "sin",  exponent: "-1")
//        case "acosD":  Pow(base: "cos",  exponent: "-1")
//        case "atanD":  Pow(base: "tan",  exponent: "-1")
//        case "asinh": Pow(base: "sinh", exponent: "-1")
//        case "acosh": Pow(base: "cosh", exponent: "-1")
//        case "atanh": Pow(base: "tanh", exponent: "-1")
//        default:
//            if let sfImage = sfImageNames[symbol] {
//                Image(systemName: sfImage)
//            } else {
//                if symbol.hasSuffix("D") {
//                    Text(symbol.prefix(symbol.count-1))
//                } else {
//                    Text(symbol)
//                }
//            }
//        }
    }
}
