//
//  ContentView.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI

struct AllDigitsView: View {
    @ObservedObject var brainViewModel: BrainViewModel
    var body: some View {
        Text(brainViewModel.longString)
            .foregroundColor(Color.white)
            .font(Font.system(size: 30, design: .monospaced).monospacedDigit())
            .multilineTextAlignment(.leading)
            .padding(.trailing, 20)
            .padding(.bottom, 10)
        Spacer()
    }
}

struct NormalView: View {
    @ObservedObject var brainViewModel: BrainViewModel
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer(minLength: 0)
                Text(brainViewModel.mainDisplay)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 90, design: .monospaced).monospacedDigit())
//                        .font(system(size: 90, design: .monospaced).weight(.thin))
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .padding(.trailing, 20)
                    .padding(.bottom, 10)
                    //.background(Color.red)
            }
            //.background(Color.orange)
            NumberKeys(model: brainViewModel, roundKeys: true, width: 370)
                //.background(Color.yellow)
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
                HStack {
                    Spacer()
                    Image("zoom_in")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .opacity(brainViewModel.higherPrecisionAvailable ? 1.0 : 0.5)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if brainViewModel.higherPrecisionAvailable {
                                zoomed.toggle()
                            }
                        }
                }
                .padding()
                if zoomed {
                    AllDigitsView(brainViewModel: brainViewModel)
                } else {
                    NormalView(brainViewModel: brainViewModel)
                }
            }
            .padding(.bottom, 40)
            .background(Configuration.shared.appBackgroundColor)
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
