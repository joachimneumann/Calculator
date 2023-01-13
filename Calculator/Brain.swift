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
    
    func operation(_ symbol: String) -> Number {
        brainEngine.operation(symbol)
    }
    
    func setPrecision(_ newPrecision: Int) -> Number {
        brainEngine.setPrecision(newPrecision)
    }
    
    func replaceLast(with number: Number) -> Number {
        brainEngine.replaceLast(with: number)
    }
    
    var precision: Int {
        brainEngine.precision
    }
}
