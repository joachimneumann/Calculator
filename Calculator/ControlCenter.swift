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
    var body: some View {
        ZStack {
            Color.black
            VStack(spacing: 0.0) {
//                Spacer(minLength: 0.0)
                HStack(spacing: 0.0) {
                    Button(action: {
                        if "\(brain.precision)".starts(with: "2") {
                            brain.precision /= 2
                        } else if "\(brain.precision)".starts(with: "5") {
                            brain.precision /= 5
                            brain.precision *= 2
                        } else {
                            brain.precision /= 10
                            brain.precision *= 5
                        }
                        brain.calculateSignificantBits()
                        Gmp.deleteConstants()
                        brain.nonWaitingOperation("C")
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
                    Button(action: {
                        if "\(brain.precision)".starts(with: "2") {
                            brain.precision /= 2
                            brain.precision *= 5
                        } else if "\(brain.precision)".starts(with: "5") {
                            brain.precision /= 5
                            brain.precision *= 10
                        } else {
                            brain.precision *= 2
                        }
                        brain.calculateSignificantBits()
                        Gmp.deleteConstants()
                        brain.nonWaitingOperation("C")
                    }) {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .foregroundColor(brain.precision < 1000000000000000 ? Color.white : Color.gray)
                    .disabled(brain.precision >= 1000000000000000)
                }
                .padding(.top, 20)
                if brain.precision >= 100000 {
                    Text("Warning: processing might be slow and the app may crash!")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 10)
                        .foregroundColor(Color.red)
                }
                Text("The app calculats internally with \(globalGmpSignificantBits) bits (corresponding to \(globalGmpPrecision) digits) to reduce the effect of error accumulation")
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
        ControlCenter(brain: Brain(), copyAndPastePurchased: .constant(false))
    }
}
