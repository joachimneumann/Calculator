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

    func replaceLast(withString numberString: String) {
        brainEngine.replaceLast(with: number(numberString))
    }

    var precision: Int {
        brainEngine.precision
    }
    
    func number(_ numberString: String) -> Number {
        brainEngine.number(numberString)
    }
}
