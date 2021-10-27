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
                Key("C", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: t.scientificKeyFontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation("C") }
                Key("+/-", keyProperties: TE.LightGrayKeyProperties)
                    .op_plusMinus_percentage(
                        size: keySize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber)
                { brain.asyncOperation("+/-") }
                Key("%", keyProperties: TE.LightGrayKeyProperties)
                    .op_plusMinus_percentage(
                        size: keySize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber)
                { brain.asyncOperation("%")  }
                Key("/", keyProperties: TE.OpKeyProperties)
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: brain.isPending("/"))
                { brain.asyncOperation("/") }
            }
            HStack(spacing: horizontalSpace) {
                Key("7", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber)
                { brain.press(7) }
                Key("8", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber)
                { brain.press(8) }
                Key("9", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber)
                { brain.press(9) }
                Key("x", keyProperties: TE.OpKeyProperties)
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: brain.isPending("x"))
                { brain.asyncOperation("x") }
            }
            HStack(spacing: horizontalSpace) {
                Key("4", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber)
                { brain.press(4) }
                Key("5", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber)
                { brain.press(5) }
                Key("6", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber)
                { brain.press(6) }
                Key("-", keyProperties: TE.OpKeyProperties)
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: brain.isPending("-"))
                { brain.asyncOperation("-") }
            }
            HStack(spacing: horizontalSpace) {
                Key("1", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber)
                { brain.press(1) }
                Key("2", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber)
                { brain.press(2) }
                Key("3", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber)
                { brain.press(3) }
                Key("+", keyProperties: TE.OpKeyProperties)
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: brain.isPending("+"))
                { brain.asyncOperation("+") }
            }
            HStack(spacing: horizontalSpace) {
                Key("0", keyProperties: TE.DigitKeyProperties)
                    .digit_0(
                        size: keySize,
                        space: horizontalSpace,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber)
                { brain.press(0) }
                Key(",", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber)
                { brain.asyncOperation(",") }
                Key("=", keyProperties: TE.OpKeyProperties)
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation("=") }
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

