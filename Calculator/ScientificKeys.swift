//
//  ScientificKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

struct ScientificKeys: View {
    @ObservedObject var model: BrainViewModel
    let size: CGSize
    let verticalSpace: CGFloat
    let horizontalSpace: CGFloat

    var body: some View {
        VStack(spacing: verticalSpace) {
            HStack(spacing: horizontalSpace) {
                Key("(")
                    .scientific(size: size) // missing
                Key(")")
                    .scientific(size: size) // missing
                Key("mc")
                    .scientific(size: size) // missing
                Key("m+")
                    .scientific(size: size) // missing
                Key("m-")
                    .scientific(size: size) // missing
                Key("mr")
                    .scientific(size: size) // missing
            }
            HStack(spacing: horizontalSpace) {
                Key("2nd")
                    .scientific(size: size) { model.secondKeys.toggle() }
                Key("x^2")
                    .scientific(size: size) { model.operation("x^2") }
                Key("x^3")
                    .scientific(size: size) { model.operation("x^3") }
                Key("pow_x_y")
                    .scientific(size: size) { model.operation("pow_x_y") }
                Key("e^x")
                    .scientific(size: size) { model.operation("e^x") }
                Key("10^x")
                    .scientific(size: size) { model.operation("10^x") }
            }
            HStack(spacing: horizontalSpace) {
                Key("oneOverX")
                    .scientific(size: size) { model.operation("oneOverX") }
                Key("√")
                    .scientific(size: size) { model.operation("√") }
                Key("3√")
                    .scientific(size: size) { model.operation("3√") }
                Key("y√")
                    .scientific(size: size) { model.operation("y√") }
                Key("ln")
                    .scientific(size: size) { model.operation("ln") }
                Key("log10")
                    .scientific(size: size) { model.operation("log10") }
            }
            HStack(spacing: horizontalSpace) {
                Key("x!")
                    .scientific(size: size) { model.operation("x!") }
                Key(model.secondKeys ? "asin" : "sin")
                    .scientific(size: size) { model.operation(model.secondKeys ? "asin" : "sin") }
                Key(model.secondKeys ? "acos" : "cos")
                    .scientific(size: size) { model.operation(model.secondKeys ? "acos" : "cos") }
                Key(model.secondKeys ? "atan" : "tan")
                    .scientific(size: size) { model.operation(model.secondKeys ? "atan" : "tan") }
                Key("e")
                    .scientific(size: size) { model.operation("e") }
                Key("EE")
                    .scientific(size: size) {
                        model.operation("x")
                        model.secretDigit("1")
                        model.secretDigit("0")
                        model.secretOperation("pow_x_y")
                    }
            }
            HStack(spacing: horizontalSpace) {
                Key("Rad")
                    .scientific(size: size) // missing
                Key(model.secondKeys ? "asinh" : "sinh")
                    .scientific(size: size) { model.operation(model.secondKeys ? "asinh" : "sinh") }
                Key(model.secondKeys ? "acosh" : "cosh")
                    .scientific(size: size) { model.operation(model.secondKeys ? "acosh" : "cosh") }
                Key(model.secondKeys ? "atanh" : "tanh")
                    .scientific(size: size) { model.operation(model.secondKeys ? "atanh" : "tanh") }
                Key("π")
                    .scientific(size: size) { model.operation("π") }
                Key("Rand")
                    .scientific(size: size) { model.operation("rand") }
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
