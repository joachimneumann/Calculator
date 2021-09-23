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
    var getLongString: () -> Void

    var body: some View {
        HStack {
            VStack {
                Zoom(
                    higherPrecisionAvailable: brainViewModel.higherPrecisionAvailable,
                    zoomed: $zoomed) { getLongString() }
                    .padding(.leading, Configuration.shared.zoomButtonSize/2)
                    .padding(.top, Configuration.shared.zoomButtonSize+9)
                Spacer(minLength: 0)
            }
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: true) {
                    Text(brainViewModel.longString)
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 30, design: .monospaced).monospacedDigit())
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 10)
                }
                Spacer(minLength: 0)
            }
            .padding(.top, Configuration.shared.zoomButtonSize+7)
            Spacer(minLength: 0)
        }
    }
}

struct NormalView: View {
    @ObservedObject var brainViewModel: BrainViewModel
    @Binding var zoomed: Bool
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Spacer(minLength: 0)
            Display(
                text: brainViewModel.mainDisplay,
                higherPrecisionAvailable: brainViewModel.higherPrecisionAvailable,
                zoomed: $zoomed) {
                    brainViewModel.getLongString()
                }
        
#if targetEnvironment(macCatalyst)
            HStack(alignment: .top, spacing: 1) {
                ScientificKeys(
                    model: brainViewModel,
                    keyWidth: 56.25+0,
                    keyHeight: 47.0+0)
                NumberKeys(
                    model: brainViewModel,
                    keyWidth: 56.25+0,
                    keyHeight: 47.0+0)
            }
            .padding(1.0)
            //.background(Color.green)
#else
            NumberKeys(model: brainViewModel, roundKeys: true, width: 370)
#endif
        }
    }
}

struct ContentView: View {
    @ObservedObject var brainViewModel = BrainViewModel()
    @State var zoomed: Bool = false
    var body: some View {
        ZStack {
            if zoomed {
                AllDigitsView(brainViewModel: brainViewModel, zoomed: $zoomed) { brainViewModel.getLongString() }
            } else {
                NormalView(brainViewModel: brainViewModel, zoomed: $zoomed)
            }
        }
        .background(Configuration.shared.appBackgroundColor)
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 575.0, height: 320.0)
    }
}
