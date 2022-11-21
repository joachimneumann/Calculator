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
        
        
        
        WindowGroup {
            GeometryReader { geo in
                let isPad = (UIDevice.current.userInterfaceIdiom == .pad)
                let isPortrait = geo.size.height > geo.size.width
                let padding = (!isPad && isPortrait) ? geo.size.width * 0.04 : geo.size.width * 0.01
                let leadingPadding = geo.safeAreaInsets.leading  == 0 ? padding : 0
                let trailingPadding = geo.safeAreaInsets.trailing  == 0 ? padding : 0
                let topPadding = geo.safeAreaInsets.top  == 0 ? padding : 0
                let bottomPadding = geo.safeAreaInsets.bottom  == 0 ? padding : 0
                let newWidth = geo.size.width - leadingPadding - trailingPadding
                let newheight = geo.size.height - topPadding - bottomPadding
                let newSize = CGSize(width: newWidth, height: newheight)
                Calculator(isPad: isPad, isPortrait: isPortrait, size: newSize)
                    .padding(.leading, leadingPadding)
                    .padding(.trailing, trailingPadding)
                    .padding(.top, topPadding)
                    .padding(.bottom, bottomPadding)
                    .background(Color.black)
            }
            .withHostingWindow { window in
                /// this stops white background from showing *during* a device rotation
                window?.rootViewController?.view.backgroundColor = UIColor.black
            }
            .statusBar(hidden: true)
        }
        
        
        
        
//        let brain = Brain(precision: 100)
//        var leadingPaddingNeeded:  Bool = false
//        var trailingPaddingNeeded: Bool = false
//        var bottomPaddingNeeded:   Bool = false
//        var topPaddingNeeded:      Bool = false
//        WindowGroup {
//            ZStack {
//                GeometryReader { geo in
//                    let _ = (leadingPaddingNeeded  = (geo.safeAreaInsets.leading  == 0))
//                    let _ = (trailingPaddingNeeded = (geo.safeAreaInsets.trailing == 0))
//                    let _ = (bottomPaddingNeeded   = (geo.safeAreaInsets.bottom   == 0))
//                    let _ = (topPaddingNeeded      = (geo.safeAreaInsets.top      == 0))
//                /// The factor 1.5 is a little hack to prevent that the white background
//                /// shows up during device orientation change rotation
//                let expandedDeviceSize: CGFloat = 1.5 * max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
//                iOSSize(brain: brain,
//                        leadingPaddingNeeded: leadingPaddingNeeded,
//                        trailingPaddingNeeded: trailingPaddingNeeded,
//                        bottomPaddingNeeded: bottomPaddingNeeded,
//                        topPaddingNeeded: topPaddingNeeded
//                )
//                    .statusBar(hidden: true)
//                    .background(Rectangle()
//                        .frame(width: expandedDeviceSize,
//                               height: expandedDeviceSize,
//                               alignment: .center)
//                            .foregroundColor(TE.appBackgroundColor)
//                    )
//                }
//            }
//        }
        
        
        
    }
}


extension View {
    func withHostingWindow(_ callback: @escaping (UIWindow?) -> Void) -> some View {
        self.background(HostingWindowFinder(callback: callback))
    }
}

struct HostingWindowFinder: UIViewRepresentable {
    var callback: (UIWindow?) -> ()

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
