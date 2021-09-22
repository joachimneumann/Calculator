//
//  BrainViewModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

import Foundation

class BrainViewModel: ObservableObject {
    @Published private(set) var mainDisplay: String = ""
    @Published private(set) var higherPrecisionAvailable: Bool = false

    private var shortDisplayString: ShortDisplayString
    private let brain = Brain()
    private var trailingZeroesString: String?
    
    func digit(_ digit: Character) {
        brain.digit(digit)
        trailingZeroesString = nil
        shortDisplayString = brain.shortDisplayString()
        mainDisplay = shortDisplayString.show()
        higherPrecisionAvailable = shortDisplayString.higherPrecisionAvailable
    }
    
    func changeSign() {
        brain.changeSign_()
        shortDisplayString = brain.shortDisplayString()
        mainDisplay = shortDisplayString.show()
        higherPrecisionAvailable = shortDisplayString.higherPrecisionAvailable
    }
    
    func zero() {
        brain.digit("0")
        shortDisplayString = brain.shortDisplayString()
        higherPrecisionAvailable = shortDisplayString.higherPrecisionAvailable
        if mainDisplay.contains(",") && !shortDisplayString.isScientificNotation {
            if trailingZeroesString == nil {
                trailingZeroesString = mainDisplay
            }
            if trailingZeroesString!.count < 9 {
                trailingZeroesString! += "0"
                mainDisplay = trailingZeroesString!
            }
        } else {
            mainDisplay = shortDisplayString.show()
        }
    }
    
    func comma() {
        brain.digit(".")
        shortDisplayString = brain.shortDisplayString()
        higherPrecisionAvailable = shortDisplayString.higherPrecisionAvailable
        mainDisplay = shortDisplayString.show()
        if !mainDisplay.contains(",") {
            mainDisplay += ","
            trailingZeroesString = mainDisplay
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
    
    init() {
        trailingZeroesString = nil
        shortDisplayString = brain.shortDisplayString()
        higherPrecisionAvailable = shortDisplayString.higherPrecisionAvailable
        mainDisplay = shortDisplayString.show()
    }
}
