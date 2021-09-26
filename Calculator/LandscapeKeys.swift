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
                keyWidth: Configuration.shared.keyWidth,
                keyHeight: Configuration.shared.keyHeight)
            NumberKeys(
                model: model,
                keyWidth: Configuration.shared.keyWidth,
                keyHeight: Configuration.shared.keyHeight)
        }
    }
}

struct LandscapeKeys_Previews: PreviewProvider {
    static var previews: some View {
        LandscapeKeys(model: BrainViewModel())
    }
}
