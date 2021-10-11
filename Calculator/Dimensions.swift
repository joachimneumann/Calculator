//
//  Dimensions.swift
//  Dimensions
//
//  Created by Joachim Neumann on 10/11/21.
//

import CoreGraphics

class D {
    var displayFontSize: CGFloat = 0.0
    var isLandscape: Bool = false
    var spaceBetweenkeys: CGFloat = 0.0
    var keySize: CGSize = CGSize(width: 0.0, height: 0.0)
    var widerKeySize: CGSize = CGSize(width: 0.0, height: 0.0)
    var allkeysHeight: CGFloat { 5.0 * keySize.height + 4.0 * spaceBetweenkeys }
    var remainingAboveKeys: CGFloat = 0.0
    var digitsInSmallDisplay: Int = 3
    var isPad: Bool = false
    
#if targetEnvironment(macCatalyst)
    init() {
        let kh  = 63.0  // key height
        let kw  = 72.75 // key width
        let wkw = 77.0  // wider with for +-*/= keys
        let sp  = 1.5   // space between keys
        let digitsInSmallDisplay: Int = 16
        let isLandscape: Bool = true
        let spaceBetweenkeys: CGFloat   = sp
        let displayFontSize: CGFloat    = (5.0 * kw + 4.0 * sp) * 0.175
        let keySize: CGSize       = CGSize(width: kw,  height: kh)
        let widerKeySize: CGSize  = CGSize(width: wkw, height: kh)
        let scientificKeySize: CGSize   = CGSize(width: kw,  height: kh)
        let allkeysHeight: CGFloat = 5.0 * kh + 4.0 * sp
        let remainingAboveKeys: CGFloat = TE.macWindowHeight - (5.0 * kh + 4.0 * sp)
        let isPad: Bool = false
    }
#else
    init(appFrame: CGSize, isPad: Bool) {
        self.isPad = isPad
        if isPad {
            isLandscape = true
        } else {
            isLandscape = appFrame.width > appFrame.height
        }
        print("calc() appFrame=\(appFrame)")
        
        if isLandscape {
            spaceBetweenkeys = appFrame.width * TE.landscapeSpacingFration
            let w = (appFrame.width - 9.0 * spaceBetweenkeys) * 0.1

            // I need space for the display
            let squareKeysHeight = 5.0 * w + 4.0 * spaceBetweenkeys
            let factor:CGFloat = min(1.0, appFrame.height * 0.8 / squareKeysHeight)
            keySize = CGSize(width: w, height: w * factor)
            digitsInSmallDisplay = 16
        } else {
            /// portrait
            spaceBetweenkeys = appFrame.width * TE.portraitSpacingFration
            let w = (appFrame.width - 3.0 * spaceBetweenkeys) * 0.25
            keySize = CGSize(width: w, height: w)
            digitsInSmallDisplay = 9
        }
        displayFontSize = keySize.height
        widerKeySize = keySize
        remainingAboveKeys = appFrame.height - allkeysHeight
    }
#endif
}
