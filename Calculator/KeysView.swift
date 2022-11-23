//
//  KeysView.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct KeysView: View {
    let calculatorModel: CalculatorModel
    let isScientific: Bool
    let size: CGSize
    //    if !t.isPad && t.isPortrait {
    //        bottomPadding = t.allkeysHeight * 0.07
    //    } else {
    //        bottomPadding = 0
    //    }
    
    var body: some View {
        Group {
            if isScientific {
                HStack(spacing: 0.0) {
                    let space = CalculatorModel.spaceBetweenkeysFraction(withScientificKeys: true) * size.width
                    let keyWidth = (1.0 * size.width - 9.0 * space) / 10.0
                    let leftWidth = 6 * keyWidth + 5 * space
                    let rightWidth = 4 * keyWidth + 3 * space
                    let sizeLeft  = CGSize(width: leftWidth, height: size.height)
                    let sizeRight = CGSize(width: rightWidth, height: size.height)
                    ScientificKeys(calculatorModel: calculatorModel, spaceBetweenKeys: space, size: sizeLeft)
                        .padding(.trailing, space)
                    NonScientificKeys(calculatorModel: calculatorModel, spaceBetweenKeys: space, size: sizeRight)
                }
            } else {
                let space = CalculatorModel.spaceBetweenkeysFraction(withScientificKeys: false) * size.width
                NonScientificKeys(calculatorModel: calculatorModel, spaceBetweenKeys: space, size: size)
            }
        }
        .transition(.move(edge: .bottom))
    }
}

struct KeysView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            KeysView(calculatorModel: CalculatorModel(), isScientific: false, size: CGSize(width: 100, height: 100))
            KeysView(calculatorModel: CalculatorModel(), isScientific: false, size: CGSize(width: 400, height: 400))
        }
    }
}
