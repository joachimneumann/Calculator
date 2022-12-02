//
//  NonScientificKeys.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/20/22.
//

import SwiftUI

struct NonScientificKeys: View {
    @ObservedObject var keyModel: KeyModel
    let spaceBetweenKeys: CGFloat
    let keySize: CGSize
    let doubleKeySize: CGSize
    
    init(keyModel: KeyModel, spaceBetweenKeys: CGFloat, size: CGSize) {
        print("NonScientificKeys init()")
        self.keyModel = keyModel
        self.spaceBetweenKeys = spaceBetweenKeys
        let w = (size.width - 3.0 * spaceBetweenKeys) / 4.0
        let h = (size.height - 4.0 * spaceBetweenKeys) / 5.0
        self.keySize = CGSize(width: w, height: h)
        self.doubleKeySize = CGSize(width: 2.0 * w + spaceBetweenKeys, height: h)
    }
    
    var body: some View {
        VStack(spacing: spaceBetweenKeys) {
            HStack(spacing: spaceBetweenKeys) {
                Key(keyModel._AC ? "AC" : "C", keyModel: keyModel, size: keySize)
                Key("±", keyModel: keyModel, size: keySize)
                Key("%", keyModel: keyModel, size: keySize)
                Key("/", keyModel: keyModel, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("7", keyModel: keyModel, size: keySize)
                Key("8", keyModel: keyModel, size: keySize)
                Key("9", keyModel: keyModel, size: keySize)
                Key("x", keyModel: keyModel, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("4", keyModel: keyModel, size: keySize)
                Key("5", keyModel: keyModel, size: keySize)
                Key("6", keyModel: keyModel, size: keySize)
                Key("-", keyModel: keyModel, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("1", keyModel: keyModel, size: keySize)
                Key("2", keyModel: keyModel, size: keySize)
                Key("3", keyModel: keyModel, size: keySize)
                Key("+", keyModel: keyModel, size: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                Key("0", keyModel: keyModel, size: doubleKeySize)
                Key(",", keyModel: keyModel, size: keySize)
                Key("=", keyModel: keyModel, size: keySize)
            }
        }
    }
}

struct NonScientificKeys_Previews: PreviewProvider {
    static var previews: some View {
        NonScientificKeys(keyModel: KeyModel(), spaceBetweenKeys: 10, size: CGSize(width: 250, height: 300))
    }
}

