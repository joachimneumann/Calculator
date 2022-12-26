//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI

@main
struct CalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            GeometryReader { (geo) in
                Calculator(Screen(geo.size))
            }
            .preferredColorScheme(.dark)
        }
    }
}
