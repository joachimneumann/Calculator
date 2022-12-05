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
    
    func outOfMemory(for precision: Int) -> Bool {
        let estimatedSizeOfNumberInBytes = 3*precision // TODO: improve this estimate
        let estimatedsNumberOfNumbers = 10
        return !testMemory(size: estimatedSizeOfNumberInBytes * estimatedsNumberOfNumbers)
    }
    
    @State var outOfMemory = false

    var body: some View {
        ZStack {
            Color.black
            VStack(alignment: .leading, spacing: 0.0) {
                HStack {
                    Text("Precision:")
                    ColoredStepper(
                        plusEnabled: !outOfMemory,
                        minusEnabled: model.precision > 10,
                        onIncrement: {
                            model.pressed("AC")
                            model.setPrecision(increasedPrecision(current: model.precision))
                            let nextIncrement = increasedPrecision(current: model.precision)
                            outOfMemory = outOfMemory(for: Brain.internalPrecision(nextIncrement))
                        },
                        onDecrement: {
                            outOfMemory = false
                            model.pressed("AC")
                            model.setPrecision(decreasedPrecision(current: model.precision))
                        })
                    .padding(.horizontal, 4)
                    HStack {
                        Text("\(model.precision.useWords) digits")
                        if outOfMemory {
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
                Text("The app calculates internally with \(model.bits) bits (corresponding to \(        Brain.internalPrecision(model.precision).useWords) digits) to mitigate error accumulation").italic()
                    .padding(.bottom, 40)

                HStack {
                    Text("Max length of display:")
                    ColoredStepper(
                        plusEnabled: true,
                        minusEnabled: model.precision > 10,
                        onIncrement: {
                        },
                        onDecrement: {
                        })
                    .padding(.horizontal, 4)
                    Text("digits")
                }

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
