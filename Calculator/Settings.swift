//
//  Settings.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/13/22.
//

import SwiftUI

struct Settings: View {
    @Environment(\.presentationMode) var presentation /// for dismissing the screen

    @ObservedObject var viewModel: ViewModel
    @ObservedObject var screen: Screen
    let font: Font


    @State var timerIsRunning: Bool = false
    @State var settingsPrecision: Int = 0
    @State var settingsForceScientific: Bool = false
    @State var timerInfo: String = "click to measure"

    
    var body: some View {
        VStack {
            BackButton(
                timerIsRunning: timerIsRunning,
                screen: screen,
                font: font,
                presentationMode: presentation)
            ScrollView {
                VStack(alignment: .leading, spacing: 0.0) {
                    let bitsInfo = Number.bits(for: settingsPrecision)
                    let sizeOfOneNumber = Gmp.memorySize(bits: bitsInfo)
                    Precision(
                        timerIsRunning: timerIsRunning,
                        settingsPrecision: $settingsPrecision,
                        timerInfo: $timerInfo,
                        bitsInfo: bitsInfo,
                        sizeOfOneNumber: sizeOfOneNumber,
                        memoryNeeded: sizeOfOneNumber * 100,
                        internalPrecisionInfo: Number.internalPrecision(for: settingsPrecision))
                    
                    Measurement(timerIsRunning: $timerIsRunning,
                                timerInfo: $timerInfo,
                                screen: screen,
                                settingsPrecision: settingsPrecision)
                    
                    ForceScientificDisplay(
                        timerIsRunning: timerIsRunning,
                        settingsForceScientific: $settingsForceScientific)
                    .padding(.top, 20)
                    
                    DecimalSeparator(
                        timerIsRunning: timerIsRunning,
                        decimalSeparatorCase: $screen.decimalSeparatorCase,
                        thousandSeparatorCase: $screen.thousandSeparatorCase,
                        screen: screen
                    )
                    .padding(.top, 20)

                    ThousandsSeparator(
                        timerIsRunning: timerIsRunning,
                        decimalSeparatorCase: $screen.decimalSeparatorCase,
                        thousandSeparatorCase: $screen.thousandSeparatorCase,
                        screen: screen
                    )
                    .padding(.top, 20)

                    
                    HStack(spacing: 20.0) {
                        Text("HidePreliminaryResults")
                            .foregroundColor(timerIsRunning ? .gray : .white)
                        Toggle("", isOn: $settingsForceScientific)
                            .foregroundColor(Color.green)
                            .toggleStyle(
                                ColoredToggleStyle(onColor: Color(UIColor(white: timerIsRunning ? 0.4 : 0.6, alpha: 1.0)),
                                                   offColor: Color(UIColor(white: 0.3, alpha: 1.0)),
                                                   thumbColor: timerIsRunning ? .gray : .white))
                            .frame(width: 70)
                            .disabled(timerIsRunning)
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
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(white: 0.7, alpha: 1.0)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        }
        .navigationBarBackButtonHidden(true)
    }

    struct Precision: View {
        let timerIsRunning: Bool
        @Binding var settingsPrecision: Int
        @Binding var timerInfo: String
        let bitsInfo: Int
        let sizeOfOneNumber: Int
        let memoryNeeded: Int
        let internalPrecisionInfo: Int
        private let PHYSICAL_MEMORY = ProcessInfo.processInfo.physicalMemory
        private let MIN_PRECISION   = 10
        private let timerInfoDefault: String = "click to measure"
        var body: some View {
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
        }
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

    }

    struct Measurement: View {
        @Binding var timerIsRunning: Bool
        @Binding var timerInfo: String
        let screen: Screen
        let settingsPrecision: Int
        var body: some View {
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
                        let speedTestBrain = DebugBrain(precision: settingsPrecision, lengths: Lengths(0))
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
        }
    }
    struct BackButton: View {
        let timerIsRunning: Bool
        let screen: Screen
        let font: Font
        let presentationMode: Binding<PresentationMode>
        var body: some View {
            HStack {
                Button {
                    if !timerIsRunning {
                        presentationMode.wrappedValue.dismiss()
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
        }
    }
    
    struct ForceScientificDisplay: View {
        let timerIsRunning: Bool
        @Binding var settingsForceScientific: Bool
        var body: some View {
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

        }
    }
    struct DecimalSeparator: View {
        let timerIsRunning: Bool
        @Binding var decimalSeparatorCase: Int
        @Binding var thousandSeparatorCase: Int
        let screen: Screen
        var body: some View {
            HStack(spacing: 20.0) {
                Text("Decimal separator")
                    .foregroundColor(timerIsRunning ? .gray : .white)
                Picker("", selection: $decimalSeparatorCase) {
                    Text("Comma").tag(0)
                    Text("Dot").tag(1)
                }
                .onChange(of: screen.decimalSeparatorCase) { _ in
                    if screen.decimalSeparatorCase == 0 { /// comma
                        if screen.thousandSeparatorCase == 1 { /// also comma
                            screen.thousandSeparatorCase = 2
                        }
                    } else {
                        /// decimalSeparator is dot
                        if screen.thousandSeparatorCase == 2 { /// also dot
                            screen.thousandSeparatorCase = 1
                        }
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 160)
                Text("3\(screen.decimalSeparator)14159")
                    .foregroundColor(.gray)
                    .padding(.leading, 20)
                Spacer()
            }
        }
    }
    
    struct ThousandsSeparator: View {
        let timerIsRunning: Bool
        @Binding var decimalSeparatorCase: Int
        @Binding var thousandSeparatorCase: Int
        let screen: Screen
        var body: some View {
            HStack(spacing: 20.0) {
                Text("Thousand separator")
                    .foregroundColor(timerIsRunning ? .gray : .white)
                Picker("Thousand separator", selection: $thousandSeparatorCase) {
                                Text("None").tag(0)
                                Text("Comma").tag(1)
                                Text("Dot").tag(2)
                            }
                .onChange(of: thousandSeparatorCase) { _ in
                    if thousandSeparatorCase == 1 { /// comma
                        if decimalSeparatorCase == 0 { /// also comma
                            decimalSeparatorCase = 1
                        }
                    } else if thousandSeparatorCase == 2 { /// dot
                        if decimalSeparatorCase == 1 { /// also dot
                            decimalSeparatorCase = 0
                        }
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 260)
                Text("12\(screen.thousandSeparator)000\(screen.decimalSeparator)00")
                    .foregroundColor(.gray)
                    .padding(.leading, 20)
                Spacer()
            }
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

struct ControlCenter_Previews: PreviewProvider {
    static var previews: some View {
        Settings(viewModel: ViewModel(), screen: Screen(CGSize()), font: Font(UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .light)))
            .background(Color.black)
    }
}
