//
//  NonScientificKeys.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/20/22.
//

import SwiftUI

struct NonScientificKeys: View {
    @StateObject private var keyModel = KeyModel()
    let spaceBetweenKeys: CGFloat
    let keySize: CGSize
    let doubleKeySize: CGSize

    init(spaceBetweenKeys: CGFloat, size: CGSize) {
        self.spaceBetweenKeys = spaceBetweenKeys
        let w = (size.width - 3.0 * spaceBetweenKeys) / 4.0
        let h = (size.width - 4.0 * spaceBetweenKeys) / 5.0
        self.keySize = CGSize(width: w, height: h)
        self.doubleKeySize = CGSize(width: 2.0 * w + spaceBetweenKeys, height: h)
    }
    var body: some View {
        VStack(spacing: spaceBetweenKeys) {
            HStack(spacing: spaceBetweenKeys) {
                Key("C", size: keySize, keyColors: keyModel.allKeyColors["C"]!, callback: keyModel.pressed)
                Key("+/-", size: keySize, keyColors: keyModel.allKeyColors["+/-"]!, callback: keyModel.pressed)
                Key("%", size: keySize, keyColors: keyModel.allKeyColors["%"]!, callback: keyModel.pressed)
                Key("/", size: keySize, keyColors: keyModel.allKeyColors["/"]!, callback: keyModel.pressed)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("7", size: keySize, keyColors: keyModel.allKeyColors["7"]!, callback: keyModel.pressed)
                Key("8", size: keySize, keyColors: keyModel.allKeyColors["8"]!, callback: keyModel.pressed)
                Key("9", size: keySize, keyColors: keyModel.allKeyColors["9"]!, callback: keyModel.pressed)
                Key("x", size: keySize, keyColors: keyModel.allKeyColors["x"]!, callback: keyModel.pressed)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("4", size: keySize, keyColors: keyModel.allKeyColors["4"]!, callback: keyModel.pressed)
                Key("5", size: keySize, keyColors: keyModel.allKeyColors["5"]!, callback: keyModel.pressed)
                Key("6", size: keySize, keyColors: keyModel.allKeyColors["6"]!, callback: keyModel.pressed)
                Key("-", size: keySize, keyColors: keyModel.allKeyColors["-"]!, callback: keyModel.pressed)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("1", size: keySize, keyColors: keyModel.allKeyColors["1"]!, callback: keyModel.pressed)
                Key("2", size: keySize, keyColors: keyModel.allKeyColors["2"]!, callback: keyModel.pressed)
                Key("3", size: keySize, keyColors: keyModel.allKeyColors["3"]!, callback: keyModel.pressed)
                Key("+", size: keySize, keyColors: keyModel.allKeyColors["+"]!, callback: keyModel.pressed)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("0", size: doubleKeySize, keyColors: keyModel.allKeyColors["0"]!, callback: keyModel.pressed)
                Key(",", size: keySize, keyColors: keyModel.allKeyColors[","]!, callback: keyModel.pressed)
                Key("=", size: keySize, keyColors: keyModel.allKeyColors["="]!, callback: keyModel.pressed)
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
