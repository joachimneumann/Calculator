//
//  ContentView.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI

struct AllDigitsView: View {
    @ObservedObject var brainViewModel: BrainViewModel
    @Binding var zoomed: Bool
    var body: some View {
        HStack {
            VStack {
                Spacer()
                Zoom(brainViewModel: brainViewModel, zoomed: $zoomed)            }
            Spacer(minLength: 0)
            VStack {
                Text(brainViewModel.longString)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 30, design: .monospaced).monospacedDigit())
                    .multilineTextAlignment(.leading)
                    .padding(.trailing, 20)
                    .padding(.bottom, 10)
                Spacer(minLength: 0)
            }
            Spacer(minLength: 0)
        }
    }
}

struct NormalView: View {
    @ObservedObject var brainViewModel: BrainViewModel
    @Binding var zoomed: Bool
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            HStack {
                Zoom(brainViewModel: brainViewModel, zoomed: $zoomed)
                Spacer(minLength: 0)
                Text(brainViewModel.mainDisplay)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: Configuration.shared.displayFontSize, design: .monospaced).monospacedDigit())
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .padding(.trailing, 20)
//                    .padding(.bottom, 10)
                    //.background(Color.red)
            }
            
#if targetEnvironment(macCatalyst)
            HStack {
                Spacer(minLength: 0)
                NumberKeys(model: brainViewModel, keyWidth: 57, keyHeight: 47)
            }
#else
            NumberKeys(model: brainViewModel, roundKeys: true, width: 370)
#endif
        }
    }
}

struct Zoom: View {
    @ObservedObject var brainViewModel: BrainViewModel
    @Binding var zoomed: Bool
    var body: some View {
        Image("zoom_in")
            .resizable()
            .frame(width: Configuration.shared.zoomButtonSize, height: Configuration.shared.zoomButtonSize)
            .padding(.leading, Configuration.shared.zoomButtonSize/2)
            .opacity(brainViewModel.higherPrecisionAvailable ? 1.0 : 0.5)
            .contentShape(Rectangle())
            .onTapGesture {
                if brainViewModel.higherPrecisionAvailable {
                    zoomed.toggle()
                }
            }
    }
}


struct ContentView: View {
    @ObservedObject var brainViewModel = BrainViewModel()
    @State var zoomed: Bool = false
    var body: some View {
        ZStack {
            Rectangle()
            VStack (spacing: 0) {
                if zoomed {
                    AllDigitsView(brainViewModel: brainViewModel, zoomed: $zoomed)
                } else {
                    NormalView(brainViewModel: brainViewModel, zoomed: $zoomed)
                }
            }
            .background(Configuration.shared.appBackgroundColor)
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 575.0, height: 320.0)
    }
}
