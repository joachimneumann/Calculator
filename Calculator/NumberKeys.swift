//
//  NumberKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI


struct NumberKeys: View {
    @ObservedObject var brain: Brain
    let t: TE

    var body: some View {
        VStack(spacing: t.spaceBetweenkeys) {
            HStack(spacing: t.spaceBetweenkeys) {
                Key("C", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                Key("+/-", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                Key("%", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.scientificProperties)
                Key("/", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.colorOpProperties)
            }
            HStack(spacing: t.spaceBetweenkeys) {
                Key("7", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.digits_1_9)
                Key("8", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.digits_1_9)
                Key("9", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.digits_1_9)
                Key("x", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.colorOpProperties)
            }
            HStack(spacing: t.spaceBetweenkeys) {
                Key("4", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.digits_1_9)
                Key("5", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.digits_1_9)
                Key("6", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.digits_1_9)
                Key("-", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.colorOpProperties)
            }
            HStack(spacing: t.spaceBetweenkeys) {
                Key("1", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.digits_1_9)
                Key("2", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.digits_1_9)
                Key("3", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.digits_1_9)
                Key("+", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.colorOpProperties)
            }
            HStack(spacing: t.spaceBetweenkeys) {
                Key("0", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.digits_0)
                Key(",", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.digits_1_9)
                Key("=", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.colorOpProperties)
            }
        }
    }
}

