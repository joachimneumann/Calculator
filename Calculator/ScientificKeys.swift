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
                    .scientific(size: size, isValidKey: model.digitsValid) { model.operation("(") }
                Key(")")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.operation(")") }
                Key("mc")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.clearmemory() }
                Key("m+")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.addToMemory() }
                Key("m-")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.subtractFromMemory() }
                Key("mr")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.memory() }
            }
            HStack(spacing: horizontalSpace) {
                Key("2nd")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.secondKeys.toggle() }
                Key("x^2")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.operation("x^2") }
                Key("x^3")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.operation("x^3") }
                Key("x^y")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.operation("x^y") }
                Key(model.secondKeys ? "y^x" : "e^x")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.operation(model.secondKeys ? "y^x" : "e^x") }
                Key(model.secondKeys ? "2^x" : "10^x")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.operation(model.secondKeys ? "2^x" : "10^x") }
            }
            HStack(spacing: horizontalSpace) {
                Key("oneOverX")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.operation("oneOverX") }
                Key("√")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.operation("√") }
                Key("3√")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.operation("3√") }
                Key("y√")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.operation("y√") }
                Key(model.secondKeys ? "logy" : "ln")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.operation(model.secondKeys ? "logy" : "ln") }
                Key(model.secondKeys ? "log2" : "log10")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.operation(model.secondKeys ? "log2" : "log10") }
            }
            HStack(spacing: horizontalSpace) {
                Key("x!")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.operation("x!") }
                Key(model.secondKeys ? "asin" : "sin")
                    .scientific(size: size, isValidKey: model.digitsValid) {
                        if model.rad {
                            model.operation(model.secondKeys ? "asin" : "sin")
                        } else {
                            model.operation(model.secondKeys ? "asinD" : "sinD")
                        }
                    }
                Key(model.secondKeys ? "acos" : "cos")
                    .scientific(size: size, isValidKey: model.digitsValid) {
                        if model.rad {
                            model.operation(model.secondKeys ? "acos" : "cos")
                        } else {
                            model.operation(model.secondKeys ? "acosD" : "cosD")
                        }
                    }
                Key(model.secondKeys ? "atan" : "tan")
                    .scientific(size: size, isValidKey: model.digitsValid) {
                        if model.rad {
                            model.operation(model.secondKeys ? "atan" : "tan")
                        } else {
                            model.operation(model.secondKeys ? "atanD" : "tanD")
                        }
                    }
                Key("e")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.operation("e") }
                Key("EE")
                    .scientific(size: size, isValidKey: model.digitsValid) {
                        model.operation("x")
                        model.secretDigit("1")
                        model.secretDigit("0")
                        model.secretOperation("x^y")
                    }
            }
            HStack(spacing: horizontalSpace) {
                Key(model.rad ? "Deg" : "Rad")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.rad.toggle() }
                Key(model.secondKeys ? "asinh" : "sinh")
                    .scientific(size: size, isValidKey: model.digitsValid) {
                        if model.rad {
                            model.operation(model.secondKeys ? "asinh" : "sinh")
                        } else {
                            model.operation(model.secondKeys ? "asinhD" : "sinhD")
                        }
                    }
                Key(model.secondKeys ? "acosh" : "cosh")
                    .scientific(size: size, isValidKey: model.digitsValid) {
                        if model.rad {
                            model.operation(model.secondKeys ? "acosh" : "cosh")
                        } else {
                            model.operation(model.secondKeys ? "acoshD" : "coshD")
                        }
                    }
                Key(model.secondKeys ? "atanh" : "tanh")
                    .scientific(size: size, isValidKey: model.digitsValid) {
                        if model.rad {
                            model.operation(model.secondKeys ? "atanh" : "tanh")
                        } else {
                            model.operation(model.secondKeys ? "atanhD" : "tanhD")
                        }
                    }
                Key("π")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.operation("π") }
                Key("Rand")
                    .scientific(size: size, isValidKey: model.digitsValid) { model.operation("rand") }
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
