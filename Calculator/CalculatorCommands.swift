//
//  CalculatorCommands.swift
//  CalculatorCommands
//
//  Created by Joachim Neumann on 10/9/21.
//

import SwiftUI

struct CalculatorCommands: Commands {
    @ObservedObject var brain: Brain
    let t: TE
    var body: some Commands {
        CommandMenu("Edit ") {
            /// the extra space after "Edit" prevents MacOS to add 'Start Dictation'
            /// and 'Special Characters' to the Edit menu
            CopyCommand(brain: brain, t: t)
            PasteCommand(brain: brain)
        }
        CommandMenu("Precision") {
            LowPrecision(brain: brain, t: t)
            HighPrecision(brain: brain, t: t)
        }
    }
}

struct LowPrecision: View {
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        Button {
            brain.precision = TE.lowPrecision
        } label: {
            Text((brain.precision == TE.lowPrecision ? "✓ " : "    ") + String(TE.lowPrecision))
        }
        .keyboardShortcut("1", modifiers: [.command])
    }
}

struct HighPrecision: View {
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        Button {
            brain.precision = TE.highPrecision
        } label: {
            Text((brain.precision == TE.lowPrecision ? "    " : "✓ ") + String(TE.highPrecision))
        }
        .keyboardShortcut("2", modifiers: [.command])
    }
}

struct CopyCommand: View {
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        Button {
            if brain.nonScientific != nil && (brain.displayAsString || brain.displayAsInteger || brain.displayAsFloat ) {
                UIPasteboard.general.string = brain.nonScientific!
            } else {
                UIPasteboard.general.string = brain.scientific?.combined
            }
        } label: {
            Text("Copy")
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
            Text("Paste")
        }
        .keyboardShortcut("V", modifiers: [.command])
        .disabled(!UIPasteboard.general.hasStrings)
    }
}
