//
//  SmartDisplayData.swift
//  Calculator
//
//  Created by Joachim Neumann on 01.03.22.
//

import Foundation

class SmartDisplayData: ObservableObject {
    @Published var left: String
    @Published var right: String?
    init(_ n: Number) {
        if let string = n.str {
            left = string
        } else {
            left = "gmp"
        }
    }
}
