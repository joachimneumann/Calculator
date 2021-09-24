//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI

@main
struct CalculatorApp: App {
    
    // force window size on Mac
#if targetEnvironment(macCatalyst)
    @UIApplicationDelegateAdaptor var delegate: FSAppDelegate
#endif
    
    var body: some Scene {
#if targetEnvironment(macCatalyst)
        WindowGroup {
            CatalystContentView()
        }
#else
        WindowGroup {
            IOSContentView()
        }
#endif
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
                windowScene.sizeRestrictions?.minimumSize = CGSize(width: Configuration.shared.windowWidth, height: Configuration.shared.windowHeight)
                windowScene.sizeRestrictions?.maximumSize = CGSize(width: Configuration.shared.windowWidth, height: Configuration.shared.windowHeight)
            }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
#if targetEnvironment(macCatalyst)
        if let titlebar = windowScene.titlebar {
            titlebar.titleVisibility = .hidden
            titlebar.toolbar = nil
        }
#endif
    }
}

class FSAppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = FSSceneDelegate.self
        return sceneConfig
    }
}
#endif
