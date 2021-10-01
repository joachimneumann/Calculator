//
//  LandscapeKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct LandscapeKeys: View {
    var brain: Brain
    var body: some View {
        HStack(alignment: .top, spacing: 1) {
            ScientificKeys(
                brain: brain,
                keyWidth: Configuration.keyWidth,
                keyHeight: Configuration.keyHeight)
            NumberKeys(
                brain: brain,
                keyWidth: Configuration.keyWidth,
                keyHeight: Configuration.keyHeight)
        }
    }
}

struct LandscapeKeys_Previews: PreviewProvider {
    static var previews: some View {
        LandscapeKeys(brain: Brain())
    }
}
