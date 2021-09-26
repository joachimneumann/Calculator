//
//  OpStack.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import Foundation

struct Op2 {
    let op: (Gmp, Gmp) -> (Gmp)
    let priority: Int
    init(_ op: @escaping (Gmp, Gmp) -> (Gmp), _ priority: Int) {
        self.op = op
        self.priority = priority
    }
}

struct TwoParameterOperationStack {
    private var array: [Op2] = []
    mutating func push(_ element: Op2) {
        array.append(element)
    }
    mutating func pop() -> Op2? {
        return array.popLast()
    }
    
    mutating func removeLast() {
        array.removeLast()
    }
    
    var last: Op2? {
        array.last
    }
    var count: Int {
        array.count
    }
    mutating func clean() {
        array.removeAll()
    }
}
    
