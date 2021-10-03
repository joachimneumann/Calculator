//
//  iOSSize.swift
//  Calculator
//
//  Created by Joachim Neumann on 02/10/2021.
//

import SwiftUI

struct iOSSize: View {
    let brain: Brain
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let windowCandidate = UIApplication
                    .shared
                    .connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .first { $0.isKeyWindow }
                
                let insets = windowCandidate!.safeAreaInsets

                let leadingPaddingNeeded  = insets.left   == 0
                let trailingPaddingNeeded = insets.right  == 0
                let bottomPaddingNeeded   = insets.bottom == 0
                
                let horizontalFactor:CGFloat = 1.0 -
                (leadingPaddingNeeded ? Configuration.spacingFration : 0) -
                (trailingPaddingNeeded ? Configuration.spacingFration : 0 )
                let verticalFactor:CGFloat = 1.0 -
                (bottomPaddingNeeded ? Configuration.spacingFration : 0.0)
                
                let appFrame = CGSize(
                    width: geo.size.width * horizontalFactor,
                    height: geo.size.height * verticalFactor)
                
                let c = Configuration(appFrame: appFrame)
                
                /// make the app frame smaller if there is no safe area.
                /// If there already is safe area, no padding is needed
                IOSContentView(brain: brain, c: c)
                    .padding(.leading, leadingPaddingNeeded ? c.spaceBetweenkeys : 0)
                    .padding(.trailing, trailingPaddingNeeded ? c.spaceBetweenkeys : 0)
                    .padding(.bottom, bottomPaddingNeeded ? c.spaceBetweenkeys : 0)
            }
        }
    }
}

