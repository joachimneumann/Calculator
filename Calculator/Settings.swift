//
//  Settings.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/13/22.
//

import SwiftUI

struct Settings: View {

    @Environment(\.presentationMode) var presentation /// for dismissing the Settings View
    
    @ObservedObject var viewModel: ViewModel
    let screen: Screen
    let font: Font
    
    @State var timerIsRunning: Bool = false
    @State var settingsPrecision: Int = 0
    @State var settingsForceScientific: Bool = false
    @State var settingsShowPreliminaryResults: Bool = false
    @State var timerInfo: String = "click to measure"
    @State var settingsDecimalSeparator: DecimalSeparator = .comma
    @State var settingsGroupingSeparator: GroupingSeparator = .none
    
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
                    switches
                        .padding(.top, 20)
                    
                    hobbyProject
                        .padding(.top, 20)
                    
                    Spacer()
                }
                //.font(font)
                .foregroundColor(Color.white)
            }
            .padding(.horizontal)
            .onDisappear() {
                Task {
                    if viewModel.precision != settingsPrecision {
                        await viewModel.updatePrecision(to: settingsPrecision)
                    }
                    await viewModel.refreshDisplay(screen: screen)
                }
                if viewModel.showPreliminaryResults != settingsShowPreliminaryResults {
                    viewModel.showPreliminaryResults = settingsShowPreliminaryResults
                }
                if screen.forceScientific != settingsForceScientific {
                    screen.forceScientific = settingsForceScientific
                }
                if screen.decimalSeparator != settingsDecimalSeparator {
                    screen.decimalSeparator = settingsDecimalSeparator
                }
                if screen.groupingSeparator != settingsGroupingSeparator {
                    screen.groupingSeparator = settingsGroupingSeparator
                }
            }
        }
        .onAppear() {
            settingsPrecision              = viewModel.precision
            settingsShowPreliminaryResults = viewModel.showPreliminaryResults
            settingsForceScientific        = screen.forceScientific
            settingsDecimalSeparator       = screen.decimalSeparator
            settingsGroupingSeparator      = screen.groupingSeparator
        }
#if !os(macOS)
        .navigationBarHidden(true)
#endif
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
        /// The maximal precision of the mpfr library on iOS devices is 2^63 - 1 - 256 = 9223372036854775551
        /// We run into memory limitations long before reaching this limit
        
        private let timerInfoDefault: String = "click to measure"
        var body: some View {
            HStack {
                precisionLabel
                precisionStepper
                    .padding(.horizontal, 4)
                precisionComment
                Spacer()
            }
            .padding(.bottom, 15)
            Text("Internal precision to mitigate error accumulation: \(internalPrecisionInfo)")
                .padding(.bottom, 5)
                .foregroundColor(.gray)
            Text("Bits used in the gmp and mpfr libraries: \(bitsInfo)")
                .padding(.bottom, 5)
                .foregroundColor(.gray)
            let more = (settingsPrecision > Display.MAX_DISPLAY_LENGTH)
            Text("Digits in the display: \(min(settingsPrecision, Display.MAX_DISPLAY_LENGTH)) \(more ? "(copy fetches all \(settingsPrecision.useWords) digits)" : " ")")
                .padding(.bottom, 5)
                .foregroundColor(.gray)
            Text("Memory size of one number: \(sizeOfOneNumber.asMemorySize)")
                .foregroundColor(.gray)
                .padding(.bottom, -4)
        }
        
        var precisionLabel: some View {
            Text("Precision:")
                .foregroundColor(timerIsRunning ? .gray : .white)
        }
        
        var precisionComment: some View {
            HStack {
                Text("\(settingsPrecision.useWords) significant digits")
                    .foregroundColor(timerIsRunning ? .gray : .white)
                if memoryNeeded >= PHYSICAL_MEMORY {
                    Text("(memory limit reached)")
                        .foregroundColor(timerIsRunning ? .gray : .white)
                }
            }
        }
        
        var precisionStepper: some View {
#if os(macOS)
            let h: CGFloat = 22.0
#else
            let h: CGFloat = 25.0
#endif
            return ColoredStepper(
                plusEnabled: !timerIsRunning && memoryNeeded < PHYSICAL_MEMORY,
                minusEnabled: !timerIsRunning && settingsPrecision > MIN_PRECISION,
                height: h,
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
                measurementLabel
                measurementButton
            }
            .offset(y: -0.15 * screen.infoUiFontSize)
        }
        
        var measurementLabel: some View {
#if os(macOS)
            let h: CGFloat = 60.0 * 12.0 / 16.0
#else
            let h: CGFloat = 60.0
#endif
            return HStack(spacing: 0.0) {
                Text("Time to calculate sin(")
                    .foregroundColor(.gray)
                Label(symbol: "√2", size: h, color: .gray)
                    .offset(x: -0.23 * h)
                Text("):")
                    .foregroundColor(.gray)
                    .offset(x: -0.42 * h)
            }
            .padding(.trailing, 0.6 * h)
        }
        var measurementButton: some View {
            Button {
                timerIsRunning = true
                Task.detached {
                    let speedTestBrain = DebugBrain(precision: settingsPrecision)
                    let result = await speedTestBrain.speedTestSinSqrt2()
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
            .buttonStyle(TransparentButtonStyle())
            .disabled(timerIsRunning)
            .offset(x: -2.0 * screen.infoUiFontSize)
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
                    HStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 15.0)
                        Text("Back")
                    }
                }
                .buttonStyle(TransparentButtonStyle())
                Spacer()
            }
//            .font(font)
            .foregroundColor(timerIsRunning ? .gray : .white)
            .padding()
        }
    }
    
//        .fixedSize(horizontal: false, vertical: true)
//        .fixedSize(horizontal: true, vertical: false)
    var switches: some View {
        HStack(alignment: .center, spacing: 20.0) {
            let tableCellHeight = 50.0
            VStack(alignment: .leading, spacing: 00.0) {
                Text("Decimal Separator")
                    .frame(height: tableCellHeight)
                Text("Grouping Separator")
                    .frame(height: tableCellHeight)
                Text("Force scientific display")
                    .frame(height: tableCellHeight)
                Text("Show preliminary results")
                    .frame(height: tableCellHeight)
            }
            .foregroundColor(timerIsRunning ? .gray : .white)
            .multilineTextAlignment(.leading)
            VStack(alignment: .leading, spacing: 0.0) {
                Picker("", selection: $settingsDecimalSeparator) {
                    ForEach(DecimalSeparator.allCases, id: \.self) { value in
                        Text("\(value.rawValue)")
                            .tag(value)
                    }
                }
                .frame(height: tableCellHeight)
                .onChange(of: settingsDecimalSeparator) { _ in
                    if settingsDecimalSeparator == .comma {
                        if settingsGroupingSeparator == .comma {
                            settingsGroupingSeparator = .dot
                        }
                    } else if settingsDecimalSeparator == .dot {
                        if settingsGroupingSeparator == .dot {
                            settingsGroupingSeparator = .comma
                        }
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 230 * 2 / 3)
                Picker("", selection: $settingsGroupingSeparator) {
                    ForEach(GroupingSeparator.allCases, id: \.self) { value in
                        Text("\(value.rawValue)")
                            .tag(value)
                    }
                }
                .frame(height: tableCellHeight)
                .onChange(of: settingsGroupingSeparator) { _ in
                    if settingsGroupingSeparator == .comma {
                        if settingsDecimalSeparator == .comma {
                            settingsDecimalSeparator = .dot
                        }
                    } else if settingsGroupingSeparator == .dot { /// dot
                        if settingsDecimalSeparator == .dot { /// also dot
                            settingsDecimalSeparator = .comma
                        }
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 230)
                HStack(spacing: 40.0) {
                    Toggle("", isOn: $settingsForceScientific)
                        .toggleStyle(
                            ColoredToggleStyle(onColor: Color(white: timerIsRunning ? 0.4 : 0.6),
                                               offColor: Color(white: 0.25),
                                               thumbColor: timerIsRunning ? Color.gray : Color.white))
                        .frame(width: 40)
                        .disabled(timerIsRunning)
                        .buttonStyle(TransparentButtonStyle())
                        .frame(height: tableCellHeight)
                    let example = settingsForceScientific ?
                    "1\(settingsDecimalSeparator.string)20003 e4" :
                    "12\(settingsGroupingSeparator.string)000\(settingsDecimalSeparator.string)3"
                    Text(example)
                }
                Toggle("", isOn: $settingsShowPreliminaryResults)
                    .toggleStyle(
                        ColoredToggleStyle(onColor: Color(white: timerIsRunning ? 0.4 : 0.6),
                                           offColor: Color(white: 0.25),
                                           thumbColor: timerIsRunning ? .gray : .white))
                    .frame(width: 40)
                    .disabled(timerIsRunning)
                    .buttonStyle(TransparentButtonStyle())
                    .frame(height: tableCellHeight)
            }
        }
    }
    
    var decimalSeparatorView: some View {
        HStack(spacing: 20.0) {
            let example = settingsForceScientific ?
            "1\(settingsDecimalSeparator.string)20003 e4" :
            "12\(settingsGroupingSeparator.string)000\(settingsDecimalSeparator.string)3"
            Text("Decimal Separator")
                .foregroundColor(timerIsRunning ? .gray : .white)
            Picker("", selection: $settingsDecimalSeparator) {
                ForEach(DecimalSeparator.allCases, id: \.self) { value in
                    Text("\(value.rawValue)")
                        .tag(value)
                }
            }
            .onChange(of: settingsDecimalSeparator) { _ in
                if settingsDecimalSeparator == .comma {
                    if settingsGroupingSeparator == .comma {
                        settingsGroupingSeparator = .dot
                    }
                } else if settingsDecimalSeparator == .dot {
                    if settingsGroupingSeparator == .dot {
                        settingsGroupingSeparator = .comma
                    }
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 160)
            Text("for example \(example)")
                .foregroundColor(.gray)
                .padding(.leading, 0)
            Spacer()
        }
    }
    
    var groupingSeparatorView: some View {
        HStack(spacing: 20.0) {
            Text("Grouping Separator")
                .foregroundColor(timerIsRunning ? .gray : .white)
            Picker("", selection: $settingsGroupingSeparator) {
                ForEach(GroupingSeparator.allCases, id: \.self) { value in
                    Text("\(value.rawValue)")
                        .tag(value)
                }
            }
            .onChange(of: settingsGroupingSeparator) { _ in
                if settingsGroupingSeparator == .comma {
                    if settingsDecimalSeparator == .comma {
                        settingsDecimalSeparator = .dot
                    }
                } else if settingsGroupingSeparator == .dot { /// dot
                    if settingsDecimalSeparator == .dot { /// also dot
                        settingsDecimalSeparator = .comma
                    }
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 260)
            Spacer()
        }
    }
    
    var hobbyProject: some View {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        
        return Text("\nVersion: \(appVersion ?? "unknown") (build \(buildNumber ?? "unknown"))")
            .foregroundColor(Color.gray) +

        Text("\nThis is a hobby project by Joachim Neumann. Although I have done some testing, errors may occur. The App is free to use - except for copying and pasting the result. The code is open source and you may open an issue at the ")
            .foregroundColor(Color.gray) +
            
        Text("[github repository](https://github.com/joachimneumann/Calculator)")
            .foregroundColor(Color.white) + /// This link is blue in MacOS. I don't know why.
            
        Text(".\nNote: the gmp and mpfr libraries can in rare circumstances crash the app. Interestingly, their developers deem it appropriate for the library to crash the app in certain situations without allowing the me to catch the error. Sorry for that.")
            .foregroundColor(Color.gray)
    }
    
    struct ColoredToggleStyle: ToggleStyle {
        var label = ""
        var onColor = Color.green
        var offColor = Color(white: 0.5)
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
        Settings(
            viewModel: ViewModel(),
            screen: Screen(CGSize()),
            font: Font(Screen.appleFont(ofSize: 20)))
        .background(.black)
    }
}

struct TransparentButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .background(.clear)
  }
}
