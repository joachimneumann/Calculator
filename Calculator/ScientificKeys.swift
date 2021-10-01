//
//  ScientificKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

struct ScientificKeys: View {
    @ObservedObject var brain: Brain
    let keySize: CGSize
    let verticalSpace: CGFloat
    let horizontalSpace: CGFloat

    var body: some View {
        VStack(spacing: verticalSpace) {
            HStack(spacing: horizontalSpace) {
                Key("(")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("(") }
                Key(")")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation(")") }
                Key("mc")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.notCalculating,
                        isPending: false)
                { brain.clearMemory() }
                Key("m+")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.addToMemory() }
                Key("m-")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.subtractFromMemory() }
                Key("mr")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.memory != nil && brain.notCalculating,
                        isPending: false,
                        isActive: brain.memory != nil)
                { brain.getMemory() }
            }
            HStack(spacing: horizontalSpace) {
                Key("2nd")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.digitsAllowed,
                        isPending: brain.secondKeys)
                { brain.secondKeys.toggle() }
                Key("x^2")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("x^2") }
                Key("x^3")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("x^3") }
                Key("x^y", isActive: brain.inPlaceAllowed)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: brain.isPending("x^y"))
                { brain.operation("x^y") }
                Key(brain.secondKeys ? "y^x" : "e^x", isActive: brain.inPlaceAllowed)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.secondKeys ? brain.inPlaceAllowed : brain.inPlaceAllowed,
                        isPending: brain.secondKeys ? brain.isPending("y^x") : false)
                { brain.operation(brain.secondKeys ? "y^x" : "e^x") }
                Key(brain.secondKeys ? "2^x" : "10^x")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation(brain.secondKeys ? "2^x" : "10^x") }
            }
            HStack(spacing: horizontalSpace) {
                Key("One_x", isActive: brain.inPlaceAllowed)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false,
                        isActive: brain.inPlaceAllowed)
                { brain.operation("One_x") }
                Key("√", isActive: brain.inPlaceAllowed)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("√") }
                Key("3√", isActive: brain.inPlaceAllowed)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("3√") }
                Key("y√", isPending: brain.isPending("y√"), isActive: brain.inPlaceAllowed) // isPending for strokeColor
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: brain.isPending("y√"))
                { brain.operation("y√") }
                Key(brain.secondKeys ? "logy" : "ln")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: brain.secondKeys ? brain.isPending("logy") : false)
                { brain.operation(brain.secondKeys ? "logy" : "ln") }
                Key(brain.secondKeys ? "log2" : "log10")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation(brain.secondKeys ? "log2" : "log10") }
            }
            HStack(spacing: horizontalSpace) {
                Key("x!")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("x!") }
                Key(brain.secondKeys ? "asin" : "sin")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                {   if brain.rad {
                        brain.operation(brain.secondKeys ? "asin" : "sin")
                    } else {
                        brain.operation(brain.secondKeys ? "asinD" : "sinD")
                    }
                }
                Key(brain.secondKeys ? "acos" : "cos")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                {   if brain.rad {
                        brain.operation(brain.secondKeys ? "acos" : "cos")
                    } else {
                        brain.operation(brain.secondKeys ? "acosD" : "cosD")
                    }
                }
                Key(brain.secondKeys ? "atan" : "tan")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                {   if brain.rad {
                        brain.operation(brain.secondKeys ? "atan" : "tan")
                    } else {
                        brain.operation(brain.secondKeys ? "atanD" : "tanD")
                    }
                }
                Key("e")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.digitsAllowed,
                        isPending: false)
                { brain.operation("e") }
                Key("EE")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.digitsAllowed,
                        isPending: false)
                { brain.operation("EE") }
            }
            HStack(spacing: horizontalSpace) {
                Key(brain.rad ? "Deg" : "Rad")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.notCalculating,
                        isPending: false)
                { brain.rad.toggle() }
                Key(brain.secondKeys ? "asinh" : "sinh")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                {   if brain.rad {
                        brain.operation(brain.secondKeys ? "asinh" : "sinh")
                    } else {
                        brain.operation(brain.secondKeys ? "asinhD" : "sinhD")
                    }
                }
                Key(brain.secondKeys ? "acosh" : "cosh")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                {   if brain.rad {
                        brain.operation(brain.secondKeys ? "acosh" : "cosh")
                    } else {
                        brain.operation(brain.secondKeys ? "acoshD" : "coshD")
                    }
                }
                Key(brain.secondKeys ? "atanh" : "tanh")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                {   if brain.rad {
                        brain.operation(brain.secondKeys ? "atanh" : "tanh")
                    } else {
                        brain.operation(brain.secondKeys ? "atanhD" : "tanhD")
                    }
                }
                Key("π")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.digitsAllowed,
                        isPending: false)
                { brain.operation("π") }
                Key("Rand")
                    .scientific(
                        size: keySize,
                        isAllowed: brain.digitsAllowed,
                        isPending: false)
                { brain.operation("rand") }
            }
        }
    }

    init(brain: Brain, appFrame: CGSize) {
        self.brain = brain
        horizontalSpace = Configuration.spaceBetweenkeys(appFrame: appFrame)
        verticalSpace   = Configuration.spaceBetweenkeys(appFrame: appFrame)
        keySize = Configuration.scientificKeySize(appFrame: appFrame)
    }
}

struct ScientificKeys_Previews: PreviewProvider {
    static var previews: some View {
        ScientificKeys(brain: Brain(), appFrame: CGSize(width: 200, height: 200))
    }
}
