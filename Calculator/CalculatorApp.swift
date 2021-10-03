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
    var body: some Scene {
        WindowGroup {
            ZStack {
                TE.appBackgroundColor
                    .ignoresSafeArea()
                // Sizes are hardcoded for Mac
                // I call the ContentView directly with TE()
                ContentView(brain: brain, t: TE())
            }
        }
    }
#else
    var body: some Scene {
        WindowGroup {
            // a little hack to prevent that which background creeps up during device orientation chang rotation
            let expandedDeviceSize = 1.5*max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            iOSSize(brain: brain)
                .statusBar(hidden: true)
                .background(Rectangle()
                                .frame(width: expandedDeviceSize, height: expandedDeviceSize, alignment: .center)
                                .foregroundColor(TE.appBackgroundColor)
                                .ignoresSafeArea())
        }
    }
#endif
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
                windowScene.sizeRestrictions?.minimumSize = CGSize(width: TE.macWindowWidth, height: TE.macWindowHeight)
                windowScene.sizeRestrictions?.maximumSize = CGSize(width: TE.macWindowWidth, height: TE.macWindowHeight)
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
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = FSSceneDelegate.self
        return sceneConfig
    }
}
#endif
