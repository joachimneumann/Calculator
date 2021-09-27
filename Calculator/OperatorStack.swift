//
//  OpStack.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import Foundation

class Operator {
    let priority: Int
    init(_ priority: Int) {
        self.priority = priority
    }
}

typealias inplaceType = (Gmp) -> () -> ()
typealias twoOperantsType = (Gmp) -> (Gmp) -> ()

class TwoOperands: Operator {
    let operation: twoOperantsType
    init(_ op: @escaping twoOperantsType, _ priority: Int) {
        operation = op
        super.init(priority)
    }
}

struct OperatorStack {
    private var array: [Operator] = []
    mutating func push(_ element: Operator) {
        array.append(element)
    }
    mutating func pop() -> Operator? {
        return array.popLast()
    }
    
    mutating func removeLast() {
        array.removeLast()
    }
    
    var last: Operator? {
        array.last
    }
    var count: Int {
        array.count
    }
    mutating func clean() {
        array.removeAll()
    }
}
    
