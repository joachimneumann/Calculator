//
//  NumberKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI


struct NumberKeys: View {
    @ObservedObject var brain: Brain
    let keySize: CGSize
    let slightlyLargerSize: CGSize
    let verticalSpace: CGFloat
    let horizontalSpace: CGFloat

    var body: some View {
        VStack(spacing: verticalSpace) {
            HStack(spacing: horizontalSpace) {
                Key("C")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.notCalculating,
                        isPending: false)
                { brain.reset() }
                Key("+/-")
                    .op_plusMinus_percentage(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed )
                { brain.operation("+/-") }
                Key("%")
                    .op_plusMinus_percentage(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed)
                { brain.operation("%")  }
                Key("/")
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: brain.isPending("/"))
                { brain.operation("/") }
            }
            HStack(spacing: horizontalSpace) {
                Key("7")
                    .digit_1_to_9(
                        size: keySize, isAllowed:
                            brain.digitsAllowed)
                { brain.digit(7) }
                Key("8")
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: brain.digitsAllowed)
                { brain.digit(8) }
                Key("9")
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: brain.digitsAllowed)
                { brain.digit(9) }
                Key("x")
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: brain.isPending("x"))
                { brain.operation("x") }
            }
            HStack(spacing: horizontalSpace) {
                Key("4")
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: brain.digitsAllowed)
                { brain.digit(4) }
                Key("5")
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: brain.digitsAllowed)
                { brain.digit(5) }
                Key("6")
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: brain.digitsAllowed)
                { brain.digit(6) }
                Key("-")
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: brain.isPending("-"))
                { brain.operation("-") }
            }
            HStack(spacing: horizontalSpace) {
                Key("1")
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: brain.digitsAllowed)
                { brain.digit(1) }
                Key("2")
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: brain.digitsAllowed)
                { brain.digit(2) }
                Key("3")
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: brain.digitsAllowed)
                { brain.digit(3) }
                Key("+")
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: brain.isPending("+"))
                { brain.operation("+") }
            }
            HStack(spacing: horizontalSpace) {
                Key("0")
                    .digit_0(
                        size: keySize,
                        space: horizontalSpace,
                        isAllowed: brain.digitsAllowed)
                { brain.zero() }
                Key(",")
                    .digit_1_to_9(
                        size: keySize,
                        isAllowed: brain.digitsAllowed)
                { brain.comma() }
                Key("=")
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("=") }
            }
        }
    }
    
    init(brain: Brain, appFrame: CGSize) {
        self.brain = brain
        horizontalSpace = Configuration.spaceBetweenkeys(appFrame: appFrame)
        verticalSpace   = Configuration.spaceBetweenkeys(appFrame: appFrame)
        keySize = Configuration.numberKeySize(appFrame: appFrame)
        slightlyLargerSize = Configuration.slightlyLargerNumberKeySize(appFrame: appFrame)
    }
}

struct NumberKeys_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
            NumberKeys(brain: Brain(), appFrame: CGSize(width: 200, height: 200))
        }
            .background(Color.black)
    }
}
