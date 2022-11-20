//
//  ScientificKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

struct ScientificKeys: View {
    @ObservedObject var brain: Brain
    let t: TE
    
    var body: some View {
        VStack(spacing: t.spaceBetweenKeys) {
            HStack(spacing: t.spaceBetweenKeys) {
                OldKey("( ", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.parenthesisProperties)
                OldKey(" )", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.parenthesisProperties)
                OldKey("mc", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey("m+", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey("m-", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey("mr", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.scientificProperties)
            }
            HStack(spacing: t.spaceBetweenKeys) {
                OldKey("2nd", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey("x^2", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey("x^3", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey("x^y", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey(brain.secondKeys ? "y^x" : "e^x", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey(brain.secondKeys ? "2^x" : "10^x", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
            }
            HStack(spacing: t.spaceBetweenKeys) {
                OldKey("One_x", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey("√", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey("3√", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey("y√", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey(brain.secondKeys ? "logy" : "ln", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey(brain.secondKeys ? "log2" : "log10", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
            }
            HStack(spacing: t.spaceBetweenKeys) {
                OldKey("x!", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey(brain.rad ? (brain.secondKeys ? "asin" : "sin") : (brain.secondKeys ? "asinD" : "sinD"), requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey(brain.rad ? (brain.secondKeys ? "acos" : "cos") : (brain.secondKeys ? "acosD" : "cosD"), requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey(brain.rad ? (brain.secondKeys ? "atan" : "tan") : (brain.secondKeys ? "atanD" : "tanD"), requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey("e", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey("EE", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
            }
            HStack(spacing: t.spaceBetweenKeys) {
                OldKey(brain.rad ? "Deg" : "Rad", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey(brain.secondKeys ? "asinh" : "sinh", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey(brain.secondKeys ? "acosh" : "cosh", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey(brain.secondKeys ? "atanh" : "tanh", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey("π", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.scientificProperties)
                OldKey("Rand", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.scientificProperties)
            }
        }
    }
}
