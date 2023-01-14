//
//  Settings.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/13/22.
//

import SwiftUI

struct Settings: View {
    @ObservedObject var viewModel: ViewModel
    @State var timerIsRunning: Bool = false
    private let timerInfoDefault: String = "click to measure"
    @State var timerInfo: String = "click to measure"
    let screen: Screen
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
    
    @Environment(\.presentationMode) var presentation
    @State var settingsPrecision: Int = 0
    @State var settingsForceScientific: Bool = false
    private let MIN_PRECISION      = 10
    private let PHYSICAL_MEMORY = ProcessInfo.processInfo.physicalMemory
    
    var body: some View {
        let bitsInfo = Number.bits(for: settingsPrecision)
        let internalPrecisionInfo = Number.internalPrecision(for: settingsPrecision)
        let sizeOfOneNumber = Gmp.memorySize(bits: bitsInfo)
        let memoryNeeded = sizeOfOneNumber * 100
        VStack {
            HStack {
                Button {
                    if !timerIsRunning {
                        self.presentation.wrappedValue.dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: screen.infoUiFontSize * 0.7)
                        .padding(.trailing, screen.infoUiFontSize * 0.1)
                    Text("Back")
                }
                Spacer()
            }
            .font(font)
            .foregroundColor(timerIsRunning ? .gray : .white)
            .padding()
            ScrollView {
                VStack(alignment: .leading, spacing: 0.0) {
                    HStack {
                        Text("Precision:")
                            .foregroundColor(timerIsRunning ? .gray : .white)
                        ColoredStepper(
                            plusEnabled: !timerIsRunning && memoryNeeded < PHYSICAL_MEMORY,
                            minusEnabled: !timerIsRunning && settingsPrecision > MIN_PRECISION,
                            height: 30,
                            onIncrement: {
                                Task {
                                    await MainActor.run() {
                                        settingsPrecision = increase(settingsPrecision)
                                        timerInfo = timerInfoDefault
                                    }
                                }
                            },
                            onDecrement: {
                                Task {
                                    await MainActor.run() {
                                        settingsPrecision = decrease(settingsPrecision)
                                        timerInfo = timerInfoDefault
                                    }
                                }
                            })
                        .padding(.horizontal, 4)
                        HStack {
                            Text("\(settingsPrecision.useWords) significant digits")
                                .foregroundColor(timerIsRunning ? .gray : .white)
                            if memoryNeeded >= PHYSICAL_MEMORY {
                                Text("(memory limit reached)")
                                    .foregroundColor(timerIsRunning ? .gray : .white)
                            }
                        }
                        Spacer()
                    }
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
                        let h = 3 * screen.infoUiFontSize
                        Label(symbol: "√", size: h, color: .gray)
                            .frame(width: h, height: h)
                            .offset(x: -1.2 * screen.infoUiFontSize)
                        Text("):")
                            .foregroundColor(.gray)
                            .offset(x: -2.4 * screen.infoUiFontSize)
                        Button {
                            timerIsRunning = true
                            Task.detached {
                                let speedTestBrain = await DebugBrain(precision: settingsPrecision, lengths: Lengths(0))
                                let result = await speedTestBrain.speedTest()
                                await MainActor.run() {
                                    timerInfo = result
                                    timerIsRunning = false
                                }
                            }
                        } label: {
                            if timerIsRunning {
                                Text("...measuring")
                                    .foregroundColor(.white)
                            } else {
                                Text(timerInfo)
                                    .foregroundColor(.gray)
                            }
                        }
                        .disabled(timerIsRunning)
                        .offset(x: -2.0 * screen.infoUiFontSize)
                    }
                    .offset(y: -0.15 * screen.infoUiFontSize)

                    HStack(spacing: 0.0) {
                        Text("Force scientific display")
                            .foregroundColor(timerIsRunning ? .gray : .white)
                        Toggle("", isOn: $settingsForceScientific)
                            .foregroundColor(Color.green)
                            .toggleStyle(
                                ColoredToggleStyle(onColor: Color(UIColor(white: timerIsRunning ? 0.4 : 0.6, alpha: 1.0)),
                                                   offColor: Color(UIColor(white: 0.3, alpha: 1.0)),
                                                   thumbColor: timerIsRunning ? .gray : .white))
                            .frame(width: 70)
                            .disabled(timerIsRunning)
                        Text(settingsForceScientific ? "e.g. 3,1415926 e0" : "e.g. 3,141592653")
                            .foregroundColor(.gray)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    .padding(.top, 20)

                    Spacer()
                }
                .font(font)
                .foregroundColor(Color.white)
            }
            .padding()
            .onDisappear() {
                if viewModel.forceScientific != settingsForceScientific {
                    viewModel.forceScientific = settingsForceScientific
                }
                if viewModel.precision != settingsPrecision {
                    Task {
                        await viewModel.updatePrecision(to: settingsPrecision)
                    }
                }
                Task {
                    await viewModel.refreshDisplay(screen: screen)
                }
            }
        }
        .onAppear() {
            settingsForceScientific = viewModel.forceScientific
            settingsPrecision       = viewModel.precision
        }
        .navigationBarBackButtonHidden(true)
    }
    

    //    struct ControlCenter_Previews: PreviewProvider {
    //        static var previews: some View {
    //            Settings(viewModel: ViewModel(), font: Font(UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .light)))
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

private extension Int {
    var asMemorySize: String {
        let d = Double(self)
        if d > 1e9 {
            return String(format: "%.1fGB", d / 1e9)
        }
        if d > 1e6 {
            return String(format: "%.1fMB", d / 1e6)
        }
        if d > 1e3 {
            return String(format: "%.1fKB", d / 1e3)
        }
        return String(format: "%.0f bytes", d)
    }
}
