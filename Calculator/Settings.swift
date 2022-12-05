//
//  Settings.swift
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

struct Settings: View {
    var model: Model
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
                    Text("Precision:")
                    ColoredStepper(
                        plusEnabled: !showMemoryWarning,
                        minusEnabled: model.precision > 10,
                        onIncrement: {
//                            let newPrecision = increasedPrecision(current: brain.precision)
//                            showMemoryWarning = !sufficientMemoryfor(precision: increasedPrecision(current: newPrecision))
//                            let newInternalPrecision = Brain.internalPrecision(newPrecision)
//                            let numberOfbytes = Int( Double(newInternalPrecision) * 3.32192809489) * 8
//                            let testMemoryResult = testMemory(size: numberOfbytes * 10)
//                            if testMemoryResult {
//                                model.pressed("AC")
////                                brain.setPrecision(newPrecision)
//                            }
                        },
                        onDecrement: {
                            showMemoryWarning = false
//                            let newPrecision = decreasedPrecision(current: brain.precision)
                            model.pressed("AC")
//                            brain.setPrecision(newPrecision)
                        })
                    .padding(.horizontal, 10)
                    HStack {
                        Text("\(model.precision.useWords) digits")
                        if showMemoryWarning {
                            Text("(memory limit reached)")
                        }
//                        if let speed = brain.speed {
//                            if speed.precision == brain.precision {
//                                Text("speed: \(speed.sqrt2Time)s \(speed.precision.useWords)")
//                            }
//                        }
                    }
                    Spacer()
                }
                .padding(.top, 40)
                .padding(.bottom, 5)
                Text("The app calculates internally with model.bits bits (corresponding to model.internalPrecision digits) to mitigate error accumulation").italic()
                    .padding(.bottom, 40)
                if copyAndPastePurchased {
                    Text("You have purchased Copy and Paste to import and export numbers with high precision.")
                } else {
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
                    .padding(.bottom, 5)
                    Text("Copy and Paste allows you to import and export numbers with high precision. This feature is disabled in the free version.").italic()
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
        Settings(model: Model(), copyAndPastePurchased: .constant(false))
    }
}
