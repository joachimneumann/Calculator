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

struct ColoredStepper: View {
    internal init(
        plusEnabled: Bool,
        minusEnabled: Bool,
        onIncrement: @escaping ()->(),
        onDecrement: @escaping ()->()) {
            self.stepperColors = StepperColors(leftBtnColor: .white, rightBtnColor: .white, backgroundColor: .gray)
            self.plusEnabled = plusEnabled
            self.minusEnabled = minusEnabled
            self.onIncrement = onIncrement
            self.onDecrement = onDecrement
        }
    
    private let onIncrement: ()->()
    private let onDecrement: ()->()
    private let stepperColors: StepperColors
    private let plusEnabled: Bool
    private let minusEnabled: Bool
    
    var body: some View {
        HStack {
            Button {
                onDecrement()
            } label: {
            }
            .buttonStyle(StateableButton(change: { state in
                Image(systemName: "minus").frame(width: 38, height: 30)
                .frame(width: 38, height: 30)
                .foregroundColor(minusEnabled ? .white : .gray)
                .background(state || !minusEnabled ? Color(UIColor.darkGray) : .gray)

            }))
            .disabled(!minusEnabled)
            .accessibilityIdentifier("decrementButton")
            
            
            Spacer().frame(width: 2)
            
            Button {
                onIncrement()
            } label: {
            }
            .buttonStyle(StateableButton(change: { state in
                Image(systemName: "plus").frame(width: 38, height: 30)
                .frame(width: 38, height: 30)
                .foregroundColor(plusEnabled ? .white : .gray)
                .background(state || !plusEnabled ? Color(UIColor.darkGray) : .gray)

            }))
            .disabled(!plusEnabled)
            .accessibilityIdentifier("incrementButton")
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        
    }
    
    struct StateableButton<Content>: ButtonStyle where Content: View {
        var change: (Bool) -> Content
        
        func makeBody(configuration: Configuration) -> some View {
            return change(configuration.isPressed)
        }
    }
}
