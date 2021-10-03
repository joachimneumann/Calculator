//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI

@main
struct CalculatorApp: App {
    let brain = Brain()
#if targetEnvironment(macCatalyst)
    // force window size on Mac
    @UIApplicationDelegateAdaptor var delegate: FSAppDelegate
#endif
    var body: some Scene {
        WindowGroup {
            // a little hack to prevent that which background creeps up during device orientation chang rotation
            let deviceSize = 1.5*max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
#if targetEnvironment(macCatalyst)
            CatalystContentView()
                .background(TargetEnvironment.appBackgroundColor)
#else
            iOSSize(brain: brain) //IOSContentView()
                .background(Rectangle()
                                .frame(width: deviceSize, height: deviceSize, alignment: .center)
                                .foregroundColor(TargetEnvironment.appBackgroundColor) //Color.yellow.opacity(0.5))
                                .ignoresSafeArea()
                )
#endif
        }
    }
}

#if targetEnvironment(macCatalyst)
class FSSceneDelegate: NSObject, UIWindowSceneDelegate, ObservableObject {
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .forEach { windowScene in
                windowScene.sizeRestrictions?.minimumSize = CGSize(width: TargetEnvironment.windowWidth, height: TargetEnvironment.windowHeight)
                windowScene.sizeRestrictions?.maximumSize = CGSize(width: TargetEnvironment.windowWidth, height: TargetEnvironment.windowHeight)
            }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        if let titlebar = windowScene.titlebar {
            titlebar.titleVisibility = .hidden
            titlebar.toolbar = nil
        }
    }
}

class FSAppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        TargetEnvironmentForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneTargetEnvironment {
        let sceneConfig = UISceneTargetEnvironment(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = FSSceneDelegate.self
        return sceneConfig
    }
}
#endif


//  from https://newbedev.com/swiftui-rotationeffect-framing-and-offsetting
struct SizeKey: PreferenceKey {
    static let defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension UIDevice {
    /// Use with UIDevice.current.orientation
    var safeAreaInsets: UIEdgeInsets {
        let windowCandidate = UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        if let window = windowCandidate {
            return window.safeAreaInsets
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
