//
//  OneLineDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/21/22.
//

import SwiftUI

struct OneLineDisplay: View {
    let text: String
    let size: CGSize
    let font: Font
    
    init(keyModel: KeyModel, size: CGSize) {
        text = keyModel.last
        self.size = size
        font = Font.system(size: size.height, weight: .thin).monospacedDigit()
    }
    
    var body: some View {
        HStack(spacing: 0.0) {
            Spacer(minLength: 0.0)
            Text(text)
                .foregroundColor(Color.white)
                .font(font)
                .scaledToFit()
                .minimumScaleFactor(0.1)
        }
    }
}

struct OneLineDisplay_Previews: PreviewProvider {
    static var previews: some View {
        OneLineDisplay(keyModel: KeyModel(), size: CGSize(width: 300, height: 100))
    }
}
