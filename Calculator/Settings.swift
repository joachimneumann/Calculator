//
//  Settings.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/13/22.
//

import SwiftUI

struct Settings: View {
    var model: Model
    let font: Font
    
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
    static let measureButtonDefault = "click to measure"
    @State private var measureButtonText = Settings.measureButtonDefault
    private let MIN_PRECISION      = 10
    private let PHYSICAL_MEMORY = ProcessInfo.processInfo.physicalMemory
//    @ObservedObject var stopWatch = StopWatch()
    
    var body: some View {
        Text("settings")
        let bitsInfo = Gmp.bits(for: settingsPrecision)
        let internalPrecisionInfo = Gmp.internalPrecision(for: settingsPrecision)
        let sizeOfOneNumber = Gmp.memorySize(bits: bitsInfo)
        let memoryNeeded = sizeOfOneNumber * 40
        ScrollView {
            VStack(alignment: .leading, spacing: 0.0) {
                HStack {
                    Text("Precision:")
                    ColoredStepper(
                        plusEnabled: true,//!stopWatch.isRunning && memoryNeeded < PHYSICAL_MEMORY,
                        minusEnabled: true,//!stopWatch.isRunning && settingsPrecision > MIN_PRECISION,
                        onIncrement: {
                            DispatchQueue.main.async {
                                settingsPrecision = increase(settingsPrecision)
                                measureButtonText = Settings.measureButtonDefault
                            }
                        },
                        onDecrement: {
                            DispatchQueue.main.async {
                                settingsPrecision = decrease(settingsPrecision)
                                measureButtonText = Settings.measureButtonDefault
                            }
                        })
                    .padding(.horizontal, 4)
                    HStack {
                        Text("\(settingsPrecision.useWords) significant digits")
                        if memoryNeeded >= PHYSICAL_MEMORY {
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
                let more = (settingsPrecision > Number.MAX_DISPLAY_LENGTH)
                Text("\(more ? "Maximal n" : "N")umber of digits in the display: \(min(settingsPrecision, Number.MAX_DISPLAY_LENGTH)) \(more ? "(copy fetches all \(settingsPrecision.useWords) digits)" : " ")")
                    .padding(.bottom, 5)
                    .foregroundColor(.gray)
                Text("Memory size of one Number: \(sizeOfOneNumber.asMemorySize)")
                    .foregroundColor(.gray)
                    .padding(.bottom, -4)
                HStack {
                    Text("Time to calculate sin(")
                        .foregroundColor(.gray)
                    let h = 40.0
                    Label(keyInfo: model.keyInfo["√"]!, size: h, color: .gray)
                        .frame(width: h, height: h)
                        .offset(x: -17.0)
                    Text("):")
                        .foregroundColor(.gray)
                        .padding(.leading, -37.0)
                    Button {
//                        if !stopWatch.isRunning {
//                            self.stopWatch.start()
//                            Task {
//                                DispatchQueue.main.async {
//                                    measureButtonText = "..."
//                                }
//                                let result = await model.speedTest(precision: settingsPrecision)
//                                self.stopWatch.stop()
//                                DispatchQueue.main.async {
//                                    measureButtonText = result.asTime
//                                }
//                            }
//                        }
                    } label: {
//                        Text(stopWatch.isRunning && stopWatch.counter > 0 ? "\(stopWatch.counter)" : measureButtonText)
                        Text(measureButtonText)
                            .foregroundColor(.gray)
                    }
                }

                Spacer()
            }
            .font(font)
            .foregroundColor(Color.white)
        }
        .onAppear() {
            model.hideKeyboard = true
        }
        .onDisappear() {
            model.hideKeyboard = false
            if Model.precision != settingsPrecision {
                model.updatePrecision(to: settingsPrecision)
            }
            model.haveResultCallback()
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
    
//    struct ControlCenter_Previews: PreviewProvider {
//        static var previews: some View {
//            Settings(model: Model(), font: Font(UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .light)))
//        }
//    }
    
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
    
}
