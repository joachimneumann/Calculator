//
//  IOSContentView.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct IOSContentView: View {
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
                    NumberKeys(model: model, roundKeys: true, width: 200)
                }
                .transition(.move(edge: .bottom))
            }
            Zoom(higherPrecisionAvailable: model.higherPrecisionAvailable, zoomed: $zoomed) {
                model.getLongString()
            }
        }
        .padding(.top, 28)
        .background(Configuration.shared.appBackgroundColor)
        .ignoresSafeArea()
    }
}


struct IOSContentView_Previews: PreviewProvider {
    static var previews: some View {
        IOSContentView()
    }
}
