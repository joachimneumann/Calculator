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
            if zoomed && model.hasMoreDigits {
                AllDigitsView(model: model)
                    .padding(.trailing, Configuration.shared.keyWidth)
                    .padding(.leading, 10)
            } else {
                VStack {
                    Display(text: model.shortDisplayString)
                        .padding(.trailing, Configuration.shared.keyWidth)
                    Spacer(minLength: 0)
                    if !zoomed {
                        LandscapeKeys(model: model)
                            .transition(.move(edge: .bottom))
                    }
                }
                .transition(.move(edge: .bottom))
            }
            Zoom(active: model.hasMoreDigits, zoomed: $zoomed)
                .padding(.trailing, Configuration.shared.keyWidth*0.5 - Configuration.shared.zoomIconSize*0.5)
                .padding(.top, 12) // hardcoded. The correct height depends on the display font and I was lazy...
            if !zoomed {
                Rad(rad: $model.rad)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CatalystContentView()
            .frame(width: 575.0, height: 320.0)
    }
}


