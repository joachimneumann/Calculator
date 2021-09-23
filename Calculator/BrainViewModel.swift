//
//  BrainViewModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

import Foundation

class BrainViewModel: ObservableObject {
    @Published private(set) var mainDisplay: String = ""
    @Published private(set) var longString: DisplayString = DisplayString(invalid: "invalid")
    @Published private(set) var higherPrecisionAvailable: Bool = false

    private var shortDisplayString: DisplayString
    private let brain = Brain()
    private var trailingZeroesString: String?
    
    func digit(_ digit: Character) {
        if shortDisplayString.isValidNumber {
            brain.addDigitToNumberString(digit)
            trailingZeroesString = nil
            shortDisplayString = brain.shortDisplayString()
            mainDisplay = shortDisplayString.show()
            higherPrecisionAvailable = shortDisplayString.higherPrecisionAvailable
        }
    }
    
    func operation(_ op: String) {
        if shortDisplayString.isValidNumber {
            brain.operation(op)
            shortDisplayString = brain.shortDisplayString()
            mainDisplay = shortDisplayString.show()
            higherPrecisionAvailable = shortDisplayString.higherPrecisionAvailable
        }
    }

    func zero() {
        if shortDisplayString.isValidNumber {
            brain.addDigitToNumberString("0")
            shortDisplayString = brain.shortDisplayString()
            higherPrecisionAvailable = shortDisplayString.higherPrecisionAvailable
            if mainDisplay.contains(",") {
                if trailingZeroesString == nil {
                    trailingZeroesString = mainDisplay
                }
                if trailingZeroesString!.count < Configuration.shared.digits {
                    trailingZeroesString! += "0"
                    mainDisplay = trailingZeroesString!
                }
            } else {
                mainDisplay = shortDisplayString.show()
            }
        }
    }
    
    func comma() {
        if shortDisplayString.isValidNumber {
            brain.addDigitToNumberString(",")
            shortDisplayString = brain.shortDisplayString()
            higherPrecisionAvailable = shortDisplayString.higherPrecisionAvailable
            mainDisplay = shortDisplayString.show()
            if !mainDisplay.contains(",") {
                mainDisplay += ","
                trailingZeroesString = mainDisplay
            }
        }
    }
    
    func reset() {
        brain.reset()
        trailingZeroesString = nil
        shortDisplayString = brain.shortDisplayString()
        higherPrecisionAvailable = shortDisplayString.higherPrecisionAvailable
        mainDisplay = shortDisplayString.show()
        //        let temp = brain.shortString()
        //        mainDisplay = String(temp.prefix(10))
    }
    
    func getLongString() {
        longString = brain.longString()
    }
    
    init() {
        trailingZeroesString = nil
        shortDisplayString = brain.shortDisplayString()
        higherPrecisionAvailable = shortDisplayString.higherPrecisionAvailable
        mainDisplay = shortDisplayString.show()
    }
}
