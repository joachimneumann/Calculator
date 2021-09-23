//
//  OpStack.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import Foundation

struct TwoParameterOperation {
    let op: (Gmp, Gmp) -> (Gmp)
    let priority: Int
    init(_ op: @escaping (Gmp, Gmp) -> (Gmp), _ priority: Int) {
        self.op = op
        self.priority = priority
    }
}

struct TwoParameterOperationStack {
    fileprivate var array: [TwoParameterOperation] = []
    mutating func push(_ element: TwoParameterOperation) {
        array.append(element)
    }
    mutating func pop() -> TwoParameterOperation? {
        return array.popLast()
    }
    
    mutating func removeLast() {
        array.removeLast()
    }
    
    var peek: TwoParameterOperation? {
        array.last
    }
    var count: Int {
        array.count
    }
    mutating func clean() {
        array.removeAll()
    }
}
    
