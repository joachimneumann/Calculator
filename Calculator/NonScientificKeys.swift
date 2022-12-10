//
//  NonScientificKeys.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/20/22.
//

import SwiftUI

struct KeyPrep: View {
    let symbol: String
    var model: Model
    let keySize: CGSize
    var body: some View {
        Key(keyInfo: model.keyInfo[symbol]!, callback: keyCallback, size: keySize)
    }
    func keyCallback() {
        if model.keyInfo[symbol]!.enabled {
            model.pressed(symbol)
        }
    }
}

struct NonScientificKeys: View {
    @ObservedObject var model: Model
    let spaceBetweenKeys: CGFloat
    let size: CGSize
    
    var body: some View {
        let w = (size.width - 3.0 * spaceBetweenKeys) / 4.0
        let h = (size.height - 4.0 * spaceBetweenKeys) / 5.0
        let keySize = CGSize(width: w, height: h)
        let doubleKeySize = CGSize(width: 2.0 * w + spaceBetweenKeys, height: h)

        VStack(spacing: spaceBetweenKeys) {
            HStack(spacing: spaceBetweenKeys) {
                KeyPrep(symbol: model._AC ? "AC" : "C", model: model, keySize: keySize)
                KeyPrep(symbol: "±", model: model, keySize: keySize)
                KeyPrep(symbol: "%", model: model, keySize: keySize)
                KeyPrep(symbol: "/", model: model, keySize: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyPrep(symbol: "7", model: model, keySize: keySize)
                KeyPrep(symbol: "8", model: model, keySize: keySize)
                KeyPrep(symbol: "9", model: model, keySize: keySize)
                KeyPrep(symbol: "x", model: model, keySize: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyPrep(symbol: "4", model: model, keySize: keySize)
                KeyPrep(symbol: "5", model: model, keySize: keySize)
                KeyPrep(symbol: "6", model: model, keySize: keySize)
                KeyPrep(symbol: "-", model: model, keySize: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyPrep(symbol: "1", model: model, keySize: keySize)
                KeyPrep(symbol: "2", model: model, keySize: keySize)
                KeyPrep(symbol: "3", model: model, keySize: keySize)
                KeyPrep(symbol: "+", model: model, keySize: keySize)
            }
            HStack(spacing: spaceBetweenKeys) {
                KeyPrep(symbol: "0", model: model, keySize: doubleKeySize)
                KeyPrep(symbol: ",", model: model, keySize: keySize)
                KeyPrep(symbol: "=", model: model, keySize: keySize)
            }
        }
    }
}

struct NonScientificKeys_Previews: PreviewProvider {
    static var previews: some View {
        NonScientificKeys(model: Model(), spaceBetweenKeys: 10, size: CGSize(width: 250, height: 300))
    }
}

