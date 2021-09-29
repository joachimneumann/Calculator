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
    private var trailingZeroesString: String?
    
    var inPlaceAllowed: Bool { brain.isValid }
    func isPending(_ symbol: String) -> Bool {
        if let pendingOperator = brain.pendingOperator {
            return pendingOperator == symbol
        }
        return false
    }
    func secretDigit(_ digit: Int) {
        brain.digit(digit)
    }

    func digit(_ digit: Int) {
        brain.digit(digit)
        trailingZeroesString = nil
    }
    
    var digitsAllowed: Bool { true }
    
    func zero() {
            brain.zero()
//            if shortDisplayString.contains(",") {
//                if trailingZeroesString == nil {
//                    trailingZeroesString = shortDisplayString
//                }
//                if trailingZeroesString!.count < Configuration.shared.digitsInSmallDisplay {
//                    trailingZeroesString! += "0"
//                    shortDisplayString = trailingZeroesString!
//                }
//            } else {
//                shortDisplayString = shortDisplayData.string
//            }
    }
    
    func comma() {
//        if !shortDisplayString.contains(",") {
//            shortDisplayString += ","
//            trailingZeroesString = shortDisplayString
//        }
        brain.comma()
    }
    
    func secretOperation(_ op: String, withPending: Bool = false) {
        brain.operation(op, withPending: withPending)
    }
    
    func operation(_ op: String) {
        brain.operation(op)
        trailingZeroesString = nil
    }

    func reset() {
        brain.reset()
        trailingZeroesString = nil
        //        let temp = brain.shortString()
        //        mainDisplay = String(temp.prefix(10))
    }
    
    func clearmemory() {
        brain.clearmemory()
    }
    func addToMemory() {
        brain.addToMemory(brain.last.gmp)
    }
    func subtractFromMemory() {
        brain.substractFromMemory(brain.last.gmp)
    }
    func memory() {
        brain.getMemory()
        trailingZeroesString = nil
    }

    
    init() {
        trailingZeroesString = nil
    }
}
