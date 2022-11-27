//
//  Key.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/19/22.
//

import SwiftUI

struct OldKey: View {
    private let symbol: String
    private let size: CGSize
    private var keyColors: KeyColors
    private let callback: (String) -> ()

    private let keyContent: any View

    init(_ symbol: String, size: CGSize, keyColors: KeyColors, callback: @escaping (String) -> ()) {
        self.keyColors = keyColors
        self.size = size
        let keyLabel = KeyLabel(size: size, textColor: Color(uiColor: keyColors.textColor))
        keyContent = keyLabel.of(symbol)
        self.symbol = symbol
        self.callback = callback
    }

    func doSomething() {
        callback(symbol)
    }
    
    var body: some View {
        let _ = print("Key \(symbol)")
        KeyBackground(callback: doSomething, keyColors: keyColors) {
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
            OldKey("-", size: CGSize(width: 117, height: 112), keyColors: KeyColors(textColor: UIColor.white, upColor: UIColor.red, downColor: UIColor.orange), callback: KeyView_Previews.doNothing)
            OldKey("-", size: CGSize(width: 27, height: 27), keyColors: KeyColors(textColor: UIColor.white, upColor: UIColor.red, downColor: UIColor.orange), callback: KeyView_Previews.doNothing)
        }
    }
}
