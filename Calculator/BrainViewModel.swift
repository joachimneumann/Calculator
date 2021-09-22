//
//  BrainViewModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

import Foundation

class BrainViewModel: ObservableObject {
    @Published private(set) var mainDisplay: String = ""
    
    private var shortDisplayString: ShortDisplayString
    private let brain = Brain()
    private var trailingZeroesString: String?
    
    func digit(_ digit: Character) {
        brain.digit(digit)
        trailingZeroesString = nil
        shortDisplayString = brain.shortDisplayString()
        mainDisplay = shortDisplayString.show()
    }
    
    func changeSign() {
        brain.changeSign_()
        shortDisplayString = brain.shortDisplayString()
        mainDisplay = shortDisplayString.show()
    }
    
    func zero() {
        brain.digit("0")
        if mainDisplay.contains(",") {
            if trailingZeroesString == nil {
                trailingZeroesString = mainDisplay
            }
            if trailingZeroesString!.count < 9 {
                trailingZeroesString! += "0"
                mainDisplay = trailingZeroesString!
            }
        } else {
            shortDisplayString = brain.shortDisplayString()
            mainDisplay = shortDisplayString.show()
        }
    }
    
    func comma() {
        brain.digit(".")
        shortDisplayString = brain.shortDisplayString()
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
        mainDisplay = shortDisplayString.show()
        //        let temp = brain.shortString()
        //        mainDisplay = String(temp.prefix(10))
    }
    
    init() {
        trailingZeroesString = nil
        shortDisplayString = brain.shortDisplayString()
        mainDisplay = shortDisplayString.show()
    }
}
