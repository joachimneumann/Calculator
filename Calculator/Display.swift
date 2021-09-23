//
//  Display.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

struct Display: View {
    let text: String
    var higherPrecisionAvailable: Bool
    @Binding var zoomed: Bool
    var getLongString: () -> Void
    
    var body: some View {
        HStack {
            Zoom(higherPrecisionAvailable: higherPrecisionAvailable, zoomed: $zoomed) { getLongString() }
                .padding(.leading, Configuration.shared.zoomButtonSize/2)
            Spacer(minLength: 0)
            Text(text)
                .foregroundColor(Color.white)
                .font(Font.system(size: Configuration.shared.displayFontSize, weight: .thin).monospacedDigit())
                .minimumScaleFactor(0.1)
                .lineLimit(1)
                .padding(.trailing, 15)
                //.background(Color.yellow)
        }
    }
}

struct Display_Previews: PreviewProvider {
    static var previews: some View {
        Display(text: "0", higherPrecisionAvailable: false, zoomed: .constant(false)) {}
    }
}
