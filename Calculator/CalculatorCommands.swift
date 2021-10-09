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
        let digits = brain.dd.hasMoreDigits ? brain.combinedLongDisplayString(longDisplayString: brain.longDisplayString).count : brain.dd.string.count
        let digitsString = brain.dd.isValidNumber ? "" : ((digits == 1) ? "\(digits) digit" : "\(digits) characters")
        Button {
            if brain.dd.hasMoreDigits {
                UIPasteboard.general.string = brain.combinedLongDisplayString(longDisplayString: brain.longDisplayString)
            } else {
                UIPasteboard.general.string = brain.dd.string
            }
        } label: {
            Label("Copy (\(digitsString))", systemImage: "copy")
        }
        .keyboardShortcut("C", modifiers: [.command])
        .disabled(!brain.dd.isValidNumber)
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
