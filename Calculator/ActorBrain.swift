//
//  ActorBrain.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/30/22.
//

import Foundation

actor ActorBrain {
    private let brain: Brain
    init(precision: Int) {
        self.brain = Brain(precision: precision)
    }
    
    func operation(_ symbol: String) -> CalculationResult {
        brain.operation(symbol)
    }
    
    func setPrecision(_ newPrecision: Int) -> CalculationResult {
        brain.setPrecision(newPrecision)
    }
    
    func replaceLast(with number: Number) {
        brain.replaceLast(with: number)
    }
    
    var precision: Int {
        brain.precision
    }
}
