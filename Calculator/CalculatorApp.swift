//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI


class AppDelegate: NSObject, UIApplicationDelegate {
    static var forceLandscape = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        /// detect mac:
        /// 1. size of screen 834.0x1194.0
        /// 2. EdgeInsets all 0
//        let isMac = false
//        if isMac {
//            return UIInterfaceOrientationMask.landscape
//        } else {
        if AppDelegate.forceLandscape {
            return UIInterfaceOrientationMask.landscape
        } else {
            return UIInterfaceOrientationMask.all
        }
//        }
    }
}

@main
struct CalculatorApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // used to disallow Landscape in Mac
    
    init() {
        UINavigationBar.appearance().backgroundColor = .black
    }

    var body: some Scene {
        let brain = Brain(precision: 100)
        var leadingPaddingNeeded:  Bool = false
        var trailingPaddingNeeded: Bool = false
        var bottomPaddingNeeded:   Bool = false
        var topPaddingNeeded:      Bool = false
        WindowGroup {
            ZStack {
                GeometryReader { geo in
                    let _ = (leadingPaddingNeeded  = (geo.safeAreaInsets.leading  == 0))
                    let _ = (trailingPaddingNeeded = (geo.safeAreaInsets.trailing == 0))
                    let _ = (bottomPaddingNeeded   = (geo.safeAreaInsets.bottom   == 0))
                    let _ = (topPaddingNeeded      = (geo.safeAreaInsets.top      == 0))
                /// The factor 1.5 is a little hack to prevent that the white background
                /// shows up during device orientation change rotation
                let expandedDeviceSize: CGFloat = 1.5 * max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
                iOSSize(brain: brain,
                        leadingPaddingNeeded: leadingPaddingNeeded,
                        trailingPaddingNeeded: trailingPaddingNeeded,
                        bottomPaddingNeeded: bottomPaddingNeeded,
                        topPaddingNeeded: topPaddingNeeded
                )
                    .statusBar(hidden: true)
                    .background(Rectangle()
                        .frame(width: expandedDeviceSize,
                               height: expandedDeviceSize,
                               alignment: .center)
                            .foregroundColor(TE.appBackgroundColor)
//                            .ignoresSafeArea()
                    )
                }
            }
        }
    }
}

