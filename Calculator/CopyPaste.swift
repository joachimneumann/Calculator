//
//  CopyPaste.swift
//  Calculator
//
//  Created by Joachim Neumann on 30/09/2021.
//

import SwiftUI

struct Copy: View {
    let longString: String
    let fontSize: CGFloat
    let copyCallback: () -> ()
    @Binding var copyPasteHighlight: Bool
    var body: some View {
            Button("Copy") {
                withAnimation() {
                    copyPasteHighlight = true
                }
                let now = DispatchTime.now()
                var whenWhen: DispatchTime
                whenWhen = now + DispatchTimeInterval.milliseconds(200)
                DispatchQueue.main.asyncAfter(deadline: whenWhen) {
                    withAnimation() {
                        copyPasteHighlight = false
                    }
                }
                // A popup message seem to appear in the simulaor only
                copyCallback()
            }
            .font(Font.system(size: fontSize))
            .foregroundColor(TE.DigitKeyProperties.textColor)
    }
}

struct Paste: View {
    let fontSize: CGFloat
    @Binding var copyPasteHighlight: Bool
    let pasteCallback: (_ s: String) -> ()
    var body: some View {
        Button("Paste") {
            if let content = UIPasteboard.general.string {
                copyPasteHighlight = true
                let now = DispatchTime.now()
                var whenWhen: DispatchTime
                whenWhen = now + DispatchTimeInterval.milliseconds(300)
                DispatchQueue.main.asyncAfter(deadline: whenWhen) {
                    copyPasteHighlight = false
                }
                pasteCallback(content)
            }
        }
            .font(Font.system(size: fontSize))
            .foregroundColor(TE.DigitKeyProperties.textColor)
    }
}

