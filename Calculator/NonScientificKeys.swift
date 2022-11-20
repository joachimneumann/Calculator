//
//  NonScientificKeys.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/20/22.
//

import SwiftUI

struct NonScientificKeys: View {
    let keyModel = KeyModel()
    let spaceBetweenKeys: CGFloat
    let keySize: CGSize
    let doubleKeySize: CGSize
    let keyColors: KeyColors

    init(spaceBetweenKeys: CGFloat, size: CGSize) {
        keyColors = KeyColors(textColor: Color.white, upColor: Color.red, downColor: Color.orange)
        self.spaceBetweenKeys = spaceBetweenKeys
        let w = (size.width - 3.0 * spaceBetweenKeys) / 4.0
        let h = (size.width - 4.0 * spaceBetweenKeys) / 5.0
        self.keySize = CGSize(width: w, height: h)
        self.doubleKeySize = CGSize(width: 2.0 * w + spaceBetweenKeys, height: h)
    }
    var body: some View {
        VStack(spacing: spaceBetweenKeys) {
            HStack(spacing: spaceBetweenKeys) {
                Key("C", size: keySize, keyColors: keyModel.keyColors(symbol: "C"), callback: keyModel.pressed)
                Key("+/-", size: keySize, keyColors: keyModel.keyColors(symbol: "+/-"), callback: keyModel.pressed)
                Key("%", size: keySize, keyColors: keyModel.keyColors(symbol: "%"), callback: keyModel.pressed)
                Key("/", size: keySize, keyColors: keyModel.keyColors(symbol: "/"), callback: keyModel.pressed)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("7", size: keySize, keyColors: keyModel.keyColors(symbol: "7"), callback: keyModel.pressed)
                Key("8", size: keySize, keyColors: keyModel.keyColors(symbol: "8"), callback: keyModel.pressed)
                Key("9", size: keySize, keyColors: keyModel.keyColors(symbol: "9"), callback: keyModel.pressed)
                Key("x", size: keySize, keyColors: keyModel.keyColors(symbol: "x"), callback: keyModel.pressed)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("4", size: keySize, keyColors: keyModel.keyColors(symbol: "4"), callback: keyModel.pressed)
                Key("5", size: keySize, keyColors: keyModel.keyColors(symbol: "5"), callback: keyModel.pressed)
                Key("6", size: keySize, keyColors: keyModel.keyColors(symbol: "6"), callback: keyModel.pressed)
                Key("-", size: keySize, keyColors: keyModel.keyColors(symbol: "-"), callback: keyModel.pressed)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("1", size: keySize, keyColors: keyModel.keyColors(symbol: "1"), callback: keyModel.pressed)
                Key("2", size: keySize, keyColors: keyModel.keyColors(symbol: "2"), callback: keyModel.pressed)
                Key("3", size: keySize, keyColors: keyModel.keyColors(symbol: "3"), callback: keyModel.pressed)
                Key("+", size: keySize, keyColors: keyModel.keyColors(symbol: "+"), callback: keyModel.pressed)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("0", size: doubleKeySize, keyColors: keyModel.keyColors(symbol: "0"), callback: keyModel.pressed)
                Key(",", size: keySize, keyColors: keyModel.keyColors(symbol: ","), callback: keyModel.pressed)
                Key("=", size: keySize, keyColors: keyModel.keyColors(symbol: "="), callback: keyModel.pressed)
            }
        }
        .background(Color.black)
    }
}

struct NonScientificKeys_Previews: PreviewProvider {
    static var previews: some View {
        NonScientificKeys(spaceBetweenKeys: 10, size: CGSize(width: 300, height: 500))
    }
}
