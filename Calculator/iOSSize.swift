//
//  iOSSize.swift
//  Calculator
//
//  Created by Joachim Neumann on 02/10/2021.
//

#if targetEnvironment(macCatalyst)
// nothing to compile here...
#else

import SwiftUI

struct iOSSize: View {
    var brain: Brain
    var body: some View {
//        SmartDisplay(n: Number("23423"), height: 200)
        GeometryReader { geo in
            let leadingPaddingNeeded: Bool  = (geo.safeAreaInsets.leading  == 0)
            let trailingPaddingNeeded: Bool = (geo.safeAreaInsets.trailing == 0)
            let bottomPaddingNeeded: Bool   = (geo.safeAreaInsets.bottom   == 0)

            let isPortrait = geo.size.height > geo.size.width
            let isPad: Bool = (UIDevice.current.userInterfaceIdiom == .pad)

            let fraction = isPortrait ? TE.portraitSpacingFraction : TE.landscapeSpacingFraction
            let horizontalFactor: CGFloat = CGFloat(1.0) -
            (leadingPaddingNeeded ? fraction : 0) -
            (trailingPaddingNeeded ? fraction : 0 )
            let verticalFactor: CGFloat = CGFloat(1.0) -
            (bottomPaddingNeeded ? TE.landscapeSpacingFraction : 0.0)

            let appFrame = CGSize(
                width: geo.size.width * horizontalFactor,
                height: geo.size.height * verticalFactor)
            let t = TE(appFrame: appFrame, isPad: isPad, isPortrait: isPortrait)

            MainView(brain: brain, t: t)
                .padding(.leading,   leadingPaddingNeeded ? geo.size.width * fraction : 0)
                .padding(.trailing, trailingPaddingNeeded ? geo.size.width * fraction : 0)
                .padding(.bottom,   bottomPaddingNeeded   ? t.spaceBetweenKeys : 0)
        }
    }
}

#endif

struct Previews_iOSSize_Previews: PreviewProvider {
    static var previews: some View {
        iOSSize(brain: Brain())
    }
}
