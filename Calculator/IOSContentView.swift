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
    @State private var frameSize = CGSize(width: 1.0, height: 1.0)

    private struct FrameCatcher: View {
        @Binding var into: CGSize
        var body: some View {
            Rectangle()
                .foregroundColor(.clear)//.blue.opacity(0.2))
                .background(
                    Rectangle()
                        .foregroundColor(.clear)
                        .captureSize(in: $into)
                )
        }
    }
    
    var body: some View {
        ZStack {
            FrameCatcher(into: $frameSize)
            if zoomed {
                VStack {
                    AllDigitsView(model: model)
                        .padding(.trailing, 15)
                        .padding(.leading, 60)
                    Spacer()
                }
            } else {
                VStack {
                    Spacer()
                    Display(text: model.displayString)
                        .padding(.trailing, 15)
                    NumberKeys(model: model, roundKeys: true, width: frameSize.width)
                }
                .transition(.move(edge: .bottom))
            }
            Zoom(active: model.hasMoreDigits, zoomed: $zoomed)
        }
        .padding(.top, 28)
        .padding(.bottom, 28)
        .padding()
    }
}


struct IOSContentView_Previews: PreviewProvider {
    static var previews: some View {
        IOSContentView()
    }
}
