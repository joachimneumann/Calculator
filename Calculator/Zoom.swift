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
        Image("zoom_in")
            .resizable()
            .frame(width: Configuration.shared.zoomButtonSize, height: Configuration.shared.zoomButtonSize)
            .opacity(higherPrecisionAvailable ? 1.0 : 0.5)
            .contentShape(Rectangle())
            .onTapGesture {
                if higherPrecisionAvailable {
//                    if !zoomed {
//                        getLongString()
//                    }
                    withAnimation(.linear(duration: 2)) {
                        zoomed.toggle()
                    }
                }
            }
    }
}

struct Zoom_Previews: PreviewProvider {
    static var previews: some View {
        Zoom(higherPrecisionAvailable: true, zoomed: .constant(false)) {}
    }
}
