//
//  Key.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/19/22.
//

import SwiftUI

struct Key: View {
    private let symbol: String
    private let enabled: Bool
    private let size: CGSize
    private var keyColors: KeyColors
    private let callback: (String) -> ()

    private let keyLabel: KeyLabel
    private let keyContent: any View

    private let keyModel: KeyModel
    
    init(_ symbol: String, enabled: Bool, size: CGSize, keyColors: KeyColors, callback: @escaping (String) -> (), type: KeyType = .digit) {
        keyModel = KeyModel(type: type)
        self.keyColors = keyModel.colors
        self.size = size
        self.keyLabel = KeyLabel(size: size, textColor: Color(uiColor: keyColors.textColor))
        keyContent = keyLabel.of(symbol)
        self.symbol = symbol
        self.callback = callback
        self.enabled = enabled
    }

    func doSomething() {
        callback(symbol)
    }
    var body: some View {
        KeyBackground(enabled: enabled, callback: doSomething, keyColors: keyColors) {
            AnyView(keyContent)
                .foregroundColor(Color(uiColor: keyColors.textColor))
        }
        .frame(width: size.width, height: size.height)
    }
}


struct KeyView_Previews: PreviewProvider {
    static func doNothing(s: String) {
            print("do something")
    }
    static var previews: some View {
        VStack {
            Key("-", enabled: true, size: CGSize(width: 117, height: 112), keyColors: KeyColors(textColor: UIColor.white, upColor: UIColor.red, downColor: UIColor.orange), callback: KeyView_Previews.doNothing)
            Key("-", enabled: true, size: CGSize(width: 27, height: 27), keyColors: KeyColors(textColor: UIColor.white, upColor: UIColor.red, downColor: UIColor.orange), callback: KeyView_Previews.doNothing)
        }
    }
}
