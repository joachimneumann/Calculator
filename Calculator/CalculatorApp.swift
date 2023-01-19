//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI

@main
struct CalculatorApp: App {
    @AppStorage("text") private var text: String = ""
    @AppStorage("DecimalSeparator") private var decimalSeparator: DecimalSeparator = Locale.current.decimalSeparator == "," ? .comma : .dot
    @AppStorage("GroupingSeparator") private var groupingSeparator: GroupingSeparator = .none

    var body: some Scene {
        WindowGroup {
            GeometryReader { geo in
                Calculator(screen: Screen(geo.size))
                    .environment(\.customText, $text)
                    .environment(\.decimalSeparator, $decimalSeparator)
                    .environment(\.groupingSeparator, $groupingSeparator)
            }
        }
    }
}
