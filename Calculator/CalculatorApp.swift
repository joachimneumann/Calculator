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
                let model = Model(screen: screen)
                let keyModel = KeyModel(screen: screen, callback: model.execute)
                Calculator(screen: Screen(geo.size), model: model, keyModel: keyModel)
            }
            .preferredColorScheme(.dark)
        }
    }
}
