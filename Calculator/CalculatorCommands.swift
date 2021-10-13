//
//  CalculatorCommands.swift
//  CalculatorCommands
//
//  Created by Joachim Neumann on 10/9/21.
//

import SwiftUI

struct CalculatorCommands: Commands {
    var brain: Brain
    let t: TE
    var body: some Commands {
        CommandMenu("Copy&Paste") {
            CopyCommand(brain: brain, t: t)
            PasteCommand(brain: brain)
        }
    }
}

struct CopyCommand: View {
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        Button {
            if brain.highPrecision {
//                UIPasteboard.general.string = brain.lString.combined
            } else {
                //UIPasteboard.general.string = brain.sString(t.digitsInSmallDisplay)
            }
        } label: {
            Label("Copy)", systemImage: "copy")
        }
        .keyboardShortcut("C", modifiers: [.command])
    }
}

struct PasteCommand: View {
    var brain: Brain
    var body: some View {
        Button {
            brain.fromPasteboard()
        } label: {
            Label("Paste", systemImage: "drop")
        }
        .keyboardShortcut("V", modifiers: [.command])
        .disabled(!UIPasteboard.general.hasStrings)
    }
}
