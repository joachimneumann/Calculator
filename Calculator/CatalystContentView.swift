//
//  ContentView.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI


struct CatalystContentView: View {
    @ObservedObject var model = BrainViewModel()
    @State var zoomed: Bool = false
    var body: some View {
        ZStack {
            if zoomed {
                VStack {
                    AllDigitsView(text: model.higherPrecisionAvailable ? model.longDisplayData.show() : model.shortDisplayString )
                        .padding(.trailing, 15)
                        .padding(.leading, 60)
                    Spacer()
                }
            } else {
                VStack {
                    Display(text: model.shortDisplayString)
                        .padding(.trailing, 15)
                    Spacer()
                }
                VStack {
                    Spacer()
                    LandscapeKeys(model: model)
                }
                .transition(.move(edge: .bottom))
            }
            Zoom(higherPrecisionAvailable: model.higherPrecisionAvailable, zoomed: $zoomed) {
                model.getLongString()
            }
        }
        .background(Color.yellow)
        .padding(.top, 28)
        .background(Configuration.shared.appBackgroundColor)
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CatalystContentView()
            .frame(width: 575.0, height: 320.0)
    }
}


