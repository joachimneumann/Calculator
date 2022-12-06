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
    
    func decrease(_ current: Int) -> Int {
        let asString = "\(current)"
        if asString.starts(with: "2") {
            return current / 2
        } else if asString.starts(with: "5") {
            return (current / 5) * 2
        } else {
            return (current / 10) * 5
        }
    }
    func increase(_ current: Int) -> Int {
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
    private let MIN_PRECISION = 10
    private let MAX_PRECISION = 1000000000000 /// one trillion
    var body: some View {
        var nextIncrement: Int = 0
        ZStack {
            Color.black
            VStack(alignment: .leading, spacing: 0.0) {
                HStack {
                    Text("Precision:")
                    ColoredStepper(
                        plusEnabled: !outOfMemory && model.precision < MAX_PRECISION,
                        minusEnabled: model.precision > MIN_PRECISION,
                        onIncrement: {
                            DispatchQueue.main.async {
                                model.precision = increase(model.precision)
                                nextIncrement = increase(model.precision)
                                outOfMemory = outOfMemory(for: Brain.internalPrecision(nextIncrement))
                            }
                        },
                        onDecrement: {
                            DispatchQueue.main.async {
                                outOfMemory = false
                                nextIncrement = 0
                                model.precision = decrease(model.precision)
                                if model.longDisplayMax > model.precision {
                                    model.longDisplayMax = model.precision
                                }
                            }
                        })
                    .padding(.horizontal, 4)
                    HStack {
                        Text("\(model.precision.useWords) digits")
                        if outOfMemory {
                            Text("(memory limit reached)")
                        } else {
                            if model.precision == MAX_PRECISION {
                                Text("(sorry, that all I got)")
                            }
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
                Text("To mitigate error accumulation calculations are executed with a precision of \(model.bits) bits - corresponding to \(Brain.internalPrecision(model.precision)) digits").italic()
                    .padding(.bottom, 40)

                HStack {
                    Text("Max length of display:")
                    ColoredStepper(
                        plusEnabled: model.longDisplayMax < model.precision,
                        minusEnabled: model.longDisplayMax > 10,
                        onIncrement: {
                            DispatchQueue.main.async {
                                model.longDisplayMax = increase(model.longDisplayMax)
                            }
                        },
                        onDecrement: {
                            DispatchQueue.main.async {
                                model.longDisplayMax = decrease(model.longDisplayMax)
                            }
                        })
                    .padding(.horizontal, 4)
                    Text("\(model.longDisplayMax.useWords) digits")
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
