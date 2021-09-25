//
//  AllDigitsView.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct AllDigitsView: View {
    var model: BrainViewModel
    
    var body: some View {
        if model.shortDisplayData.higherPrecisionAvailable {
            let ad = model.allDigitsDisplayData
            ScrollView(.vertical, showsIndicators: true) {
                Text(ad.string)
                    .foregroundColor(Color.white)
                    .font(.custom("CourierNewPSMT", size: 20))
                    .multilineTextAlignment(.leading)
            }
            if let exponentString = ad.exponent {
                HStack {
                    Text(exponentString)
                        .font(.custom("CourierNewPSMT", size: 20))
                    Spacer(minLength: 0)
                }
            }
        } else {
            HStack {
                Spacer(minLength: 0)
                Text(model.shortDisplayString)
                    .foregroundColor(Color.white)
                    .font(.system(size: Configuration.shared.displayFontSize, weight: .thin).monospacedDigit())
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
