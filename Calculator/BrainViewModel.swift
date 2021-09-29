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
    
    func isPending(_ symbol: String) -> Bool {
        if let pendingOperator = brain.pendingOperator {
            return pendingOperator == symbol
        }
        return false
    }

    func digit(_ digit: Int) {
        brain.digit(digit)
        objectWillChange.send()
    }
    
    var digitsAllowed: Bool { true }
    var inPlaceAllowed: Bool { brain.isValid }
    func zero() { brain.zero() }
    func comma() { brain.comma() }
    func operation(_ op: String) {
        brain.operation(op)
        objectWillChange.send()
    }
    func reset() { brain.reset() }
    func clearMemory() { brain.clearMemory() }
    func addToMemory() {
        brain.addToMemory(brain.last.gmp)
    }
    func subtractFromMemory() {
        brain.substractFromMemory(brain.last.gmp)
    }
    func getMemory() { brain.getMemory() }

}
