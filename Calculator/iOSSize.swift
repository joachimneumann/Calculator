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
    @ObservedObject var numberOfCharactersModel = NumberOfCharactersModel()
    var brain: Brain
    let leadingPaddingNeeded : Bool
    let trailingPaddingNeeded : Bool
    let bottomPaddingNeeded : Bool
    var body: some View {
        GeometryReader { geo in
            let isPortrait = geo.size.height > geo.size.width
            //let _ = print("isPortrait \(isPortrait ? "Y" : "N")")
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
            let _ = print("iOSSize \(geo.size) cal \(numberOfCharactersModel.calibrated ? "Y" : "N") \(numberOfCharactersModel.numberOfCharacters ?? -1)")
            let t = TE(appFrame: appFrame, isPad: isPad, isPortrait: isPortrait)
            VStack {
                Text("cal \(numberOfCharactersModel.calibrated ? "Y" : "N") -> \(numberOfCharactersModel.numberOfCharacters ?? -1)")
                    .foregroundColor(Color.white)
                ZStack {
                    if (numberOfCharactersModel.calibrated) {
                        MainView(brain: brain, t: t)
                            .padding(.leading,   leadingPaddingNeeded ? geo.size.width * fraction : 0)
                            .padding(.trailing, trailingPaddingNeeded ? geo.size.width * fraction : 0)
                            .padding(.bottom,   bottomPaddingNeeded   ? t.spaceBetweenKeys : 0)
                    } else {
                        ForEach((0..<numberOfCharactersModel.N), id: \.self) { i in
                            let s = ","+String(repeating: "x", count: i)
                            Text(s)
                                .foregroundColor(Color.white)
                                .font(Font.system(size: t.displayFontSizeCandidate, weight: .thin).monospacedDigit())
                                .overlay(
                                    GeometryReader { proxy in
                                        Color.clear
                                            .onAppear {
                                                numberOfCharactersModel.info(NumberOfCharactersInfo(len: s.count, height: Float(proxy.size.height)))
                                            }
                                    }
                                )
                        }
                    }
                }
            }
        }
    }
}

#endif
