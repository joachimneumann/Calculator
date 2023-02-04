//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI

public typealias AppleFont = UIFont

@main
struct CalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            GeometryReader { geo in
                Calculator(screen: Screen(geo.size))
            }
        }
    }
}
