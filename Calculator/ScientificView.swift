//
//  ScientificView.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct ScientificView: View {
    let spaceBetweenKeys: CGFloat
    var body: some View {
        VStack(spacing: spaceBetweenKeys) {
            Text("S")
//            HStack(spacing: spaceBetweenKeys) {
//                let isEnabled = (!requiresValidNuber || brain.isValidNumber) && !brain.isCalculating && (symbol != "mr" || brain.memory != nil)
//                let isPending = brain.isPending(symbol)

//                KeyView("( ", callback: nil, enabled: true, pending: false, keyProperties: <#T##KeyProperties#>)
//                KeyView("( ", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.parenthesisProperties)
//                KeyView(" )", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.parenthesisProperties)
//                KeyView("mc", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView("m+", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView("m-", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView("mr", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.scientificProperties)
//            }
//            HStack(spacing: spaceBetweenKeys) {
//                KeyView("2nd", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView("x^2", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView("x^3", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView("x^y", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView(brain.secondKeys ? "y^x" : "e^x", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView(brain.secondKeys ? "2^x" : "10^x", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//            }
//            HStack(spacing: spaceBetweenKeys) {
//                KeyView("One_x", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView("√", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView("3√", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView("y√", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView(brain.secondKeys ? "logy" : "ln", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView(brain.secondKeys ? "log2" : "log10", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//            }
//            HStack(spacing: spaceBetweenKeys) {
//                KeyView("x!", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView(brain.rad ? (brain.secondKeys ? "asin" : "sin") : (brain.secondKeys ? "asinD" : "sinD"), requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView(brain.rad ? (brain.secondKeys ? "acos" : "cos") : (brain.secondKeys ? "acosD" : "cosD"), requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView(brain.rad ? (brain.secondKeys ? "atan" : "tan") : (brain.secondKeys ? "atanD" : "tanD"), requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView("e", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView("EE", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//            }
//            HStack(spacing: spaceBetweenKeys) {
//                KeyView(brain.rad ? "Deg" : "Rad", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView(brain.secondKeys ? "asinh" : "sinh", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView(brain.secondKeys ? "acosh" : "cosh", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView(brain.secondKeys ? "atanh" : "tanh", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView("π", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.scientificProperties)
//                KeyView("Rand", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.scientificProperties)
//            }
        }
    }
}

struct ScientificView_Previews: PreviewProvider {
    static var previews: some View {
        ScientificView(spaceBetweenKeys: 100)
    }
}
