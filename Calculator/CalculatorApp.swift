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
        let displayBottomOffset = isPortrait ? size.height - keyboardSize.height - keyboardPaddingBottom - oneKeyheight * 1.2 : 0.0
        WindowGroup {
            ZStack {
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
            }

            .withHostingWindow { window in
                /// this stops white background from showing *during* a device rotation
                window?.rootViewController?.view.backgroundColor = C.appBackgroundUI
            }
            .onRotate { newOrientation in
                appOrientation = newOrientation
            }
            .onAppear() {
                appOrientation = UIDevice.current.orientation
            }
            .preferredColorScheme(.dark)
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
