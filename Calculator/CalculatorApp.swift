//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI

@main
struct CalculatorApp: App {
    let brain = Brain()
    @UIApplicationDelegateAdaptor var mydelegate: MyAppDelegate
    
    var body: some Scene {
#if targetEnvironment(macCatalyst)
        CalculatorAppCatalyst(brain: brain)
#else
        CalculatorAppiOS(brain: brain)
#endif
    }
}
