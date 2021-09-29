//
//  NumberKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI


struct NumberKeys: View {
    @ObservedObject var model: BrainViewModel
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
                        isAllowed: true,
                        isPending: false)
                { model.operation("C") }
                Key("+/-")
                    .op_plusMinus_percentage(
                        size: size,
                        isAllowed: model.inPlaceAllowed )
                { model.operation("+/-") }
                Key("%")
                    .op_plusMinus_percentage(
                        size: size,
                        isAllowed: model.inPlaceAllowed)
                { model.operation("%")  }
                Key("/")
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        isAllowed: model.inPlaceAllowed,
                        isPending: model.isPending("/"))
                { model.operation("/") }
            }
            HStack(spacing: horizontalSpace) {
                Key("7")
                    .digit_1_to_9(
                        size: size, isAllowed:
                            model.digitsAllowed)
                { model.digit(7) }
                Key("8")
                    .digit_1_to_9(
                        size: size,
                        isAllowed: model.digitsAllowed)
                { model.digit(8) }
                Key("9")
                    .digit_1_to_9(
                        size: size,
                        isAllowed: model.digitsAllowed)
                { model.digit(9) }
                Key("x")
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        isAllowed: model.inPlaceAllowed,
                        isPending: model.isPending("x"))
                { model.operation("x") }
            }
            HStack(spacing: horizontalSpace) {
                Key("4")
                    .digit_1_to_9(
                        size: size,
                        isAllowed: model.digitsAllowed)
                { model.digit(4) }
                Key("5")
                    .digit_1_to_9(
                        size: size,
                        isAllowed: model.digitsAllowed)
                { model.digit(5) }
                Key("6")
                    .digit_1_to_9(
                        size: size,
                        isAllowed: model.digitsAllowed)
                { model.digit(6) }
                Key("-")
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        isAllowed: model.inPlaceAllowed,
                        isPending: model.isPending("-"))
                { model.operation("-") }
            }
            HStack(spacing: horizontalSpace) {
                Key("1")
                    .digit_1_to_9(
                        size: size,
                        isAllowed: model.digitsAllowed)
                { model.digit(1) }
                Key("2")
                    .digit_1_to_9(
                        size: size,
                        isAllowed: model.digitsAllowed)
                { model.digit(2) }
                Key("3")
                    .digit_1_to_9(
                        size: size,
                        isAllowed: model.digitsAllowed)
                { model.digit(3) }
                Key("+")
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        isAllowed: model.inPlaceAllowed,
                        isPending: model.isPending("+"))
                { model.operation("+") }
            }
            HStack(spacing: horizontalSpace) {
                Key("0")
                    .digit_0(
                        size: size,
                        space: horizontalSpace,
                        isAllowed: model.digitsAllowed)
                { model.zero() }
                Key(",")
                    .digit_1_to_9(
                        size: size,
                        isAllowed: model.digitsAllowed)
                { model.comma() }
                Key("=")
                    .op_div_mul_add_sub_eq(
                        size: slightlyLargerSize,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                { model.operation("=") }
            }
        }
    }
    
    init(model: BrainViewModel, roundKeys: Bool, width totalWidth: CGFloat) {
        self.model = model
        horizontalSpace = Configuration.shared.horizontalSpace(forTotalWidth: totalWidth)
        verticalSpace   = Configuration.shared.verticalSpace(forTotalWidth: totalWidth)
        let w = (totalWidth - 3.0 * horizontalSpace) * 0.25
        size = CGSize(width: w, height: w)
        slightlyLargerSize = CGSize(width: w, height: w)
    }

    init(model: BrainViewModel, keyWidth: CGFloat, keyHeight: CGFloat) {
        self.model = model
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
            NumberKeys(model: BrainViewModel(), roundKeys: true, width: 320)
        }
            .background(Color.black)
    }
}
