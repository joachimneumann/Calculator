//
//  NumberKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI


struct NumberKeys: View {
    @ObservedObject var brain: Brain
    let size: CGSize
    let slightlyLargerSize: CGSize
    let verticalSpace: CGFloat
    let horizontalSpace: CGFloat

    var body: some View {
        VStack(spacing: verticalSpace) {
            HStack(spacing: horizontalSpace) {
                Key("C")
                    .scientific(
                        size: size,
                        isAllowed: brain.notCalculating,
                        isPending: false)
                { brain.reset() }
                Key("+/-")
                    .op_plusMinus_percentage(
                        size: size,
                        isAllowed: brain.inPlaceAllowed )
                { brain.operation("+/-") }
                Key("%")
                    .op_plusMinus_percentage(
                        size: size,
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
                        size: size, isAllowed:
                            brain.digitsAllowed)
                { brain.digit(7) }
                Key("8")
                    .digit_1_to_9(
                        size: size,
                        isAllowed: brain.digitsAllowed)
                { brain.digit(8) }
                Key("9")
                    .digit_1_to_9(
                        size: size,
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
                        size: size,
                        isAllowed: brain.digitsAllowed)
                { brain.digit(4) }
                Key("5")
                    .digit_1_to_9(
                        size: size,
                        isAllowed: brain.digitsAllowed)
                { brain.digit(5) }
                Key("6")
                    .digit_1_to_9(
                        size: size,
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
                        size: size,
                        isAllowed: brain.digitsAllowed)
                { brain.digit(1) }
                Key("2")
                    .digit_1_to_9(
                        size: size,
                        isAllowed: brain.digitsAllowed)
                { brain.digit(2) }
                Key("3")
                    .digit_1_to_9(
                        size: size,
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
                        size: size,
                        space: horizontalSpace,
                        isAllowed: brain.digitsAllowed)
                { brain.zero() }
                Key(",")
                    .digit_1_to_9(
                        size: size,
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
    
    init(brain: Brain, roundKeys: Bool, width totalWidth: CGFloat) {
        self.brain = brain
        horizontalSpace = Configuration.shared.horizontalSpace(forTotalWidth: totalWidth)
        verticalSpace   = Configuration.shared.verticalSpace(forTotalWidth: totalWidth)
        let w = (totalWidth - 3.0 * horizontalSpace) * 0.25
        size = CGSize(width: w, height: w)
        slightlyLargerSize = CGSize(width: w, height: w)
    }

    init(brain: Brain, keyWidth: CGFloat, keyHeight: CGFloat) {
        self.brain = brain
        horizontalSpace = Configuration.shared.horizontalSpace(forTotalWidth: keyWidth)
        verticalSpace   = Configuration.shared.verticalSpace(forTotalWidth: keyHeight)
        size = CGSize(width: keyWidth, height: keyHeight)
        slightlyLargerSize = CGSize(width: keyWidth+2, height: keyHeight)
    }
}

struct NumberKeys_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
            NumberKeys(brain: Brain(), roundKeys: true, width: 320)
        }
            .background(Color.black)
    }
}
