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
    @State var warning: String? = nil
    
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
            VStack(alignment: .customCenter, spacing: 0.0) {
                //                Spacer(minLength: 0.0)
                HStack(spacing: 0.0) {
                    Button(action: {
                        showMemoryWarning = false
                        let newPrecision = decreasedPrecision(current: brain.precision)
                        brain.nonWaitingOperation("C")
                        brain.precision = newPrecision
//                        globalGmpSignificantBits = Int( Double(brain.internalPrecision(brain.precision)) * 3.32192809489) /// log2(10)
                        Gmp.deleteConstants()
                    }) {
                        Image(systemName: "minus.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .foregroundColor(brain.precision > 10 ? Color.white : Color.gray)
                    .disabled(brain.precision <= 10)
                    Text("\(formattedInteger(brain.precision)) digits").bold()
                        .padding(.horizontal, 10)
                        .frame(minWidth: 180)
                        .alignmentGuide(.customCenter) {
                          $0[HorizontalAlignment.center]
                        }
                    Button(action: {
                        let newPrecision = increasedPrecision(current: brain.precision)
                        showMemoryWarning = !sufficientMemoryfor(precision: increasedPrecision(current: newPrecision))
                        let newInternalPrecision = Brain.internalPrecision(newPrecision)
                        let numberOfbytes = Int( Double(newInternalPrecision) * 3.32192809489) * 8
                        let testMemoryResult = testMemory(size: numberOfbytes * 10)
                        if testMemoryResult {
                            brain.nonWaitingOperation("C")
                            brain.precision = newPrecision
//                            globalGmpSignificantBits = Int( Double(brain.internalPrecision(brain.precision)) * 3.32192809489) /// log2(10)
                            Gmp.deleteConstants()
                        } else {
                            //                            warning = "Not enough memory for more than \(formattedInteger(brain.precision)) digits"
                        }
                    }) {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .foregroundColor(showMemoryWarning || brain.precision >= 1000000000000000 ? Color.gray : Color.white)
                    .disabled(showMemoryWarning || brain.precision >= 1000000000000000)
                    if showMemoryWarning {
                        Text("Memory Limit Reached")
                            .padding(.leading, 20)
                            .foregroundColor(Color.red)
                    }
                }
                .padding(.top, 20)
//                let speedTestString = brain.speedTestResult != nil ? "speed: \(brain.speedTestResult!)" : "---"
//                Text(speedTestString)
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .padding(.top, 10)
//                    .foregroundColor(Color.red)
//                Text("The app calculates internally with \(globalGmpSignificantBits) bits (corresponding to \(brain.internalPrecision(brain.precision)) digits) to mitigate error accumulation")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                    .padding(.leading, 0)
                Text("Copy & Paste").bold()
                    .padding(.top, 30)
                    .padding(.bottom, 10)
                if copyAndPastePurchased {
                    Text("Use Copy and Paste to import and export numbers with high precision.")
                    Text("You have purchased Copy and Paste")
                        .padding(.top, 20)
                } else {
                    Text("Use Copy and Paste to import and export numbers with high precision. This feature is disabled in the free version.")
                        .frame(maxWidth: .infinity, alignment: .leading)
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

struct CustomCenter: AlignmentID {
  static func defaultValue(in context: ViewDimensions) -> CGFloat {
    context[HorizontalAlignment.center]
  }
}

extension HorizontalAlignment {
  static let customCenter: HorizontalAlignment = .init(CustomCenter.self)
}
