////
////  Persistent.swift
////  Calculator
////
////  Created by Joachim Neumann on 1/19/23.
////
//
//import SwiftUI
//
//struct CustomTextKey: EnvironmentKey {
//    static var defaultValue: Binding<String> = Binding.constant("Default Text")
//}
//struct DecimalSeparatorKey: EnvironmentKey {
//    static var defaultValue: Binding<DecimalSeparator> = Binding.constant(Locale.current.decimalSeparator == "," ? .comma : .dot)
//}
//struct GroupingSeparatorKey: EnvironmentKey {
//    static var defaultValue: Binding<GroupingSeparator> = Binding.constant(.none)
//}
//
//extension EnvironmentValues {
//    var customText: Binding<String> {
//        get { self[CustomTextKey.self] }
//        set { self[CustomTextKey.self] = newValue }
//    }
//    var decimalSeparator: Binding<DecimalSeparator> {
//        get { self[DecimalSeparatorKey.self] }
//        set { self[DecimalSeparatorKey.self] = newValue }
//    }
//    var groupingSeparator: Binding<GroupingSeparator> {
//        get { self[GroupingSeparatorKey.self] }
//        set { self[GroupingSeparatorKey.self] = newValue }
//    }
//}
//
//
// struct Persistent: View {
//    @AppStorage("text") private var text: String = ""
//    var body: some View {
//        TextEditor(text: $text).padding()
//        Divider()
//        SecondView()
//            .environment(\.customText, $text)
//    }
//}
//
//struct SecondView: View {
//    var body: some View {
//        ThirdView()
//    }
//}
//struct ThirdView: View {
//    @Environment(\.customText) private var text: Binding<String>
//    var body: some View {
//        TextEditor(text: text).padding()
//            .onAppear() {
//                text.wrappedValue = "XXXX"
//            }
//    }
//}
//
