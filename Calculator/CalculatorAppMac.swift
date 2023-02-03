//
//  CalculatorAppMac.swift
//  Calculator
//
//  Created by Joachim Neumann on 2/3/23.
//

import SwiftUI

@main
struct CalculatorApp: App {
    let width: CGFloat = 574.0
    let height: CGFloat = 295.0
    var body: some Scene {
        WindowGroup {
            Calculator(screen: Screen(CGSize(width: width, height: height)))
                .frame(width: width, height: height)
        }
        .windowResizability(.contentSize)
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
