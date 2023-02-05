//
//  CalculatorAppMac.swift
//  Calculator
//
//  Created by Joachim Neumann on 2/3/23.
//

import SwiftUI

public typealias AppleFont = NSFont

@main
struct CalculatorApp: App {
    
    let width: CGFloat = 574.0
    let height: CGFloat = 293.0
    
    var body: some Scene {
        let screen = Screen(CGSize(width: width, height: height))
        WindowGroup {
            Calculator(screen: screen)
                .frame(width: width, height: height)
                .background(screen.backgroundColor)
        }
        .windowResizability(.contentSize)
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
