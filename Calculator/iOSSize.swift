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
    let leadingPaddingNeeded : Bool
    let trailingPaddingNeeded : Bool
    let bottomPaddingNeeded : Bool
    var body: some View {
        GeometryReader { geo in
            let isPortrait = geo.size.height > geo.size.width
            let _ = print("isPortrait \(isPortrait ? "Y" : "N")")
            let isPad: Bool = (UIDevice.current.userInterfaceIdiom == .pad)

            let fraction = isPortrait ? TE.portraitSpacingFraction : TE.landscapeSpacingFraction
            let horizontalFactor: CGFloat = CGFloat(1.0) -
            (leadingPaddingNeeded ? fraction : 0) -
            (trailingPaddingNeeded ? fraction : 0 )
            let verticalFactor: CGFloat = CGFloat(1.0) -
            (bottomPaddingNeeded ? TE.landscapeSpacingFraction : 0.0)
            
            let _ = print("geometry.safeAreaInsets \(geo.safeAreaInsets)")
            let appFrame = CGSize(
                width: geo.size.width * horizontalFactor,
                height: geo.size.height * verticalFactor)
            let t = TE(appFrame: appFrame, isPad: isPad, isPortrait: isPortrait)
            VStack {
                ZStack {
                    MainView(brain: brain, t: t)
                        .padding(.leading,   leadingPaddingNeeded ? geo.size.width * fraction : 0)
                        .padding(.trailing, trailingPaddingNeeded ? geo.size.width * fraction : 0)
                        .padding(.bottom,   bottomPaddingNeeded   ? t.spaceBetweenKeys : 0)
                }
            }
        }
        .background(Color.green).opacity(0.8)
    }
}

#endif

struct Previews_iOSSize_Previews: PreviewProvider {
    static var previews: some View {
        iOSSize(brain: Brain(), leadingPaddingNeeded: false, trailingPaddingNeeded: false, bottomPaddingNeeded: false)
    }
}
