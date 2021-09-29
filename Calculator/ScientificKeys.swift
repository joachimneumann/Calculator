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
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                { model.operation("(") }
                Key(")")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                { model.operation(")") }
                Key("mc")
                    .scientific(
                        size: size,
                        isAllowed: true,
                        isPending: false)
                { model.clearMemory() }
                Key("m+")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                { model.addToMemory() }
                Key("m-")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                { model.subtractFromMemory() }
                Key("mr")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                { model.subtractFromMemory() }
            }
            HStack(spacing: horizontalSpace) {
                Key("2nd")
                    .scientific(
                        size: size,
                        isAllowed: model.digitsAllowed,
                        isPending: false)
                { model.secondKeys.toggle() }
                Key("x^2")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                { model.operation("x^2") }
                Key("x^3")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                { model.operation("x^3") }
                Key("x^y")
                    .scientific(
                        size: size,
                        isAllowed: model.digitsAllowed,
                        isPending: model.isPending("x^y"))
                { model.operation("x^y") }
                Key(model.secondKeys ? "y^x" : "e^x")
                    .scientific(
                        size: size,
                        isAllowed: model.secondKeys ? model.digitsAllowed : model.inPlaceAllowed,
                        isPending: model.secondKeys ? model.isPending("y^x") : false)
                { model.operation(model.secondKeys ? "y^x" : "e^x") }
                Key(model.secondKeys ? "2^x" : "10^x")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                { model.operation(model.secondKeys ? "2^x" : "10^x") }
            }
            HStack(spacing: horizontalSpace) {
                Key("One_x")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                { model.operation("One_x") }
                Key("√")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                { model.operation("√") }
                Key("3√")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                { model.operation("3√") }
                Key("y√")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: model.isPending("y√"))
                { model.operation("y√") }
                Key(model.secondKeys ? "logy" : "ln")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: model.secondKeys ? model.isPending("logy") : false)
                { model.operation(model.secondKeys ? "logy" : "ln") }
                Key(model.secondKeys ? "log2" : "log10")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                { model.operation(model.secondKeys ? "log2" : "log10") }
            }
            HStack(spacing: horizontalSpace) {
                Key("x!")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                { model.operation("x!") }
                Key(model.secondKeys ? "asin" : "sin")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                {   if model.rad {
                        model.operation(model.secondKeys ? "asin" : "sin")
                    } else {
                        model.operation(model.secondKeys ? "asinD" : "sinD")
                    }
                }
                Key(model.secondKeys ? "acos" : "cos")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                {   if model.rad {
                        model.operation(model.secondKeys ? "acos" : "cos")
                    } else {
                        model.operation(model.secondKeys ? "acosD" : "cosD")
                    }
                }
                Key(model.secondKeys ? "atan" : "tan")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                {   if model.rad {
                        model.operation(model.secondKeys ? "atan" : "tan")
                    } else {
                        model.operation(model.secondKeys ? "atanD" : "tanD")
                    }
                }
                Key("e")
                    .scientific(
                        size: size,
                        isAllowed: model.digitsAllowed,
                        isPending: false)
                { model.operation("e") }
                Key("EE")
                    .scientific(
                        size: size,
                        isAllowed: model.digitsAllowed,
                        isPending: false)
                { model.operation("EE") }
            }
            HStack(spacing: horizontalSpace) {
                Key(model.rad ? "Deg" : "Rad")
                    .scientific(
                        size: size,
                        isAllowed: true,
                        isPending: false)
                { model.rad.toggle() }
                Key(model.secondKeys ? "asinh" : "sinh")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                {   if model.rad {
                        model.operation(model.secondKeys ? "asinh" : "sinh")
                    } else {
                        model.operation(model.secondKeys ? "asinhD" : "sinhD")
                    }
                }
                Key(model.secondKeys ? "acosh" : "cosh")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                {   if model.rad {
                        model.operation(model.secondKeys ? "acosh" : "cosh")
                    } else {
                        model.operation(model.secondKeys ? "acoshD" : "coshD")
                    }
                }
                Key(model.secondKeys ? "atanh" : "tanh")
                    .scientific(
                        size: size,
                        isAllowed: model.inPlaceAllowed,
                        isPending: false)
                {   if model.rad {
                        model.operation(model.secondKeys ? "atanh" : "tanh")
                    } else {
                        model.operation(model.secondKeys ? "atanhD" : "tanhD")
                    }
                }
                Key("π")
                    .scientific(
                        size: size,
                        isAllowed: model.digitsAllowed,
                        isPending: false)
                { model.operation("π") }
                Key("Rand")
                    .scientific(
                        size: size,
                        isAllowed: model.digitsAllowed,
                        isPending: false)
                { model.operation("rand") }
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
