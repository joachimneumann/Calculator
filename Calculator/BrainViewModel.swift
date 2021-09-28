//
//  BrainViewModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

import Foundation

class BrainViewModel: ObservableObject {
    @Published private(set) var shortDisplayString: String = ""
    @Published private(set) var hasMoreDigits: Bool = false
    @Published var secondKeys: Bool = false
    @Published var rad: Bool = false
    var longDisplayString: String { brain.allDigitsDisplayData.string }
    
    private var shortDisplayData: DisplayData = DisplayData()
    private let brain = Brain()
    private var trailingZeroesString: String?
    
    func secretDigit(_ digit: Character) {
        brain.addDigitToNumberString(digit)
    }

    func digit(_ digit: Character) {
        brain.addDigitToNumberString(digit)
        trailingZeroesString = nil
        shortDisplayData = brain.shortDisplayData()
        shortDisplayString = shortDisplayData.string
        hasMoreDigits = shortDisplayData.hasMoreDigits
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
                hasMoreDigits = shortDisplayData.hasMoreDigits
            }
        }
    }
    
    func comma() {
        if shortDisplayData.isValidNumber {
            brain.addDigitToNumberString(",")
            shortDisplayData = brain.shortDisplayData()
            shortDisplayString = shortDisplayData.string
            hasMoreDigits = shortDisplayData.hasMoreDigits
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
            hasMoreDigits = shortDisplayData.hasMoreDigits
            trailingZeroesString = nil
        }
    }

    func reset() {
        brain.reset()
        trailingZeroesString = nil
        shortDisplayData = brain.shortDisplayData()
        shortDisplayString = shortDisplayData.string
        hasMoreDigits = shortDisplayData.hasMoreDigits
        //        let temp = brain.shortString()
        //        mainDisplay = String(temp.prefix(10))
    }
    
    func clearmemory() {
        brain.clearmemory()
    }
    func addToMemory() {
        if let last = brain.last {
            brain.addToMemory(last)
        }
    }
    func subtractFromMemory() {
        if let last = brain.last {
            brain.substractFromMemory(last)
        }
    }
    func memory() {
        brain.getMemory()
        shortDisplayData = brain.shortDisplayData()
        shortDisplayString = shortDisplayData.string
        hasMoreDigits = shortDisplayData.hasMoreDigits
        trailingZeroesString = nil
    }

    
    init() {
        trailingZeroesString = nil
        shortDisplayData = brain.shortDisplayData()
        shortDisplayString = shortDisplayData.string
        hasMoreDigits = shortDisplayData.hasMoreDigits
    }
}
