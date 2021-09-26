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
                if model.shortDisplayData.hasMoreDigits {
                    VStack {
                        AllDigitsView(model: model)
                            .background(Color.yellow)
                            .padding(.trailing, Configuration.shared.keyWidth)
                            .padding(.leading, 60)
                        Spacer()
                    }
                } else {
                    // zoomed, but not more digits
                    VStack {
                        Display(text: model.shortDisplayString)
                            .padding(.trailing, Configuration.shared.keyWidth)
                        Spacer()
                    }
                }
            } else {
                VStack {
                    Display(text: model.shortDisplayString)
                        .padding(.trailing, Configuration.shared.keyWidth)
                    Spacer()
                }
                VStack {
                    Spacer()
                    LandscapeKeys(model: model)
                }
                .transition(.move(edge: .bottom))
            }
            Zoom(hasMoreDigits: model.shortDisplayData.hasMoreDigits, zoomed: $zoomed)
            if !zoomed {
                Rad(rad: $model.rad)
            }
        }
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


