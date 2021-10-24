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
    @UIApplicationDelegateAdaptor var mydelegate: MyAppDelegate

#if targetEnvironment(macCatalyst)
    // force window size on Mac
    var body: some Scene {
        WindowGroup {
            ZStack {
                TE.appBackgroundColor
                    .ignoresSafeArea()
                /// Sizes are hardcoded for Mac.
                /// Therefore, I call default initializer of TE, not giving it the screenSizze
                MainView(brain: brain, t: TE())
            }
        }
        .commands() {
            CalculatorCommands(brain: brain)
        }
    }
#else
    var body: some Scene {
        WindowGroup {
            // a little hack to prevent that which background creeps up during device orientation chang rotation
            let expandedDeviceSize: CGFloat = 1.5 * max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            iOSSize(brain: brain)
                .statusBar(hidden: true)
                .background(Rectangle()
                                .frame(width: expandedDeviceSize,
                                       height: expandedDeviceSize,
                                       alignment: .center)
                                .foregroundColor(TE.appBackgroundColor)
                                .ignoresSafeArea())
        }
    }
    
#endif
}


#if targetEnvironment(macCatalyst)

class SceneDelegate: NSObject, UIWindowSceneDelegate, ObservableObject {
    
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



class MyAppDelegate: UIResponder, UIApplicationDelegate {
    override func buildMenu(with builder: UIMenuBuilder) {
        super.buildMenu(with: builder)
        builder.remove(menu: .file)
        builder.remove(menu: .services)
        builder.remove(menu: .help)
        builder.remove(menu: .window)
        builder.remove(menu: .view)
        builder.remove(menu: .edit)
        builder.remove(menu: .undoRedo)
        builder.remove(menu: .standardEdit)
        builder.remove(menu: .spelling)
        builder.remove(menu: .substitutions)
        builder.remove(menu: .transformations)
        builder.remove(menu: .speech)
        builder.remove(menu: .hide)
        builder.remove(menu: .format)
        builder.remove(menu: .toolbar)
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
    
}

#else
class MyAppDelegate: NSObject, UIApplicationDelegate {
        
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window:UIWindow?) -> UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .all
        }
    }
    
}
#endif
