//
//  BrainViewModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

import Foundation

class BrainViewModel: ObservableObject {
    var displayString: String { brain.display }
    @Published var secondKeys: Bool = false
    @Published var rad: Bool = false
    var longDisplayString: String { brain.longDisplay }
    var hasMoreDigits: Bool { brain.hasMoreDigits }
    private let brain = Brain()
    
    var inPlaceAllowed: Bool { brain.isValid }
    func isPending(_ symbol: String) -> Bool {
        if let pendingOperator = brain.pendingOperator {
            return pendingOperator == symbol
        }
        return false
    }

    func digit(_ digit: Int) {
        brain.digit(digit)
    }
    
    var digitsAllowed: Bool { true }
    func zero() { brain.zero() }
    func comma() { brain.comma() }
    func operation(_ op: String) { brain.operation(op) }
    func reset() { brain.reset() }
    func clearmemory() { brain.clearmemory() }
    func addToMemory() {
        brain.addToMemory(brain.last.gmp)
    }
    func subtractFromMemory() {
        brain.substractFromMemory(brain.last.gmp)
    }
    func memory() {
        brain.getMemory()
    }

}
