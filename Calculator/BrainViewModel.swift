//
//  BrainViewModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 22/09/2021.
//

import Foundation

class BrainViewModel: ObservableObject {
    private let brain = Brain()
    @Published private(set) var mainDisplay: String = ""
    
    func digit(_ digit: Character) {
        brain.digit(digit)
        mainDisplay = brain.shortString
    }
    
    func reset() {
        brain.reset()
        mainDisplay = brain.shortString
    }
    
    init() {
        mainDisplay = brain.shortString
    }
}
