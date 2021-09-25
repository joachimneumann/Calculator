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
    var body: some View {
        let symbolSize = Configuration.shared.displayFontSize*0.5
        let yPadding = Configuration.shared.displayFontSize/2 - symbolSize/2
        HStack {
            VStack {
                ZStack {
                    Group {
                        if zoomed {
                            Image(systemName: "minus.circle.fill")
                        } else {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    .font(Font.system(size: symbolSize, weight: .bold).monospacedDigit())
                    .foregroundColor(
                        higherPrecisionAvailable ?
                        Configuration.shared.OpKeyProperties.color :
                            Color(white: 0.5))
                    .contentShape(Rectangle())
                    .padding(-2)
                    .background(higherPrecisionAvailable ? Color.white : Color.clear)
                    .clipShape(Circle())
                    .onTapGesture {
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
        Zoom(higherPrecisionAvailable: true, zoomed: .constant(false))
    }
}
