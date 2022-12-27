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
                let brainModel = BrainModel(screen: screen)
                let keyModel = KeyModel(screen: screen, callback: brainModel.execute)
                Calculator(screen: Screen(geo.size), brainModel: brainModel, keyModel: keyModel)
            }
            .preferredColorScheme(.dark)
        }
    }
}
