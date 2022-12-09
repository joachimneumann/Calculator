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
    
//    func outOfMemory(for precision: Int) -> Bool {
//        let estimatedSizeOfNumberInBytes = 3*precision // TODO: improve this estimate
//        let estimatedsNumberOfNumbers = 10
//        return !testMemory(size: estimatedSizeOfNumberInBytes * estimatedsNumberOfNumbers)
//    }
    
    @State private var dummyBoolean = true
    @State private var measureButtonText = "measure"
    private let MIN_PRECISION      = 10
    private let MAX_DISPLAY_LENGTH = 10000 // too long strings in Text() crash the app
    private let PHYSICAL_MEMORY = Double(ProcessInfo.processInfo.physicalMemory)
    @ObservedObject var stopWatch = StopWatch()
    
    var body: some View {
        Rectangle()
            .background(Color.black)
            .overlay {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0.0) {
                        HStack {
                            Text("Precision:")
                            ColoredStepper(
                                plusEnabled: !stopWatch.isRunning && Double(model.precision) < PHYSICAL_MEMORY * 0.1,
                                minusEnabled: !stopWatch.isRunning && model.precision > MIN_PRECISION,
                                onIncrement: {
                                    DispatchQueue.main.async {
                                        model.precision = increase(model.precision)
                                    }
                                },
                                onDecrement: {
                                    DispatchQueue.main.async {
                                        model.precision = decrease(model.precision)
                                        if model.longDisplayMax > model.precision {
                                            model.longDisplayMax = model.precision
                                        }
                                    }
                                })
                            .padding(.horizontal, 4)
                            HStack {
                                Text("\(model.precision.useWords) significant digits")
                                if Double(model.precision) >= PHYSICAL_MEMORY * 0.1 {
                                    Text("(memory limit reached)")
                                }
                            }
                            Spacer()
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 5)
                        Text("Note: to mitigate error accumulation calculations are executed with a precision of \(Gmp.bits(for: Gmp.internalPrecision(model.precision))) bits - corresponding to \(Gmp.internalPrecision(model.precision)) digits").italic()
                            .padding(.bottom, 40)
                        HStack {
                            Text("Time to caclulate sin(")
                            let h = 50.0
                            Label(keyInfo: model.keyInfo["√"]!, height: h)
                                .frame(width: h, height: h)
                                .offset(x: -17.0)
                            Text("):")
                                .padding(.leading, -37.0)
                            
                            Button {
                                if !stopWatch.isRunning {
                                    self.stopWatch.start()
                                    Task {
                                        DispatchQueue.main.async {
                                            measureButtonText = ""
                                        }
                                        let result = await model.speedTest(precision: model.precision)
                                        self.stopWatch.stop()
                                        DispatchQueue.main.async {
                                            measureButtonText = result.asTime
                                        }
                                    }
                                }
                            }
                        label: {
                            Text(stopWatch.isRunning && stopWatch.counter > 0 ? "\(stopWatch.counter)" : measureButtonText)
                                .frame(width: 200, height: 40, alignment: .center)
                        }
                        .background(.gray)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .disabled(stopWatch.isRunning)
                        .animation(.easeIn(duration: 0.2), value: measureButtonText)
                            Spacer()
                        }
                        .frame(height: 10)
                        .padding(.bottom, 40)
                        
                        HStack {
                            Text("Max length of display:")
                            ColoredStepper(
                                plusEnabled: !stopWatch.isRunning && model.longDisplayMax < model.precision && model.longDisplayMax < MAX_DISPLAY_LENGTH,
                                minusEnabled: !stopWatch.isRunning && model.longDisplayMax > 10,
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
                        HStack(spacing: 0.0) {
                            Text("Force scientific display")
                            Toggle("", isOn: model.$forceScientific)
                                .foregroundColor(Color.green)
                                .toggleStyle(
                                    ColoredToggleStyle(onColor: Color(uiColor: UIColor(white: 0.6, alpha: 1.0)),
                                                       offColor: Color(uiColor: UIColor(white: 0.3, alpha: 1.0)),
                                                       thumbColor: .white))
                            //                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                            //                        .toggleStyle(SwitchToggleStyle(tint: Color.gray))
                                .frame(width: 70)
                            //                        .background(Color.yellow)
                            Spacer()
                        }
                        .padding(.top, 20)
                        Spacer()
                    }
                    //                        .background(Color.yellow)
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
}

class StopWatch: ObservableObject {
    @Published var counter: Int = 0
    @Published var isRunning = false
    var timer = Timer()
    
    func start() {
        counter = 0
        timer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true) { _ in
                self.counter += 1
            }
        isRunning = true
    }
    func stop() {
        timer.invalidate()
        isRunning = false
    }
    func reset() {
        timer.invalidate()
        counter = 0
        isRunning = false
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

struct ColoredToggleStyle: ToggleStyle {
    var label = ""
    var onColor = Color(UIColor.green)
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Text(label)
            Spacer()
            Button(action: { configuration.isOn.toggle() } )
            {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 50, height: 29)
                    .overlay(
                        Circle()
                            .fill(thumbColor)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(1.5)
                            .offset(x: configuration.isOn ? 10 : -10))
            }
        }
        .font(.title)
        .padding(.horizontal)
    }
}
