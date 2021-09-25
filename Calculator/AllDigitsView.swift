//
//  AllDigitsView.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct AllDigitsView: View {
    var model: BrainViewModel
    
    func content() -> (string: String, font: Font, exponent: String?) {
        if model.shortDisplayString.count <= Configuration.shared.digitsInSmallDisplay {
            return (
                model.shortDisplayString,
                Font.custom("CourierNewPSMT", size: 20),
                nil)
        } else {
            let ad = model.allDigits
            return (
                ad.string,
                Font.custom("CourierNewPSMT", size: 20),
                ad.exponent)
        }
    }
    
    var body: some View {
        let content = content()
        VStack(alignment: .leading, spacing: 0) {
            ScrollView(.vertical, showsIndicators: true) {
                Text(content.string)
                    .foregroundColor(Color.white)
                    .font(content.font)
                    .multilineTextAlignment(.trailing)
            }
            if let exponent = content.exponent {
                Text(exponent)
                    .font(content.font)
            }
        }
    }
}

struct AllDigitsView_Previews: PreviewProvider {
    static var previews: some View {
        AllDigitsView(model: BrainViewModel())
    }
}
