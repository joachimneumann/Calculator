//
//  Zoom.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct Zoom: View {
    var hasMoreDigits: Bool
    @Binding var zoomed: Bool
    var body: some View {
        HStack {
            Spacer()
            VStack {
                ZStack {
                    Group {
                        if zoomed {
                            Image(systemName: "minus.circle.fill")
                        } else {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    .font(Font.system(size: Configuration.shared.zoomIconSize, weight: .bold).monospacedDigit())
                    .foregroundColor(
                        hasMoreDigits ?
                        Configuration.shared.OpKeyProperties.color :
                            Color(white: 0.5))
                    .contentShape(Rectangle())
                    .padding(Configuration.shared.zoomIconSize * -0.1)
                    .background(hasMoreDigits ? Color.white : Color.clear)
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
        }
    }
}


struct Zoom_Previews: PreviewProvider {
    static var previews: some View {
        Zoom(hasMoreDigits: true, zoomed: .constant(false))
    }
}
