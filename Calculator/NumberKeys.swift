//
//  NumberKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI


struct NumberKeys: View {
    let model: BrainViewModel
    let size: CGSize
    let slightlyLargerSize: CGSize
    let verticalSpace: CGFloat
    let horizontalSpace: CGFloat

    var body: some View {
        VStack(spacing: verticalSpace) {
            HStack(spacing: horizontalSpace) {
                Key("C")
                    .scientific(size: size, isValidKey: true)                          { model.operation("C") }
                Key("+/-")
                    .op_plusMinus_percentage(size: size)             { model.operation("+/-")  }
                Key("%")
                    .op_plusMinus_percentage(size: size)             { model.operation("%")  }
                Key("/")
                    .op_div_mul_add_sub_eq(size: slightlyLargerSize, isValidKey: model.digitsValid) { model.operation("/") }
            }
            HStack(spacing: horizontalSpace) {
                Key("7")
                    .digit_1_to_9(size: size, isValidKey: model.digitsValid)                        { model.digit("7") }
                Key("8")
                    .digit_1_to_9(size: size, isValidKey: model.digitsValid)                        { model.digit("8") }
                Key("9")
                    .digit_1_to_9(size: size, isValidKey: model.digitsValid)                        { model.digit("9") }
                Key("x")
                    .op_div_mul_add_sub_eq(size: slightlyLargerSize, isValidKey: model.digitsValid) { model.operation("x") }
            }
            HStack(spacing: horizontalSpace) {
                Key("4")
                    .digit_1_to_9(size: size, isValidKey: model.digitsValid)                        { model.digit("4") }
                Key("5")
                    .digit_1_to_9(size: size, isValidKey: model.digitsValid)                        { model.digit("5") }
                Key("6")
                    .digit_1_to_9(size: size, isValidKey: model.digitsValid)                        { model.digit("6") }
                Key("-")
                    .op_div_mul_add_sub_eq(size: slightlyLargerSize, isValidKey: model.digitsValid) { model.operation("-") }
            }
            HStack(spacing: horizontalSpace) {
                Key("1")
                    .digit_1_to_9(size: size, isValidKey: model.digitsValid)                        { model.digit("1") }
                Key("2")
                    .digit_1_to_9(size: size, isValidKey: model.digitsValid)                        { model.digit("2") }
                Key("3")
                    .digit_1_to_9(size: size, isValidKey: model.digitsValid)                        { model.digit("3") }
                Key("+")
                    .op_div_mul_add_sub_eq(size: slightlyLargerSize, isValidKey: model.digitsValid) { model.operation("+") }
            }
            HStack(spacing: horizontalSpace) {
                Key("0")
                    .digit_0(size: size, space: horizontalSpace, isValidKey: model.digitsValid)     { model.zero() }
                Key(",")
                    .digit_1_to_9(size: size, isValidKey: model.digitsValid)                        { model.comma() }
                Key("=")
                    .op_div_mul_add_sub_eq(size: slightlyLargerSize, isValidKey: model.digitsValid) { model.operation("=") }
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
