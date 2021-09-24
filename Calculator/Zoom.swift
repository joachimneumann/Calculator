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
        ZStack {
            Circle()
                .foregroundColor(higherPrecisionAvailable ? Color.white : Color.clear)
                .background(Color.clear)
                .padding(5)
            Image(systemName: zoomed ? "minus.circle.fill" : "plus.circle.fill")
                /// TODO why does animation not work here?
                //.animation(.easeIn(duration: 2), value: zoomed)
                .font(Font.system(size: Configuration.shared.displayFontSize*0.8, weight: .bold).monospacedDigit())
                .foregroundColor(higherPrecisionAvailable ? Configuration.shared.OpKeyProperties.color : Configuration.shared.OpKeyProperties.textColor.opacity(0.5))
                .background(Color.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    if higherPrecisionAvailable {
                        if !zoomed {
                            getLongString()
                        }
                        withAnimation(.easeIn) {
                            zoomed.toggle()
                        }
                    }
                }
        }
        .fixedSize(horizontal: true, vertical: true)
    }
}

struct Zoom_Previews: PreviewProvider {
    static var previews: some View {
        Zoom(higherPrecisionAvailable: true, zoomed: .constant(false)) {}
    }
}
