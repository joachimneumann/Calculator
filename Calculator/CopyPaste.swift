//
//  CopyPaste.swift
//  Calculator
//
//  Created by Joachim Neumann on 30/09/2021.
//

import SwiftUI

struct Copy: View {
    let longString: String
    var animationCallback: () -> ()
    var body: some View {
        Text("Copy")
            .font(.system(size: 15).bold())
            .foregroundColor(TE.DigitKeyProperties.textColor)
            .onTapGesture {
                animationCallback()
                UIPasteboard.general.string = longString
            }
    }
}

struct Paste: View {
    var pasteAndAnimationCallback: (String) -> ()
    var body: some View {
        Text("Paste")
            .font(.system(size: 15).bold())
            .foregroundColor(TE.DigitKeyProperties.textColor)
            .onTapGesture {
                if let content = UIPasteboard.general.string {
                    pasteAndAnimationCallback(content)
                }
            }
    }
}
struct Copy_Previews: PreviewProvider {
    static var previews: some View {
        Copy(longString: "xx") {}
    }
}
