//
//  ControlCenter.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/13/22.
//

import SwiftUI

extension String {
    func replacingFirstOccurrence(of target: String, with replacement: String) -> String {
        guard let range = self.range(of: target) else { return self }
        return self.replacingCharacters(in: range, with: replacement)
    }
}

func formattedInteger(_ n: Int) -> String {
    let ret = "\(n)"
    if ret.hasSuffix("000000000000") {
        var substring1 = ret.dropLast(12)
        substring1 = substring1 + " trillion"
        return String(substring1)
    }
    if ret.hasSuffix("000000000") {
        var substring1 = ret.dropLast(9)
        substring1 = substring1 + " billion"
        return String(substring1)
    }
    if ret.hasSuffix("000000") {
        var substring1 = ret.dropLast(6)
        substring1 = substring1 + " million"
        return String(substring1)
    }
    if ret.hasSuffix("000") {
        var substring1 = ret.dropLast(3)
        substring1 = substring1 + " thousand"
        return String(substring1)
    }
    return ret
}

struct ControlCenter: View {
    @ObservedObject var brain: Brain
    @Binding var copyAndPastePurchased: Bool
    @State var warning: String?
    
    func decreasedPrecision(current: Int) -> Int {
        let asString = "\(current)"
        if asString.starts(with: "2") {
            return current / 2
        } else if asString.starts(with: "5") {
            return (current / 5) * 2
        } else {
            return (current / 10) * 5
        }
    }
    func increasedPrecision(current: Int) -> Int {
        let asString = "\(current)"
        if asString.starts(with: "2") {
            return (current / 2) * 5
        } else if asString.starts(with: "5") {
            return (current / 5) * 10
        } else {
            return current * 2
        }
    }
    func sufficientMemoryfor(precision: Int) -> Bool {
        let needToAppocateNumbers = 10 // estimate for internal calculations
        let numberOfbytes = Int(Double(precision) * 3.32192809489) * 8
        return testMemory(size: numberOfbytes * needToAppocateNumbers)
    }
        
    @State var showMemoryWarning = false
    
    var body: some View {
        ZStack {
            Color.black
            VStack(alignment: .leading, spacing: 0.0) {
                HStack {
                    Text("Presicion:")
                    ColoredStepper(
                        plusEnabled: !showMemoryWarning,
                        onIncrement: {
                            let newPrecision = increasedPrecision(current: brain.precision)
                            showMemoryWarning = !sufficientMemoryfor(precision: increasedPrecision(current: newPrecision))
                            let newInternalPrecision = Brain.internalPrecision(newPrecision)
                            let numberOfbytes = Int( Double(newInternalPrecision) * 3.32192809489) * 8
                            let testMemoryResult = testMemory(size: numberOfbytes * 10)
                            if testMemoryResult {
                                brain.nonWaitingOperation("C")
                                brain.setPrecision(newPrecision)
                                Gmp.deleteConstants()
                            }
                        },
                        onDecrement: {
                            showMemoryWarning = false
                            let newPrecision = decreasedPrecision(current: brain.precision)
                            brain.nonWaitingOperation("C")
                            brain.setPrecision(newPrecision)
                            Gmp.deleteConstants()
                        })
                    .padding(.horizontal, 10)
                    let text = showMemoryWarning ?
                    "\(formattedInteger(brain.precision)) digits (memory limit reached)" :
                    "\(formattedInteger(brain.precision)) digits"
                    Text(text)
                    Spacer()
                }
                .padding(.top, 40)
                .padding(.bottom, 5)
                Text("The app calculates internally with \(brain.bits) bits (corresponding to \(Brain.internalPrecision(brain.precision)) digits) to mitigate error accumulation").italic()
                    .padding(.bottom, 40)
                if copyAndPastePurchased {
                    Text("You have purchased Copy and Paste to import and export numbers with high precision.")
                } else {
                    Text("Use Copy and Paste to import and export numbers with high precision. This feature is disabled in the free version.")
                    HStack {
                        Text("Purchase Copy and Paste")
                            .padding(.trailing, 20)
                        Button {
                            copyAndPastePurchased = true
                        }
                    label: {
                        Text("$0.99")
                            .frame(height: 10)
                    }
                    .buttonStyle(BuyButton())
                    }
                    .padding(.top, 20)
                }
                Spacer()
            }
            //            .background(Color.yellow)
            .foregroundColor(Color.white)
        }
        .onAppear() {
            AppDelegate.forceLandscape = true
        }
        .onDisappear() {
            AppDelegate.forceLandscape = false
        }
    }
}

struct BuyButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.padding()
            .background(.gray)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
struct ControlCenter_Previews: PreviewProvider {
    static var previews: some View {
        ControlCenter(brain: Brain(precision: 100), copyAndPastePurchased: .constant(false))
    }
}

struct StepperColors{
    let leftBtnColor: Color
    let rightBtnColor: Color
    let backgroundColor: Color
}

typealias CallBack = ( ()->() )?
struct ColoredStepper: View {
    internal init(
        plusEnabled: Bool,
        onIncrement: CallBack,
        onDecrement: CallBack) {
            self.stepperColors = StepperColors(leftBtnColor: .white, rightBtnColor: .white, backgroundColor: .gray)
            self.plusEnabled = plusEnabled
            self.onIncrement = onIncrement
            self.onDecrement = onDecrement
        }
    
    private let onIncrement: CallBack
    private let onDecrement: CallBack
    private let stepperColors: StepperColors
    private let plusEnabled: Bool
    
    var body: some View {
        HStack {
            Button {
                decrement()
            } label: {
                Image(systemName: "minus")
                    .frame(width: 38, height: 35)
            }
            .foregroundColor(stepperColors.leftBtnColor)
            .background(stepperColors.backgroundColor)
            
            Spacer().frame(width: 2)
            
            Button {
                increment()
            } label: {
                Image(systemName: "plus")
                    .frame(width: 38, height: 35)
            }
            .disabled(!plusEnabled)
            .foregroundColor(plusEnabled ? stepperColors.rightBtnColor : Color.gray)
            .background(plusEnabled ? stepperColors.backgroundColor : Color(UIColor.darkGray))
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

//                let speedTestString = brain.speedTestResult != nil ? "speed: \(brain.speedTestResult!)" : "---"
//                Text(speedTestString)
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .padding(.top, 10)
//                    .foregroundColor(Color.red)
//                Text("The app calculates internally with \(globalGmpSignificantBits) bits (corresponding to \(brain.internalPrecision(brain.precision)) digits) to mitigate error accumulation")
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.top, 10)
//                .padding(.leading, 0)
