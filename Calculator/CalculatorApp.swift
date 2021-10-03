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
                let t = TE() // sizes are hardcoded for Mac
                ContentView(brain: brain, t: t)
                    .background(TE.appBackgroundColor)
            }
        }
    }
#else
    var body: some Scene {
        WindowGroup {
            // a little hack to prevent that which background creeps up during device orientation chang rotation
            let deviceSize = 1.5*max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            iOSSize(brain: brain)
                .background(Rectangle()
                                .frame(width: deviceSize, height: deviceSize, alignment: .center)
                                .foregroundColor(TE.appBackgroundColor) //Color.yellow.opacity(0.5))
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
                windowScene.sizeRestrictions?.minimumSize = CGSize(width: TE.windowWidth, height: TE.windowHeight)
                windowScene.sizeRestrictions?.maximumSize = CGSize(width: TE.windowWidth, height: TE.windowHeight)
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
