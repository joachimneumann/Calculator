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
                    .scientific(size: size)
                Key(")")
                    .scientific(size: size)
                Key("mc")
                    .scientific(size: size)
                Key("m+")
                    .scientific(size: size)
                Key("m-")
                    .scientific(size: size)
                Key("mr")
                    .scientific(size: size)
            }
            HStack(spacing: horizontalSpace) {
                Key("2nd")
                    .scientific(size: size)
                Key("x^2")
                    .scientific(size: size)
                Key("x^3")
                    .scientific(size: size)
                Key("x^y")
                    .scientific(size: size)
                Key("e^x")
                    .scientific(size: size)
                Key("10^x")
                    .scientific(size: size)
            }
            HStack(spacing: horizontalSpace) {
                Key("1/x")
                    .scientific(size: size)
                Key("sr")
                    .scientific(size: size)
                Key("tr")
                    .scientific(size: size)
                Key("yr")
                    .scientific(size: size)
                Key("ln")
                    .scientific(size: size)
                Key("log10")
                    .scientific(size: size)
            }
            HStack(spacing: horizontalSpace) {
                Key("x!")
                    .scientific(size: size)
                Key("sin")
                    .scientific(size: size)
                Key("cos")
                    .scientific(size: size)
                Key("tan")
                    .scientific(size: size)
                Key("e")
                    .scientific(size: size)
                Key("EE")
                    .scientific(size: size)
            }
            HStack(spacing: horizontalSpace) {
                Key("Rad")
                    .scientific(size: size)
                Key("sinh")
                    .scientific(size: size)
                Key("cosh")
                    .scientific(size: size)
                Key("tanh")
                    .scientific(size: size)
                Key("pi")
                    .scientific(size: size)
                Key("Rand")
                    .scientific(size: size)
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
