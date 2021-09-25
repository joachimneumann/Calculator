//
//  AllDigitsView.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct AllDigitsView: View {
    var model: BrainViewModel
    
    func content() -> (string: String, font: Font) {
        if model.shortDisplayString.count <= Configuration.shared.digitsInSmallDisplay {
            return (model.shortDisplayString, Font.custom("CourierNewPSMT", size: 20))// .fontWeight(.ultraLight))
        } else {
            return (model.allDigits().string, Font.custom("CourierNewPSMT", size: 20))//.fontWeight(.ultraLight))
        }
    }
    
    var body: some View {
        let content = content()
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            ScrollView(.vertical, showsIndicators: true) {
                Text(content.string)
                    .foregroundColor(Color.white)
                    .font(content.font)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}

struct AllDigitsView_Previews: PreviewProvider {
    static var previews: some View {
        AllDigitsView(model: BrainViewModel())
    }
}
