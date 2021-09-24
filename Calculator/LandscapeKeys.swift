//
//  LandscapeKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct LandscapeKeys: View {
    var model: BrainViewModel
    var body: some View {
        HStack(alignment: .top, spacing: 1) {
            ScientificKeys(
                model: model,
                keyWidth: 56.25,
                keyHeight: 47.0)
            NumberKeys(
                model: model,
                keyWidth: 56.25,
                keyHeight: 47.0)
        }
    }
}

struct LandscapeKeys_Previews: PreviewProvider {
    static var previews: some View {
        LandscapeKeys(model: BrainViewModel())
    }
}
