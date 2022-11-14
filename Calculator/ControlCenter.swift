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
            VStack {
                HStack {
                    Button(action: {
                        if "\(brain.precision)".starts(with: "3") {
                            brain.precision /= 3
                        } else {
                            brain.precision /= 10
                            brain.precision *= 3
                        }
                        brain.calculateSignificantBits()
                        Gmp.deleteConstants()
                        brain.nonWaitingOperation("C")
                    }) {
                        Image(systemName: "minus.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .foregroundColor(brain.precision > 100 ? Color.white : Color.gray)
                    .disabled(brain.precision <= 100)
                    Text("\(formattedInteger(brain.precision)) digits").bold()
                        .padding(.horizontal, 10)
                        .frame(minWidth: 180)
                    Button(action: {
                        if "\(brain.precision)".starts(with: "3") {
                            brain.precision /= 3
                            brain.precision *= 10
                        } else {
                            brain.precision *= 3
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
                    Text("Warning: processing might be slow and you might experience out of memory problems including app crashes!")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 5)
                        .foregroundColor(Color.red)
                }
                Text("The app calculats internally with \(globalGmpSignificantBits) bits (corresponding to \(globalGmpPrecision) digits) to reduce the effect of error accumulation")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                    .foregroundColor(Color.white)
                Text("Copy & Paste").bold()
                    .padding(.vertical, 10)
                if copyAndPastePurchased {
                    Text("You have purchased this feature and can use Copy and Paste to import and export numbers with high precision")
                } else {
                    Text("This is disabled in the free version.")
                        .padding(.bottom, 10)
                    Button("Purchase this feature ($0.99) to import and export numbers with high precision.") {
                        copyAndPastePurchased = true
                    }
                }
                Spacer()
            }
            .foregroundColor(Color.white)
        }
    }
}

struct ControlCenter_Previews: PreviewProvider {
    static var previews: some View {
        ControlCenter(brain: Brain(), copyAndPastePurchased: .constant(false))
    }
}
