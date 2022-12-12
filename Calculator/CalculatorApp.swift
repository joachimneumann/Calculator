//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI



@main
struct CalculatorApp: App {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var appOrientation = UIDeviceOrientation.unknown
    var body: some Scene {
        let insets = UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets()//.swiftUiInsets ?? EdgeInsets()
        let screenSize = UIScreen.main.bounds.size
        let size = CGSize(width: screenSize.width - insets.left - insets.right, height: screenSize.height - insets.top - insets.bottom)
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        /// appOrientation is used here to trigger a redraw when the orientation changes
        let isPortrait = appOrientation == UIDeviceOrientation.unknown || (UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width)
        let spaceBetweenKeys: CGFloat = C.spaceBetweenkeysFraction(withScientificKeys: !isPortrait) * size.width
        let oneKeyWidth: CGFloat = (size.width - (isPortrait ? 3.0 : 9.0) * spaceBetweenKeys) * (isPortrait ? 0.25 : 0.1)
        let oneKeyheight: CGFloat = isPortrait ? oneKeyWidth : (size.height - 5.0 * spaceBetweenKeys) / 6.17
        let allKeysheight: CGFloat = 5 * oneKeyheight + 4 * spaceBetweenKeys
        let keyboardSize: CGSize = CGSize(width: size.width, height: allKeysheight)
        let singleLineFontSize = ((isPortrait ? 0.14 : 0.16) * keyboardSize.height).rounded()
        let displayTrailingOffset = isPortrait ? 0.0 : oneKeyWidth * 0.7
        let keyboardPaddingBottom = 0.0//isPortrait ? keyboardSize.height * 0.1 : 0.0
        let displayBottomOffset = isPortrait ? size.height - keyboardSize.height - keyboardPaddingBottom - oneKeyheight * 1.2 : 0.00
        WindowGroup {
                Calculator(model: Model(),
                           isPad: isPad,
                           isPortrait: isPortrait,
                           size: size,
                           keyboardSize: keyboardSize,
                           keyHeight: oneKeyheight,
                           singleLineFontSize: singleLineFontSize,
                           displayTrailingOffset: displayTrailingOffset,
                           displayBottomOffset: displayBottomOffset,
                           keyboardPaddingBottom: keyboardPaddingBottom)
//            .withHostingWindow { window in
//                /// this stops white background from showing *during* a device rotation
//                window?.rootViewController?.view.backgroundColor = UIColor.black
//            }
            .onRotate { newOrientation in
                appOrientation = newOrientation
            }
            .onAppear() {
                appOrientation = UIDevice.current.orientation
            }
        }
    }
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
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

/*
 
 class AppDelegate: NSObject, UIApplicationDelegate {
 
 //    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
 //        return true
 //    }
 
 //    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
 //    }
 
 }
 
 @main
 struct CalculatorApp: App {
 @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // used to disallow Landscape in Mac
 
 var model = Model()
 
 var body: some Scene {
 WindowGroup {
 GeometryReader { geo in
 /// if there are no hardware / iOS Insets, make some space
 let isPad: Bool = (UIDevice.current.userInterfaceIdiom == .pad)
 let isPortrait: Bool = geo.size.height > geo.size.width
 let padding: CGFloat = 0.0//(!isPad && isPortrait) ? geo.size.width * 0.04 : geo.size.width * 0.01
 let leadingPadding: CGFloat = geo.safeAreaInsets.leading == 0 ? padding : 0
 let trailingPadding: CGFloat = geo.safeAreaInsets.trailing == 0 ? padding : 0
 let topPadding: CGFloat = geo.safeAreaInsets.top  == 0 ? padding : 0
 let bottomPadding: CGFloat = geo.safeAreaInsets.bottom == 0 ? padding : 0
 let newWidth: CGFloat = geo.size.width - leadingPadding - trailingPadding - 1
 let newHeight: CGFloat = geo.size.height - topPadding - bottomPadding
 
 let spaceBetweenKeys: CGFloat = C.spaceBetweenkeysFraction(withScientificKeys: !isPortrait) * newWidth
 let oneKeyWidth: CGFloat = (newWidth - (isPortrait ? 3.0 : 9.0) * spaceBetweenKeys) * (isPortrait ? 0.25 : 0.1)
 let oneKeyheight: CGFloat = isPortrait ? oneKeyWidth : (newHeight - 5.0 * spaceBetweenKeys) / 6.17
 let allKeysheight: CGFloat = 5 * oneKeyheight + 4 * spaceBetweenKeys
 let keyboardSize: CGSize = CGSize(width: newWidth, height: allKeysheight)
 /// make space for "rad" info
 /// make space for the icon
 let singleLineFontSize = ((isPortrait ? 0.14 : 0.16) * keyboardSize.height).rounded()
 let keyboardPaddingBottom = 0.0//isPortrait ? keyboardSize.height * 0.1 : 0.0
 let displayTrailingOffset = isPortrait ? 0.0 : oneKeyWidth * 0.7
 let displayBottomOffset = isPortrait ? newHeight - keyboardSize.height - keyboardPaddingBottom - oneKeyheight * 1.2 : 0.00
 let _ = (model.displayWidth = newWidth - displayTrailingOffset)
 let _ = (model.lengths =
 lengthMeasurement(
 size: CGSize(width: model.displayWidth, height: newHeight),
 fontSize: singleLineFontSize,
 ePadding: round(singleLineFontSize * (isPortrait ? 0.1 : 0.3))))
 let _ = print("CalculatorApp init() size=\(geo.size) \(geo.safeAreaInsets.trailing) \(model.lengths.withoutComma)")
 let _ = model.haveResultCallback()
 
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
 .padding(.leading, leadingPadding)
 .padding(.trailing, trailingPadding)
 .padding(.top, topPadding)
 .padding(.bottom, bottomPadding)
 .background(Color.yellow)
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
 
 //extension UIApplication {
 //    static var oldWidth: CGFloat = 0
 //    static var AppSafeAreaInsets: UIEdgeInsets  {
 //        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
 //        return scene?.windows.first?.safeAreaInsets ?? .zero
 //    }
 ////    static var AppBounds: CGRect  {
 ////        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
 ////        let b = scene?.windows.first?.bounds ?? .zero
 ////        if oldWidth != b.width {
 ////            print("extension \(b.width)")
 ////            oldWidth = b.width
 ////        }
 ////        return b
 ////    }
 //}
 */
