//
//  BrainViewModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

import Foundation

class BrainViewModel: ObservableObject {
    @Published private(set) var shortDisplayString: String = ""
    @Published private(set) var shortDisplayData: DisplayData = DisplayData()

    @Published var secondKeys: Bool = false
    
    var allDigitsDisplayData: DisplayData { brain.allDigitsDisplayData }
    private let brain = Brain()
    private var trailingZeroesString: String?
    
    func secretDigit(_ digit: Character) {
        brain.addDigitToNumberString(digit)
    }

    func digit(_ digit: Character) {
        if shortDisplayData.isValidNumber {
            brain.addDigitToNumberString(digit)
            trailingZeroesString = nil
            shortDisplayData = brain.shortDisplayData()
            shortDisplayString = shortDisplayData.string
        }
    }
    
    func zero() {
        if shortDisplayData.isValidNumber {
            brain.addDigitToNumberString("0")
            shortDisplayData = brain.shortDisplayData()
            if shortDisplayString.contains(",") {
                if trailingZeroesString == nil {
                    trailingZeroesString = shortDisplayString
                }
                if trailingZeroesString!.count < Configuration.shared.digitsInSmallDisplay {
                    trailingZeroesString! += "0"
                    shortDisplayString = trailingZeroesString!
                }
            } else {
                shortDisplayString = shortDisplayData.string
            }
        }
    }
    
    func comma() {
        if shortDisplayData.isValidNumber {
            brain.addDigitToNumberString(",")
            shortDisplayData = brain.shortDisplayData()
            shortDisplayString = shortDisplayData.string
            if !shortDisplayString.contains(",") {
                shortDisplayString += ","
                trailingZeroesString = shortDisplayString
            }
        }
    }
    
    func secretOperation(_ op: String) {
        brain.operation(op)
    }

    func operation(_ op: String) {
        if shortDisplayData.isValidNumber {
            brain.operation(op)
            shortDisplayData = brain.shortDisplayData()
            shortDisplayString = shortDisplayData.string
            trailingZeroesString = nil
        }
    }

    func reset() {
        brain.reset()
        trailingZeroesString = nil
        shortDisplayData = brain.shortDisplayData()
        shortDisplayString = shortDisplayData.string
        //        let temp = brain.shortString()
        //        mainDisplay = String(temp.prefix(10))
    }
    
    init() {
        trailingZeroesString = nil
        shortDisplayData = brain.shortDisplayData()
        shortDisplayString = shortDisplayData.string
    }
}
