//
//  ContentView.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var brainViewModel = BrainViewModel()
    var body: some View {
        ZStack {
            Rectangle()
            VStack (spacing: 0) {
                Spacer()
                HStack {
                    Spacer()
                    Image("zoom_in")
                        .opacity(brainViewModel.higherPrecisionAvailable ? 1.0 : 0.5)
                }
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
            .padding(.bottom, 40)
            //.background(Color.green)
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
