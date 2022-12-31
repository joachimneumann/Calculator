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
                let screen = Screen(geo.size)
                let keyModel = KeyModel(screen: screen)
                Calculator(keyModel: keyModel)
            }
            .preferredColorScheme(.dark)
        }
    }
}
