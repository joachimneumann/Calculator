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
                        isAllowed: !brain.calculating && !brain.calculating,
                        isPending: false)
                { brain.reset() }
                Key("+/-", keyProperties: TE.LightGrayKeyProperties)
                    .op_plusMinus_percentage(
                        size: keySize,
                        isAllowed: brain.isValidNumber && !brain.calculating)
                { brain.operation("+/-") }
                Key("%", keyProperties: TE.LightGrayKeyProperties)
                    .op_plusMinus_percentage(
                        size: keySize,
                        isAllowed: brain.isValidNumber && !brain.calculating)
                { brain.operation("%")  }
                Key("/", keyProperties: TE.OpKeyProperties)
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        isAllowed: brain.isValidNumber && !brain.calculating,
                        isPending: brain.isPending("/"))
                { brain.operation("/") }
            }
            HStack(spacing: horizontalSpace) {
                Key("7", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: !brain.calculating)
                { brain.digit(7) }
                Key("8", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: !brain.calculating)
                { brain.digit(8) }
                Key("9", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: !brain.calculating)
                { brain.digit(9) }
                Key("x", keyProperties: TE.OpKeyProperties)
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        isAllowed: brain.isValidNumber && !brain.calculating,
                        isPending: brain.isPending("x"))
                { brain.operation("x") }
            }
            HStack(spacing: horizontalSpace) {
                Key("4", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: !brain.calculating)
                { brain.digit(4) }
                Key("5", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: !brain.calculating)
                { brain.digit(5) }
                Key("6", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: !brain.calculating)
                { brain.digit(6) }
                Key("-", keyProperties: TE.OpKeyProperties)
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        isAllowed: brain.isValidNumber && !brain.calculating,
                        isPending: brain.isPending("-"))
                { brain.operation("-") }
            }
            HStack(spacing: horizontalSpace) {
                Key("1", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: !brain.calculating)
                { brain.digit(1) }
                Key("2", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: !brain.calculating)
                { brain.digit(2) }
                Key("3", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: !brain.calculating)
                { brain.digit(3) }
                Key("+", keyProperties: TE.OpKeyProperties)
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        isAllowed: brain.isValidNumber && !brain.calculating,
                        isPending: brain.isPending("+"))
                { brain.operation("+") }
            }
            HStack(spacing: horizontalSpace) {
                Key("0", keyProperties: TE.DigitKeyProperties)
                    .digit_0(
                        size: keySize,
                        space: horizontalSpace,
                        isAllowed: !brain.calculating)
                { brain.zero() }
                Key(",", keyProperties: TE.DigitKeyProperties)
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: !brain.calculating)
                { brain.comma() }
                Key("=", keyProperties: TE.OpKeyProperties)
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        isAllowed: brain.isValidNumber && !brain.calculating,
                        isPending: false)
                { brain.operation("=") }
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

