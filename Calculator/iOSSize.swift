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
        ZStack {
            GeometryReader { geo in
                let windowCandidate = UIApplication
                    .shared
                    .connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .first { $0.isKeyWindow }

                /// make the app frame smaller if there is no safe area.
                /// If there already is safe area, no padding is needed
                if windowCandidate != nil {
                    let insets: UIEdgeInsets = windowCandidate!.safeAreaInsets

                    let leadingPaddingNeeded: Bool  = (insets.left   == 0)
                    let trailingPaddingNeeded: Bool = (insets.right  == 0)
                    let bottomPaddingNeeded: Bool   = (insets.bottom == 0)

                    let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
                    let isLandscape: Bool = isPad ? true : (geo.size.width > geo.size.height)
                    let horizontalFactor: CGFloat = 1.0 -
                    (leadingPaddingNeeded ? (isLandscape ? TE.landscapeSpacingFration : TE.portraitSpacingFration) : 0) -
                    (trailingPaddingNeeded ? (isLandscape ? TE.landscapeSpacingFration : TE.portraitSpacingFration) : 0 )
                    let verticalFactor: CGFloat = 1.0 -
                    (bottomPaddingNeeded ? (isLandscape ? TE.landscapeSpacingFration : TE.portraitSpacingFration) : 0.0)

                    let appFrame = CGSize(
                            width: geo.size.width * horizontalFactor,
                            height: geo.size.height * verticalFactor)
                    let t = TE(appFrame: appFrame, isPad: isPad)
                    ContentView(brain: brain, t: t)
//                        //.background(Color.green.opacity(0.3))
                        .padding(.leading,   leadingPaddingNeeded ? t.spaceBetweenkeys : 0)
                        .padding(.trailing, trailingPaddingNeeded ? t.spaceBetweenkeys : 0)
                        .padding(.bottom,   bottomPaddingNeeded   ? t.spaceBetweenkeys : 0)
                } else {
                    EmptyView()
                }
            }
        }
    }
}

#endif
