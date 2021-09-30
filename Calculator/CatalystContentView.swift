//
//  ContentView.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI


struct CatalystContentView: View {
    @ObservedObject var brain = Brain()
    @State var zoomed: Bool = false
    var body: some View {
        ZStack {
            if zoomed && brain.hasMoreDigits {
                AllDigitsView(brain: brain)
                    .padding(.trailing, Configuration.shared.keyWidth)
                    .padding(.leading, 10)
            } else {
                ZStack {
                    VStack {
                        Display(text: brain.display)
                            .padding(.trailing, Configuration.shared.keyWidth)
                        Spacer(minLength: 0)
                        if !zoomed {
                            LandscapeKeys(brain: brain)
                                .transition(.move(edge: .bottom))
                        }
                    }
                    if brain.rad && !zoomed {
                        Rad()
                            .transition(.move(edge: .bottom))
                    }
                }
                .transition(.move(edge: .bottom))
            }
            Zoom(active: brain.hasMoreDigits, zoomed: $zoomed)
                .padding(.trailing, Configuration.shared.keyWidth*0.5 - Configuration.shared.zoomIconSize*0.5)
                .padding(.top, 12) // hardcoded. The correct height depends on the display font and I was lazy...
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CatalystContentView()
            .frame(width: 575.0, height: 320.0)
    }
}


