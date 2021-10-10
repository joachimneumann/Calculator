//
//  CalculatorCommands.swift
//  CalculatorCommands
//
//  Created by Joachim Neumann on 10/9/21.
//

import SwiftUI

struct CalculatorCommands: Commands {
    var brain: Brain
    var body: some Commands {
        CommandMenu("Copy&Paste") {
            CopyCommand(brain: brain)
            PasteCommand(brain: brain)
        }
    }
}

struct CopyCommand: View {
    @ObservedObject var brain: Brain
    var body: some View {
        Button {
            if brain.hasMoreDigits {
                UIPasteboard.general.string = brain.lString
            } else {
                UIPasteboard.general.string = brain.sString
            }
        } label: {
            Label("Copy)", systemImage: "copy")
        }
        .keyboardShortcut("C", modifiers: [.command])
        .disabled(!brain.isValidNumber)
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
        .disabled(!UIPasteboard.general.hasStrings)
    }
}
