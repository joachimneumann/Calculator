//
//  KeyView.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct KeyView: View {
    var shape: any View
    var content: any View

    init(isCapsule: Bool, content: any View) {
        if isCapsule { self.shape = Capsule() } else { self.shape = Rectangle() }
        self.content = content
    }
    var body: some View {
        ZStack {
            Capsule()
//            shape
//            content
            //            keyModel.shape
            //            .foregroundColor(bgColor(enabled: isEnabled, pending: isPending))
            //            .frame(width: keyProperties.size.width, height: keyProperties.size.height)
            //        if symbol == "0" {
            //            button
            //                .font(keyProperties.font)
            //                .foregroundColor(fgColor(enabled: isEnabled, pending: isPending))
            //                .padding(.trailing, zeroTrailingPadding)
            //        } else {
            //            button
            //                .font(keyProperties.font)
            //                .foregroundColor(fgColor(enabled: isEnabled, pending: isPending))
            //                .padding(.bottom, keyProperties.bottomPadding)
            //                .gesture(
            //                    DragGesture(minimumDistance: 0.0)
            //                        .onChanged() { value in
            //                            if !down {
            //                                withAnimation(.easeIn(duration: keyProperties.downAnimationTime)) {
            //                                    if isEnabled {
            //                                        //print("down true")
            //                                        down = true
            //                                    }
            //                                }
            //                            }
            //                        }
            //                        .onEnded() { value in
            //                            withAnimation(.easeIn(duration: keyProperties.upAnimationTime)) {
            //                                //print("down false")
            //                                down = false
            //                            }
            //                            if isEnabled {
            //                                callback(symbol)
            //                            }
            //                        }
            //                )
        }
    }
}

/*
 struct KeyView: View {
 let symbol: String
 let callback: (String) -> ()
 let isEnabled: Bool
 let isPending: Bool
 let zeroTrailingPadding: CGFloat = 0.0
 let keyProperties: KeyProperties
 private var button: AnyView?
 @State private var down: Bool = false
 
 private let sfImageNames: [String: String] = [
 "+":   "plus",
 "-":   "minus",
 "x":   "multiply",
 "/":   "divide",
 "±": "plus.slash.minus",
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
 
 init(_ symbol: String, callback: @escaping (String) -> (), enabled: Bool, pending: Bool, keyProperties: KeyProperties) {
 self.symbol = symbol
 self.callback = callback
 self.isEnabled = enabled
 self.isPending = pending
 self.keyProperties = keyProperties
 //        let enabled = (!requiresValidNuber || brain.isValidNumber) && !brain.isCalculating
 button = AnyView(makeButton(strokeColor: fgColor(enabled: enabled, pending: pending)))
 }
 
 var body: some View {
 ZStack {
 TE.ButtonShape()
 .foregroundColor(bgColor(enabled: isEnabled, pending: isPending))
 .frame(width: keyProperties.size.width, height: keyProperties.size.height)
 if symbol == "0" {
 button
 .font(keyProperties.font)
 .foregroundColor(fgColor(enabled: isEnabled, pending: isPending))
 .padding(.trailing, zeroTrailingPadding)
 } else {
 button
 .font(keyProperties.font)
 .foregroundColor(fgColor(enabled: isEnabled, pending: isPending))
 .padding(.bottom, keyProperties.bottomPadding)
 }
 }
 .gesture(
 DragGesture(minimumDistance: 0.0)
 .onChanged() { value in
 if !down {
 withAnimation(.easeIn(duration: keyProperties.downAnimationTime)) {
 if isEnabled {
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
 if isEnabled {
 callback(symbol)
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
 return keyProperties.disabledColor
 }
 }
 }
 
 */
func dummy(s: String) {
}
struct KeyView2_Previews: PreviewProvider {
    static var previews: some View {
        KeyView(isCapsule: true, content: Text("xx"))
//        let digits_1_9 = KeyProperties(
//            size: CGSize(width: 25, height: 25),
//            font: Font.system(size: 25).monospacedDigit(),
//            textColor: Color(
//                red:   231.0/255.0,
//                green: 231.0/255.0,
//                blue:  231.0/255.0),
//            disabledColor: Color.gray,
//            bgColor: Color(
//                red:   51.0/255.0,
//                green: 51.0/255.0,
//                blue:  51.0/255.0),
//            downBgColor: Color(
//                red:   160.0/255.0,
//                green: 159.0/255.0,
//                blue:  158.0/255.0),
//            downAnimationTime: 0.1,
//            upAnimationTime: 0.5,
//            bottomPadding: 0.0)
//        KeyView("AC", callback: dummy, enabled: true, pending: false, keyProperties: digits_1_9)
    }
}

