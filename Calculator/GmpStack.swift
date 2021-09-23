//
//  GmpStack.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import Foundation

struct GmpStack {
    fileprivate var array: [Gmp] = []
    mutating func push(_ element: Gmp) {
        array.append(element)
    }
    mutating func pop() -> Gmp? {
        return array.popLast()
    }
    mutating func removeLast() {
        array.removeLast()
    }
    mutating func modifyLast(withOp op: (Gmp) -> ()) {
        op(array[array.count-1])
    }
    mutating func replaceLast(withOp op: () -> (Gmp)) {
        array[array.count-1] = op()
    }
    mutating func push(withOp op: () -> (Gmp)) {
        array.append(op())
    }

    var peek: Gmp? {
        array.last
    }
    var count: Int {
        array.count
    }
    mutating func replaceLast(with gmp: Gmp) {
        array.removeLast()
        array.append(gmp)
    }
    mutating func clean() {
        array.removeAll()
    }
}