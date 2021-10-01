//
//  LandscapeKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct LandscapeKeys: View {
    var brain: Brain
    let appFrame: CGSize
    var body: some View {
        HStack(alignment: .top, spacing: Configuration.spaceBetweenkeys(appFrame: appFrame)) {
            ScientificKeys(
                brain: brain,
                appFrame: appFrame)
                //.background(Color.yellow)
            NumberKeys(
                brain: brain,
                appFrame: appFrame)
                //.background(Color.orange)
        }
    }
    init(brain: Brain, appFrame: CGSize) {
        self.brain = brain
        self.appFrame = appFrame
    }
}

struct LandscapeKeys_Previews: PreviewProvider {
    static var previews: some View {
        LandscapeKeys(brain: Brain(), appFrame: CGSize(width: 0, height: 0))
    }
}
