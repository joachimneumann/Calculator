//
//  NumberStack.swift
//  Calculator
//
//  Created by Joachim Neumann on 29/09/2021.
//

import Foundation

struct NumberStack: CustomDebugStringConvertible {
    private var array: [Number] = []

    var count: Int {
        print("array.count \(array.count)")
//        assert(array.count > 0)
        return array.count
    }
    var last: Number {
        assert(array.count > 0)
        return array.last!
    }
    
    mutating func updatePrecision(from oldPrecision: Int, to newPrecision: Int) {
        let stringPrecision = min(newPrecision, oldPrecision)
        let lengths = LengthMeasurementResult(
            withoutComma: stringPrecision,
            withCommaNonScientific: stringPrecision,
            withCommaScientific: stringPrecision,
            ePadding: 0)
        let newBits = Brain.bits(for: Brain.internalPrecision(newPrecision))
        for index in 0..<array.count {
            let old = array[index]
            let oldString = old.multipleLines(lengths).asOneLine
            let newGmp = Gmp(oldString, bits: newBits)
            array[index] = Number(newGmp)
        }
    }

    mutating func replaceLast(with number: Number) {
        removeLast()
        append(number)
    }
    mutating func append(_ number: Number) {
        array.append(number)
    }
    mutating func popLast() -> Number {
        assert(array.count > 0)
        return array.popLast()!
    }
    mutating func removeLast() {
        assert(array.count > 0)
        array.removeLast()
    }
    mutating func removeAll() {
        array.removeAll()
    }
    
    var secondLast: Number? {
        if count >= 2 {
            return array[array.count - 2]
        } else {
            return nil
        }
    }
    
    var debugDescription: String {
        var ret = "numberStack \(array.count): "
        for number in array {
            ret += "\(number) "
        }
        return ret
    }
    
}
