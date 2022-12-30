//
//  ActorBrain.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/30/22.
//

import Foundation

actor Brain {
    private let brainEngine: BrainEngine
    
    init(precision: Int) {
        self.brainEngine = BrainEngine(precision: precision)
    }
    
    func operation(_ symbol: String) -> CalculationResult {
        brainEngine.operation(symbol)
    }
    
    func setPrecision(_ newPrecision: Int) -> CalculationResult {
        brainEngine.setPrecision(newPrecision)
    }
    
    func replaceLast(with number: Number) {
        brainEngine.replaceLast(with: number)
    }
    
    var precision: Int {
        brainEngine.precision
    }
}
