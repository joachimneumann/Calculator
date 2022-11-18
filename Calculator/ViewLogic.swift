//
//  ViewLogic.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

extension CalculatorView {
    @MainActor class ViewModel: ObservableObject {
        let brain: Brain
        
        
        init(precision: Int) {
            brain = Brain(precision: precision)
        }
    }
}
