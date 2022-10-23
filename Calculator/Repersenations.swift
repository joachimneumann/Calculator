//
//  Repersenations.swift
//  Calculator
//
//  Created by Joachim Neumann on 31.03.22.
//

import Foundation

class Representation {
    let portrait: SingleLengthRepresentation
    let landscape: SingleLengthRepresentation
    let zoom: SingleLengthRepresentation

    init(portraitLength: Int, landscapeLength: Int, zoomLength: Int) {
        portrait = SingleLengthRepresentation(length: portraitLength)
        landscape = SingleLengthRepresentation(length: landscapeLength)
        zoom = SingleLengthRepresentation(length: zoomLength)
    }
    
    func update(_ number: Number) {
        portrait.update(number)
        landscape.update(number)
        zoom.update(number)
    }

}
