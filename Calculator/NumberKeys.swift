////
////  NumberKeys.swift
////  Calculator
////
////  Created by Joachim Neumann on 20/09/2021.
////
//
//import SwiftUI
//
//
//struct NumberKeys: View {
//    @ObservedObject var brain: Brain
//    let t: TE
//
//    var body: some View {
//        VStack(spacing: t.spaceBetweenKeys) {
//            HStack(spacing: t.spaceBetweenKeys) {
//                OldKey("C", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.ac_plus_minus_percentProperties)
//                OldKey("±", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.ac_plus_minus_percentProperties)
//                OldKey("%", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.ac_plus_minus_percentProperties)
//                OldKey("/", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.colorOpProperties)
//            }
//            HStack(spacing: t.spaceBetweenKeys) {
//                OldKey("7", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.digits_1_9)
//                OldKey("8", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.digits_1_9)
//                OldKey("9", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.digits_1_9)
//                OldKey("x", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.colorOpProperties)
//            }
//            HStack(spacing: t.spaceBetweenKeys) {
//                OldKey("4", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.digits_1_9)
//                OldKey("5", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.digits_1_9)
//                OldKey("6", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.digits_1_9)
//                OldKey("-", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.colorOpProperties)
//            }
//            HStack(spacing: t.spaceBetweenKeys) {
//                OldKey("1", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.digits_1_9)
//                OldKey("2", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.digits_1_9)
//                OldKey("3", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.digits_1_9)
//                OldKey("+", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.colorOpProperties)
//            }
//            HStack(spacing: t.spaceBetweenKeys) {
//                OldKey("0", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.digits_0)
//                OldKey(",", requiresValidNuber: false, brain: brain, t: t, keyProperties: t.digits_1_9)
//                OldKey("=", requiresValidNuber: true, brain: brain, t: t, keyProperties: t.colorOpProperties)
//            }
//        }
//    }
//}
//
