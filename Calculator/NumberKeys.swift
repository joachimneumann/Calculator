//
//  NumberKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI


struct NumberKeys: View {
    let brain = Brain()
    let size: CGSize
    let verticalSpace: CGFloat
    let horizontalSpace: CGFloat

    var body: some View {
        VStack(spacing: verticalSpace) {
            HStack(spacing: horizontalSpace) {
                Key("C")
                    .op_clear(size: size) {}
                Key("+/-")
                    .op_plusMinus_percentage(size: size) {}
                Key("%")
                    .op_plusMinus_percentage(size: size) {}
                Key("/")
                    .op_div_mul_add_sub_eq(size: size) {}
            }
            HStack(spacing: horizontalSpace) {
                Key("7")
                    .digit_1_to_9(size: size) { brain.digit("7")}
                Key("8")
                    .digit_1_to_9(size: size) {}
                Key("9")
                    .digit_1_to_9(size: size) {}
                Key("x")
                    .op_div_mul_add_sub_eq(size: size) {}
            }
            HStack(spacing: horizontalSpace) {
                Key("4")
                    .digit_1_to_9(size: size) {}
                Key("5")
                    .digit_1_to_9(size: size) {}
                Key("6")
                    .digit_1_to_9(size: size) {}
                Key("-")
                    .op_div_mul_add_sub_eq(size: size) {}
            }
            HStack(spacing: horizontalSpace) {
                Key("1")
                    .digit_1_to_9(size: size) {}
                Key("2")
                    .digit_1_to_9(size: size) {}
                Key("3")
                    .digit_1_to_9(size: size) {}
                Key("+")
                    .op_div_mul_add_sub_eq(size: size) {}
            }
            HStack(spacing: horizontalSpace) {
                Key("0")
                    .digit_0(size: size, horizontalSpace: horizontalSpace) {}
                Key(",")
                    .digit_1_to_9(size: size) {}
                Key("=")
                    .op_div_mul_add_sub_eq(size: size) {}
            }
        }
    }
    init(roundKeys: Bool, width totalWidth: CGFloat) {
        horizontalSpace = 0.03 * totalWidth
        verticalSpace = 0.03 * totalWidth
        let w = (totalWidth - 3.0 * horizontalSpace) * 0.25
        size = CGSize(width: w, height: w)
    }
}

struct NumberKeys_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
            NumberKeys(roundKeys: true, width: 320)
        }
            .background(Color.black)
    }
}
