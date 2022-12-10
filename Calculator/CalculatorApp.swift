//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}

@main
struct CalculatorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // used to disallow Landscape in Mac
    
    var model = Model()

    var body: some Scene {
        WindowGroup {
            GeometryReader { geo in
                //let _ = print("CalculatorApp init() size=\(geo.size)")
                let isPad: Bool = (UIDevice.current.userInterfaceIdiom == .pad)
                let isPortrait: Bool = geo.size.height > geo.size.width
                let padding: CGFloat = (!isPad && isPortrait) ? geo.size.width * 0.04 : geo.size.width * 0.01
                let leadingPadding: CGFloat = geo.safeAreaInsets.leading == 0 ? padding : 0
                let trailingPadding: CGFloat = geo.safeAreaInsets.trailing == 0 ? padding : 0
                let topPadding: CGFloat = geo.safeAreaInsets.top  == 0 ? padding : 0
                let bottomPadding: CGFloat = geo.safeAreaInsets.bottom == 0 ? padding : 0
                let newWidth: CGFloat = geo.size.width - leadingPadding - trailingPadding - 1
                let newHeight: CGFloat = geo.size.height - topPadding - bottomPadding
                
                let spaceBetweenKeys: CGFloat = C.spaceBetweenkeysFraction(withScientificKeys: !isPortrait) * newWidth
                let oneKeyWidth: CGFloat = (newWidth - (isPortrait ? 3.0 : 9.0) * spaceBetweenKeys) * (isPortrait ? 0.25 : 0.1)
                let oneKeyheight: CGFloat = isPortrait ? oneKeyWidth : (newHeight - 5.0 * spaceBetweenKeys) / 6.0
                let allKeysheight: CGFloat = 5 * oneKeyheight + 4 * spaceBetweenKeys
                let keyboardSize: CGSize = CGSize(width: newWidth, height: allKeysheight)
                /// make space for "rad" info
                /// make space for the icon
                let singleLineFontSize = ((isPortrait ? 0.18 : 0.16) * keyboardSize.height).rounded()
                let keyboardPaddingBottom = 0.0//isPortrait ? keyboardSize.height * 0.1 : 0.0
                let displayTrailingOffset = isPortrait ? 0.0 : oneKeyWidth * 0.7
                let displayBottomOffset = isPortrait ? newHeight - keyboardSize.height - keyboardPaddingBottom - oneKeyheight * 1.2 : 0.00
                let _ = (model.displayWidth = newWidth - displayTrailingOffset)
                let _ = (model.lengths =
                         lengthMeasurement(
                            size: CGSize(width: model.displayWidth, height: newHeight),
                            fontSize: singleLineFontSize,
                            ePadding: round(singleLineFontSize * (isPortrait ? 0.0 : 0.3))))

                Calculator(model: model,
                           isPad: isPad,
                           isPortrait: isPortrait,
                           size: CGSize(width: newWidth, height: newHeight),
                           keyboardSize: keyboardSize,
                           keyHeight: oneKeyheight,
                           singleLineFontSize: singleLineFontSize,
                           displayTrailingOffset: displayTrailingOffset,
                           displayBottomOffset: displayBottomOffset,
                           keyboardPaddingBottom: keyboardPaddingBottom)
//                    .padding(.leading, leadingPadding)
//                    .padding(.trailing, trailingPadding)
//                    .padding(.top, topPadding)
//                    .padding(.bottom, bottomPadding)
//                    .background(Color.black)
            }
            .withHostingWindow { window in
                /// this stops white background from showing *during* a device rotation
                window?.rootViewController?.view.backgroundColor = UIColor.black
            }
            .statusBar(hidden: true)
        }
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
