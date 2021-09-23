//
//  ScientificKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

struct ScientificKeys: View {
    let model: BrainViewModel
    let size: CGSize
    let verticalSpace: CGFloat
    let horizontalSpace: CGFloat

    var body: some View {
        VStack(spacing: verticalSpace) {
            HStack(spacing: horizontalSpace) {
                Key("(")
                    .op_clear(size: size)
                Key(")")
                    .op_clear(size: size)
                Key("mc")
                    .op_clear(size: size)
                Key("m+")
                    .op_clear(size: size)
                Key("m-")
                    .op_clear(size: size)
                Key("mr")
                    .op_clear(size: size)
            }
            HStack(spacing: horizontalSpace) {
                Key("2nd")
                    .op_clear(size: size)
                Key("x^2")
                    .op_clear(size: size)
                Key("x^3")
                    .op_clear(size: size)
                Key("x^y")
                    .op_clear(size: size)
                Key("e^x")
                    .op_clear(size: size)
                Key("10^x")
                    .op_clear(size: size)
            }
            HStack(spacing: horizontalSpace) {
                Key("1/x")
                    .op_clear(size: size)
                Key("sr")
                    .op_clear(size: size)
                Key("tr")
                    .op_clear(size: size)
                Key("yr")
                    .op_clear(size: size)
                Key("ln")
                    .op_clear(size: size)
                Key("log10")
                    .op_clear(size: size)
            }
            HStack(spacing: horizontalSpace) {
                Key("x!")
                    .op_clear(size: size)
                Key("sin")
                    .op_clear(size: size)
                Key("cos")
                    .op_clear(size: size)
                Key("tan")
                    .op_clear(size: size)
                Key("e")
                    .op_clear(size: size)
                Key("EE")
                    .op_clear(size: size)
            }
            HStack(spacing: horizontalSpace) {
                Key("Rad")
                    .op_clear(size: size)
                Key("sinh")
                    .op_clear(size: size)
                Key("cosh")
                    .op_clear(size: size)
                Key("tanh")
                    .op_clear(size: size)
                Key("pi")
                    .op_clear(size: size)
                Key("Rand")
                    .op_clear(size: size)
            }
        }
    }

    init(model: BrainViewModel, keyWidth: CGFloat, keyHeight: CGFloat) {
        self.model = model
        horizontalSpace = Configuration.shared.horizontalSpace(forTotalWidth: keyWidth)
        verticalSpace   = Configuration.shared.verticalSpace(forTotalWidth: keyHeight)
        size = CGSize(width: keyWidth, height: keyHeight)
    }
}

struct ScientificKeys_Previews: PreviewProvider {
    static var previews: some View {
        ScientificKeys(model: BrainViewModel(), keyWidth: 50, keyHeight: 30)
    }
}
