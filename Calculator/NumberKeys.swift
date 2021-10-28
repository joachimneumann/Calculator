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
    let keySize: CGSize
    let slightlyLargerSize: CGSize
    let verticalSpace: CGFloat
    let horizontalSpace: CGFloat

    var body: some View {
        VStack(spacing: verticalSpace) {
            HStack(spacing: horizontalSpace) {
                Key("C", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key("+/-", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key("%", requiresValidNuber: true, brain: brain, keyProperties: TE.ScientificKeyProperties)
                Key("/", requiresValidNuber: true, brain: brain, keyProperties: TE.OpKeyProperties)
            }
            HStack(spacing: horizontalSpace) {
                Key("7", requiresValidNuber: true, brain: brain, keyProperties: TE.DigitKeyProperties)
                Key("8", requiresValidNuber: true, brain: brain, keyProperties: TE.DigitKeyProperties)
                Key("9", requiresValidNuber: true, brain: brain, keyProperties: TE.DigitKeyProperties)
                Key("x", requiresValidNuber: true, brain: brain, keyProperties: TE.OpKeyProperties)
            }
            HStack(spacing: horizontalSpace) {
                Key("4", requiresValidNuber: true, brain: brain, keyProperties: TE.DigitKeyProperties)
                Key("5", requiresValidNuber: true, brain: brain, keyProperties: TE.DigitKeyProperties)
                Key("6", requiresValidNuber: true, brain: brain, keyProperties: TE.DigitKeyProperties)
                Key("-", requiresValidNuber: true, brain: brain, keyProperties: TE.OpKeyProperties)
            }
            HStack(spacing: horizontalSpace) {
                Key("1", requiresValidNuber: true, brain: brain, keyProperties: TE.DigitKeyProperties)
                Key("2", requiresValidNuber: true, brain: brain, keyProperties: TE.DigitKeyProperties)
                Key("3", requiresValidNuber: true, brain: brain, keyProperties: TE.DigitKeyProperties)
                Key("+", requiresValidNuber: true, brain: brain, keyProperties: TE.OpKeyProperties)
            }
            HStack(spacing: horizontalSpace) {
                Key("0", requiresValidNuber: true, brain: brain, keyProperties: TE.DigitKeyProperties)
                Key(",", requiresValidNuber: true, brain: brain, keyProperties: TE.DigitKeyProperties)
                Key("=", requiresValidNuber: true, brain: brain, keyProperties: TE.OpKeyProperties)
            }
        }
    }
    
    init(brain: Brain, t: TE) {
        self.brain = brain
        self.t = t
        horizontalSpace = t.spaceBetweenkeys
        verticalSpace   = t.spaceBetweenkeys
        keySize = t.keySize
        slightlyLargerSize = t.widerKeySize
    }
}

