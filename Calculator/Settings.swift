//
//  Settings.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/13/22.
//

import SwiftUI

struct Settings: View {
    var model: Model
    
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
    
    @State var settingsPrecision = Model.precision
    @State var settingsForceScientific = Model.forceScientific
    @State var settingsTrigonometricToZero = Model.trigonometricToZero
    @State private var measureButtonText = "measure"
    private let MIN_PRECISION      = 10
    private let PHYSICAL_MEMORY = Double(ProcessInfo.processInfo.physicalMemory)
    @ObservedObject var stopWatch = StopWatch()
    
    var body: some View {
        let bitsInfo = Gmp.bits(for: settingsPrecision)
        let internalPrecisionInfo = Gmp.internalPrecision(for: settingsPrecision)
        Rectangle()
            .background(Color.black)
            .overlay {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0.0) {
                        HStack {
                            Text("Precision:")
                            ColoredStepper(
                                plusEnabled: !stopWatch.isRunning && Gmp.memorySize(bits: bitsInfo) < Int(PHYSICAL_MEMORY * 0.1),
                                minusEnabled: !stopWatch.isRunning && settingsPrecision > MIN_PRECISION,
                                onIncrement: {
                                    DispatchQueue.main.async {
                                        settingsPrecision = increase(settingsPrecision)
                                        measureButtonText = "measure"
                                    }
                                },
                                onDecrement: {
                                    DispatchQueue.main.async {
                                        settingsPrecision = decrease(settingsPrecision)
                                        measureButtonText = "measure"
                                    }
                                })
                            .padding(.horizontal, 4)
                            HStack {
                                Text("\(settingsPrecision.useWords) significant digits")
                                if Gmp.memorySize(bits: bitsInfo) >= Int(PHYSICAL_MEMORY * 0.1) {
                                    Text("(memory limit reached)")
                                }
                            }
                            Spacer()
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 15)
                            Text("Internal precision to mitigate error accumulation: \(internalPrecisionInfo)")
                            .padding(.bottom, 5)
                            .foregroundColor(.gray)
                            Text("Bits used in the gmp and mpfr libraries: \(bitsInfo)")
                            .padding(.bottom, 5)
                            .foregroundColor(.gray)
                            Text("Memory size of one Number: \(Gmp.memorySize(bits: bitsInfo).asMemorySize)")
                            .foregroundColor(.gray)
                            .padding(.bottom, -4)
                        HStack {
                            Text("Time to calculate sin(")
                                .foregroundColor(.gray)
                            let h = 40.0
                            Label(keyInfo: model.keyInfo["√"]!, height: h, color: .gray)
                                .frame(width: h, height: h)
                                .offset(x: -17.0)
                            Text("):")
                                .foregroundColor(.gray)
                                .padding(.leading, -37.0)
                            Button {
                                if !stopWatch.isRunning {
                                    self.stopWatch.start()
                                    Task {
                                        DispatchQueue.main.async {
                                            measureButtonText = "..."
                                        }
                                        let result = await model.speedTest(precision: settingsPrecision)
                                        self.stopWatch.stop()
                                        DispatchQueue.main.async {
                                            measureButtonText = result.asTime
                                        }
                                    }
                                }
                            }
                            label: {
                                Text(stopWatch.isRunning && stopWatch.counter > 0 ? "\(stopWatch.counter)" : measureButtonText)
                                    .foregroundColor(.gray)
                            }
                        }
                        if (settingsPrecision > Number.MAX_DISPLAY_LENGTH) {
                            Text("Note: \(Number.MAX_DISPLAY_LENGTH) digits will be displayed, use copy to get all \(settingsPrecision.useWords) digits").italic()
                            .foregroundColor(.gray)
                        }

                        HStack(spacing: 0.0) {
                            Text("Force scientific display")
                            Toggle("", isOn: $settingsForceScientific)
                                .foregroundColor(Color.green)
                                .toggleStyle(
                                    ColoredToggleStyle(onColor: Color(uiColor: UIColor(white: 0.6, alpha: 1.0)),
                                                       offColor: Color(uiColor: UIColor(white: 0.3, alpha: 1.0)),
                                                       thumbColor: .white))
                                .frame(width: 70)
                            Text(settingsForceScientific ? "e.g. 3,1415926 e0" : "e.g. 3,141592653")
                                .foregroundColor(.gray)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        .padding(.top, 20)

                        HStack(spacing: 0.0) {
                            Text("Force trigonometric results to zero")
                            Toggle("", isOn: $settingsTrigonometricToZero)
                                .foregroundColor(Color.green)
                                .toggleStyle(
                                    ColoredToggleStyle(onColor: Color(uiColor: UIColor(white: 0.6, alpha: 1.0)),
                                                       offColor: Color(uiColor: UIColor(white: 0.3, alpha: 1.0)),
                                                       thumbColor: .white))
                                .frame(width: 70)
                            Text(settingsTrigonometricToZero ? "sin(π) = 0" : "sin(π) = 1e-\(settingsPrecision)")
                                .foregroundColor(.gray)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        .padding(.top, 20)
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                }
                .onDisappear() {
                    if Model.precision != settingsPrecision ||
                        Model.forceScientific != settingsForceScientific ||
                        Model.trigonometricToZero != settingsTrigonometricToZero
                    {
                        Model.precision = settingsPrecision
                        Model.forceScientific = settingsForceScientific
                        Model.trigonometricToZero = settingsTrigonometricToZero
                        model.updatePrecision()
                        model.haveResultCallback()
                    } else {
                        Model.precision = settingsPrecision
                        Model.forceScientific = settingsForceScientific
                        Model.trigonometricToZero = settingsTrigonometricToZero
                        /// no update with haveResultCallback()
                    }
                    ///print("Settings gone...")
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
        Settings(model: Model())
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
