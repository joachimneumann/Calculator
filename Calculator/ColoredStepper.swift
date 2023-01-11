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
                increment()
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
    
    func decrement() {
        onDecrement?()
    }
    
    func increment() {
        onIncrement?()
    }
}
