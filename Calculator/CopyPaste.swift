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
    @Binding var copyPasteHighlight: Bool
    var body: some View {
        Text("Copy")
            .font(Font.system(size: fontSize))
            .foregroundColor(TE.DigitKeyProperties.textColor)
            .onTapGesture {
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
                UIPasteboard.general.string = longString
            }
    }
}

struct Paste: View {
    let fontSize: CGFloat
    @Binding var copyPasteHighlight: Bool
    let brain: Brain
    var body: some View {
        Text("Paste")
            .font(Font.system(size: fontSize))
            .foregroundColor(TE.DigitKeyProperties.textColor)
            .onTapGesture {
                if let content = UIPasteboard.general.string {
                    copyPasteHighlight = true
                    let now = DispatchTime.now()
                    var whenWhen: DispatchTime
                    whenWhen = now + DispatchTimeInterval.milliseconds(300)
                    DispatchQueue.main.asyncAfter(deadline: whenWhen) {
                        copyPasteHighlight = false
                    }
                    brain.fromPasteboard(content)
                }
            }
    }
}

