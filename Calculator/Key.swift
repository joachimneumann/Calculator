//
//  Key.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/19/22.
//

import SwiftUI

func doNothing(s: String) {
        print("do something")
}
struct KeyView_Previews: PreviewProvider {
    static var previews: some View {
        Key("√", size: CGSize(width: 300, height: 100), keyColors: KeyColors(textColor: Color.white, upColor: Color.red, downColor: Color.orange), callback: doNothing)
    }
}

struct Key: View {
    let keyContent: any View
    let keyLabel: KeyLabel
    let size: CGSize
    var keyColors: KeyColors
    let symbol: String
    let callback: (String) -> ()

    init(_ symbol: String, size: CGSize, keyColors: KeyColors, callback: @escaping (String) -> ()) {
        self.keyColors = keyColors
        self.size = size
        self.keyLabel = KeyLabel(size: size, textColor: keyColors.textColor)
        keyContent = keyLabel.of(symbol)
        self.symbol = symbol
        self.callback = callback
    }

    func doSomething() {
        callback(symbol)
    }
    var body: some View {
        KeyBackground(callback: doSomething, keyColors: keyColors) {
            AnyView(keyContent)
                .foregroundColor(keyColors.textColor)
        }
        .frame(width: size.width, height: size.height)
    }
}

