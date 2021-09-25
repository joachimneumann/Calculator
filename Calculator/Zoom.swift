//
//  Zoom.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct Zoom: View {
    var higherPrecisionAvailable: Bool
    @Binding var zoomed: Bool
    var getLongString: () -> Void
    var body: some View {
        let symbolSize = Configuration.shared.displayFontSize*0.5
        let yPadding = Configuration.shared.displayFontSize/2 - symbolSize/2
        HStack {
            VStack {
                ZStack {
                    Circle()
                        .foregroundColor(higherPrecisionAvailable ? Color.white : Color.clear)
                        .background(Color.clear)
                        .padding(5)
                    Group {
                        if zoomed {
                            Image(systemName: "minus.circle.fill")
                        } else {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    /// TODO why does animation not work here?
                    //.animation(.easeIn(duration: 2), value: zoomed)
                    .font(Font.system(size: symbolSize, weight: .bold).monospacedDigit())
                    .foregroundColor(higherPrecisionAvailable ? Configuration.shared.OpKeyProperties.color : Configuration.shared.OpKeyProperties.textColor.opacity(0.5))
                    .background(Color.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if !zoomed && higherPrecisionAvailable {
                            getLongString()
                        }
                        withAnimation(.easeIn) {
                            zoomed.toggle()
                        }
                    }
                }
                .fixedSize(horizontal: true, vertical: true)
                Spacer(minLength: 0)
            }
            .padding(.leading, symbolSize/2)
            .padding(.top, yPadding)
            Spacer()
        }
    }
}


struct Zoom_Previews: PreviewProvider {
    static var previews: some View {
        Zoom(higherPrecisionAvailable: true, zoomed: .constant(false)) {}
    }
}
