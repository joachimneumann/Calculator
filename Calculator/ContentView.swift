//
//  ContentView.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI


struct ContentView: View {
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
                    ExtractedView(model: model)
                }
                .transition(.move(edge: .bottom))
            }
            HStack {
                VStack {
                    Zoom(higherPrecisionAvailable: model.higherPrecisionAvailable, zoomed: $zoomed) {
                        model.getLongString()
                    }
                    .padding(.leading, 5)
                    .padding(.top, 5)
                    Spacer(minLength: 0)
                }
                Spacer()
            }
        }
        .padding(.top, 28)
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

struct ExtractedView: View {
    var model: BrainViewModel
    var body: some View {
        HStack(alignment: .top, spacing: 1) {
            ScientificKeys(
                model: model,
                keyWidth: 56.25+0,
                keyHeight: 47.0-0)
            NumberKeys(
                model: model,
                keyWidth: 56.25+0,
                keyHeight: 47.0-0)
        }
    }
}
