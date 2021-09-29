//
//  GmpStack.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import Foundation

struct GmpStack: CustomDebugStringConvertible{
    private var array: [Gmp] = []

    var last: Gmp {
        if let last = array.last {
            return last
        } else {
            assert(false)
        }
    }
    var count: Int { array.count }

    mutating func append(_ element: Gmp) { array.append(element) }
    mutating func popLast() -> Gmp?      { assert(array.count > 0); return array.popLast() }
    mutating func removeLast()           { assert(array.count > 0); array.removeLast() }
    mutating func removeAll()            { array.removeAll() }

    mutating func modifyLast(withOp op: inplaceType) {
        last.inPlace(op: op)
    }
    mutating func replaceLast(with gmp: Gmp) {
        array.removeLast()
        array.append(gmp)
    }

    var secondLast: Gmp? {
        if count >= 2 {
            return array[array.count - 2]
        } else {
            return nil
        }
    }
    var debugDescription: String {
        var ret = "gmpStack \(array.count): "
        for gmp in array {
            ret += ("\(gmp.toDouble()) ")
         }
        return ret
    }
}
