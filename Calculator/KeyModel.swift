//
//  KeyModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/23/22.
//

import SwiftUI

enum KeyType {
    case digit
}
class KeyModel: ObservableObject {
    @Published var colors : KeyColors
    
    init(type: KeyType) {
        colors = digitColors
    }
    
    private let digitColors = KeyColors(
        textColor: UIColor(.white),
        upColor:   UIColor(white: 0.2, alpha: 1.0),
        downColor: UIColor(white: 0.4, alpha: 1.0))
    private let disabledDigitColors = KeyColors(
        textColor: UIColor(.white),
        upColor:   UIColor(red: 0.4, green: 0.2, blue: 0.2, alpha: 1.0),
        downColor: UIColor(red: 0.4, green: 0.2, blue: 0.2, alpha: 1.0))
    private let operatorColors = KeyColors(
        textColor: UIColor(.white),
        upColor:   UIColor(white: 0.5, alpha: 1.0),
        downColor: UIColor(white: 0.7, alpha: 1.0))
    private let pendingOperatorColors = KeyColors(
        textColor: UIColor(white: 0.5, alpha: 1.0),
        upColor:   UIColor(white: 0.9, alpha: 1.0),
        downColor: UIColor(white: 0.8, alpha: 1.0))
    private let scientificColors = KeyColors(
        textColor: UIColor(.white),
        upColor:   UIColor(white: 0.12, alpha: 1.0),
        downColor: UIColor(white: 0.32, alpha: 1.0))
    private let pendingScientificColors = KeyColors(
        textColor: UIColor(white: 0.3, alpha: 1.0),
        upColor:   UIColor(white: 0.7, alpha: 1.0),
        downColor: UIColor(white: 0.6, alpha: 1.0))
}
