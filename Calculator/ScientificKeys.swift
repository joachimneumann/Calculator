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
    let fontSize: CGFloat
    let vSpacing: CGFloat
    let hSpacing: CGFloat
    
    var body: some View {
        VStack(spacing: vSpacing) {
            HStack(spacing: hSpacing) {
                Key("(", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation("(") }
                Key(")", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation(")") }
                Key("mc", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation("mc") }
                Key("m+", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation("m+") }
                Key("m-", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation("m-") }
                Key("mr", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation("mr") }
            }
            HStack(spacing: hSpacing) {
                Key("2nd", keyProperties: TE.SecondKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: brain.secondKeys)
                { brain.secondKeys.toggle() }
                Key("x^2", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation("x^2") }
                Key("x^3", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation("x^3") }
                Key("x^y", keyProperties: TE.LightGrayKeyProperties, isAllowed: brain.isValidNumber && !brain.showCalculating)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: brain.isPending("x^y"))
                { brain.asyncOperation("x^y") }
                Key(brain.secondKeys ? "y^x" : "e^x", keyProperties: TE.LightGrayKeyProperties, isAllowed: brain.isValidNumber && !brain.showCalculating)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: brain.secondKeys ? brain.isPending("y^x") : false)
                { brain.asyncOperation(brain.secondKeys ? "y^x" : "e^x") }
                Key(brain.secondKeys ? "2^x" : "10^x", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation(brain.secondKeys ? "2^x" : "10^x") }
            }
            HStack(spacing: hSpacing) {
                Key("One_x", keyProperties: TE.LightGrayKeyProperties, isAllowed: brain.isValidNumber && !brain.showCalculating)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation("One_x") }
                Key("√", keyProperties: TE.LightGrayKeyProperties, isAllowed: brain.isValidNumber && !brain.showCalculating)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation("√") }
                Key("3√", keyProperties: TE.LightGrayKeyProperties, isAllowed: brain.isValidNumber && !brain.showCalculating)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation("3√") }
                Key("y√", keyProperties: TE.LightGrayKeyProperties, isPending: brain.isPending("y√"), isAllowed: brain.isValidNumber && !brain.showCalculating)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: brain.isPending("y√"))
                { brain.asyncOperation("y√") }
                Key(brain.secondKeys ? "logy" : "ln", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: brain.secondKeys ? brain.isPending("logy") : false)
                { brain.asyncOperation(brain.secondKeys ? "logy" : "ln") }
                Key(brain.secondKeys ? "log2" : "log10", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation(brain.secondKeys ? "log2" : "log10") }
            }
            HStack(spacing: hSpacing) {
                Key("x!", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation("x!") }
                Key(brain.secondKeys ? "asin" : "sin", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                {   if brain.rad {
                        brain.asyncOperation(brain.secondKeys ? "asin" : "sin")
                    } else {
                        brain.asyncOperation(brain.secondKeys ? "asinD" : "sinD")
                    }
                }
                Key(brain.secondKeys ? "acos" : "cos", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                {   if brain.rad {
                        brain.asyncOperation(brain.secondKeys ? "acos" : "cos")
                    } else {
                        brain.asyncOperation(brain.secondKeys ? "acosD" : "cosD")
                    }
                }
                Key(brain.secondKeys ? "atan" : "tan", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                {   if brain.rad {
                        brain.asyncOperation(brain.secondKeys ? "atan" : "tan")
                    } else {
                        brain.asyncOperation(brain.secondKeys ? "atanD" : "tanD")
                    }
                }
                Key("e", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation("e") }
                Key("EE", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation("EE") }
            }
            HStack(spacing: hSpacing) {
                Key(brain.rad ? "Deg" : "Rad", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.rad.toggle() }
                Key(brain.secondKeys ? "asinh" : "sinh", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation(brain.secondKeys ? "asinh" : "sinh") }
                Key(brain.secondKeys ? "acosh" : "cosh", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation(brain.secondKeys ? "acosh" : "cosh") }
                Key(brain.secondKeys ? "atanh" : "tanh", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation(brain.secondKeys ? "atanh" : "tanh") }
                Key("π", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation("π") }
                Key("Rand", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        fontSize: fontSize,
                        enabled: !brain.isCalculating && !brain.isValidNumber,
                        showEnabled: !brain.showCalculating && !brain.isValidNumber,
                        isPending: false)
                { brain.asyncOperation("rand") }
            }
        }
    }

    init(brain: Brain, t: TE) {
        self.brain = brain
        hSpacing = t.spaceBetweenkeys
        vSpacing = t.spaceBetweenkeys
        keySize  = t.keySize
        fontSize = t.scientificKeyFontSize
    }
}
