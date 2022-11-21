//
//  OneLineDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/21/22.
//

import SwiftUI

struct OneLineDisplay: View {
    let text: String
    
    init(keyModel: KeyModel) {
        text = keyModel.last
    }
    
    var body: some View {
        HStack(spacing: 0.0) {
            Spacer(minLength: 0.0)
            Text(text)
                .foregroundColor(Color.white)
        }
    }
}

struct OneLineDisplay_Previews: PreviewProvider {
    static var previews: some View {
        OneLineDisplay(keyModel: KeyModel())
    }
}
