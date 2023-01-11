//
//  ColoredStepper.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/16/22.
//

import SwiftUI

struct StepperColors{
    let leftBtnColor: Color
    let rightBtnColor: Color
    let backgroundColor: Color
}

typealias CallBack = ( ()->() )?
struct ColoredStepper: View {
    internal init(
        plusEnabled: Bool,
        minusEnabled: Bool,
        onIncrement: CallBack,
        onDecrement: CallBack) {
            self.stepperColors = StepperColors(leftBtnColor: .white, rightBtnColor: .white, backgroundColor: .gray)
            self.plusEnabled = plusEnabled
            self.minusEnabled = minusEnabled
            self.onIncrement = onIncrement
            self.onDecrement = onDecrement
        }
    
    private let onIncrement: CallBack
    private let onDecrement: CallBack
    private let stepperColors: StepperColors
    private let plusEnabled: Bool
    private let minusEnabled: Bool
    
    var body: some View {
        HStack {
            Button {
                decrement()
            } label: {
                Image(systemName: "minus").frame(width: 38, height: 30)
            }
            .disabled(!minusEnabled)
            .foregroundColor(minusEnabled ? stepperColors.leftBtnColor : Color.gray)
            .background(minusEnabled ? stepperColors.backgroundColor : Color(UIColor.darkGray))
            .accessibilityIdentifier("decrementButton")
            
            Spacer().frame(width: 2)
            
            Button {
                increment()
            } label: {
                Image(systemName: "plus").frame(width: 38, height: 30)
            }
            .disabled(!plusEnabled)
            .foregroundColor(plusEnabled ? stepperColors.rightBtnColor : Color.gray)
            .background(plusEnabled ? stepperColors.backgroundColor : Color(UIColor.darkGray))
            .accessibilityIdentifier("incrementButton")
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        
    }
    
    func decrement() {
        onDecrement?()
    }
    
    func increment() {
        onIncrement?()
    }
}
