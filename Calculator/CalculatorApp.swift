//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI

@main
struct CalculatorApp: App {
    @State private var isZoomed = false
    @State private var appOrientation = UIDeviceOrientation.unknown
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    let model: Model
               
    init() {
        model = Model(isZoomed: false, screenInfo: ScreenInfo(
        hardwareSize: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height),
        insets: UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets(),
        appOrientation: UIDeviceOrientation.unknown))
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if safeAreaInsets.top == -1 {
                    EmptyView()
                } else {
                    Calculator(model: model)
                    .background(Rectangle()
                                /// this stops white background from showing *during* a device rotation
                        .frame(width: max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) * 2.0,
                               height: max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) * 2.0)
                            .foregroundColor(C.appBackground))
                }
            }
            .onRotate { newOrientation in
                appOrientation = newOrientation
                //print("newOrientation \(newOrientation.rawValue)")
            }
            .onAppear() {
                model.haveResultCallback()
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
        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets(top: -1, leading: -1, bottom: -1, trailing: -1)
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
