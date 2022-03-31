//
//  Repersenations.swift
//  Calculator
//
//  Created by Joachim Neumann on 31.03.22.
//

import Foundation

class Representations {
    let r1: Representation
    let r2: Representation

    init(characters1: Int, characters2: Int) {
        r1 = Representation(characters: characters1)
        r2 = Representation(characters: characters2)
    }
    
    func update(_ number: Number) {
        r1.update(number)
        r2.update(number)
    }

}
