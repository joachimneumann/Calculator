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
                Calculator(screen: Screen(geo.size))
//                    .environmentObject(Screen(geo.size)) // Make the theme available through the environment.
            }
            .preferredColorScheme(.dark)
        }
    }
}
