//
//  CalculatorCommands.swift
//  CalculatorCommands
//
//  Created by Joachim Neumann on 10/9/21.
//

import SwiftUI

struct CalculatorCommands: Commands {
    var brain: Brain
//    @FocusedBinding(\.garden) private var garden: Garden?
//    @FocusedBinding(\.selection) private var selection: Set<Plant.ID>?

    var body: some Commands {
        CommandMenu("Copy&Paste") {
            CopyShortCommand(brain: brain)
            CopyLongCommand(brain: brain)
            PasteCommand(brain: brain)
        }
    }
}

struct CopyLongCommand: View {
    var brain: Brain
    var body: some View {
        Button {
            if brain.dd.hasMoreDigits {
                UIPasteboard.general.string = brain.combinedLongDisplayString(longDisplayString: brain.longDisplayString)
            } else {
                UIPasteboard.general.string = brain.dd.string
            }
        } label: {
            Label("Copy all digits", systemImage: "drop")
        }
        .keyboardShortcut("C", modifiers: [.command, .shift])
        //.disabled(!brain.dd.hasMoreDigits) ///needs binding
    }
}

struct CopyShortCommand: View {
    var brain: Brain
    var body: some View {
        Button {
            UIPasteboard.general.string = brain.dd.string
        } label: {
            Label("Copy", systemImage: "drop")
        }
        .keyboardShortcut("C", modifiers: [.command])
        //.disabled(brain.dd.hasMoreDigits)
    }
}

struct PasteCommand: View {
    var brain: Brain
    var body: some View {
        Button {
            brain.fromPasteboard("3.14")
        } label: {
            Label("Paste", systemImage: "drop")
        }
        .keyboardShortcut("V", modifiers: [.command])
        //.disabled(brain.dd.hasMoreDigits)
    }
}
