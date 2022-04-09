//
//  NumberOfCharactersModel.swift
//  Calculator
//
//  Created by joachim on 5/4/22.
//

import SwiftUI

struct NumberOfCharactersInfo {
    let len: Int
    let height: Float
}

class NumberOfCharactersModel: ObservableObject {
    @Published var numberOfCharacters: Int? = nil
    @Published var calibrated = false
    let N = 40
    private var candidate: Int = 0
    private var infos: [NumberOfCharactersInfo] = []
    var minHeight = Float.greatestFiniteMagnitude
    var maxLen = 0
    func info(_ info: NumberOfCharactersInfo) {
        infos.append(info)
        for info in infos {
            if info.height < minHeight {
                //print("smaller height!")
                minHeight = info.height
                maxLen = 0
                if info.len > maxLen {
                    maxLen = info.len
                    numberOfCharacters = info.len
                }
            }
        }
        //print("NumberOfCharactersModel new info \(info.len) \(info.height) -> \(Self.maxLen) \(Self.minHeight)")
        if infos.count == N {
            calibrated = true
            print("NumberOfCharactersModel calibrated \(numberOfCharacters!) \(calibrated ? "Y" : "N")")
        }
    }
    init() {
        print("NumberOfCharactersModel INIT()")
        calibrated = false
    }
}
