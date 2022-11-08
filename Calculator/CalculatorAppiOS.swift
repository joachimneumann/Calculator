//
//  CalculatorAppiOS.swift
//  Calculator
//
//  Created by Joachim Neumann on 10/24/21.
//

import SwiftUI

#if targetEnvironment(macCatalyst)
/// nothing to compile here
#else

struct CalculatorAppiOS: Scene {
    
    let brain = Brain()
    
    var body: some Scene {
        var leadingPaddingNeeded: Bool = false
        var trailingPaddingNeeded: Bool = false
        var bottomPaddingNeeded: Bool = false
        WindowGroup {
            ZStack {
                GeometryReader { geo in
                    //let _ = print("geo.size \(geo.size)")
                    let _ = (leadingPaddingNeeded  = (geo.safeAreaInsets.leading  == 0))
                    let _ = (trailingPaddingNeeded = (geo.safeAreaInsets.trailing == 0))
                    let _ = (bottomPaddingNeeded   = (geo.safeAreaInsets.bottom   == 0))
                }
                /// The factor 1.5 is a little hack to prevent that the white background
                /// shows up during device orientation change rotation
                let expandedDeviceSize: CGFloat = 1.5 * max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
                //let _ = print("XXXXXXXX \(expandedDeviceSize)")
                iOSSize(brain: brain, leadingPaddingNeeded: leadingPaddingNeeded, trailingPaddingNeeded: trailingPaddingNeeded, bottomPaddingNeeded: bottomPaddingNeeded)
                    .statusBar(hidden: true)
                    .background(Rectangle()
                        .frame(width: expandedDeviceSize,
                               height: expandedDeviceSize,
                               alignment: .center)
                            .foregroundColor(TE.appBackgroundColor)
                            .ignoresSafeArea())
                
            }
        }
//        .commands() {
//            CalculatorCommands(brain: brain)
//        }
    }
}

class MyAppDelegate: NSObject, UIApplicationDelegate {
}

#endif


