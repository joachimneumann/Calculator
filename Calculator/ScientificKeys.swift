//
//  ScientificKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

struct ScientificKeys: View {
    @ObservedObject var brain: Brain
    let keySize: CGSize
    let fontSize: CGFloat
    let vSpacing: CGFloat
    let hSpacing: CGFloat
    
    var body: some View {
        VStack(spacing: vSpacing) {
            HStack(spacing: hSpacing) {
                Key("(", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key(")", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key("mc", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key("m+", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key("m-", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key("mr", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
            }
            HStack(spacing: hSpacing) {
                Key("2nd", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key("x^2", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key("x^3", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key("x^y", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key(brain.secondKeys ? "y^x" : "e^x", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key(brain.secondKeys ? "2^x" : "10^x", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
            }
            HStack(spacing: hSpacing) {
                Key("One_x", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key("√", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key("3√", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key("y√", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key(brain.secondKeys ? "logy" : "ln", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key(brain.secondKeys ? "log2" : "log10", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
            }
            HStack(spacing: hSpacing) {
                Key("x!", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key(brain.rad ? (brain.secondKeys ? "asin" : "sin") : (brain.secondKeys ? "asinD" : "sinD"), requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key(brain.rad ? (brain.secondKeys ? "acos" : "cos") : (brain.secondKeys ? "acosD" : "cosD"), requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key(brain.rad ? (brain.secondKeys ? "atan" : "tan") : (brain.secondKeys ? "atanD" : "tanD"), requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key("e", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key("EE", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
            }
            HStack(spacing: hSpacing) {
                Key(brain.rad ? "Deg" : "Rad", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key(brain.secondKeys ? "asinh" : "sinh", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key(brain.secondKeys ? "acosh" : "cosh", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key(brain.secondKeys ? "atanh" : "tanh", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key("π", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key("Rand", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
            }
        }
    }
    
    init(brain: Brain, t: TE) {
        self.brain = brain
        hSpacing = t.spaceBetweenkeys
        vSpacing = t.spaceBetweenkeys
        keySize  = t.keySize
        fontSize = t.scientificKeyFontSize
    }
}
