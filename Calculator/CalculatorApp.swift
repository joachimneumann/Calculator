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
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            ZStack {
                TE.appBackgroundColor
                    .ignoresSafeArea()
                /// Sizes are hardcoded for Mac.
                /// Therefore, I can call the ContentView directly with uninitialized TE.
                ContentView(brain: brain, t: TE())
            }
        }
    }
#else
    var body: some Scene {
        WindowGroup {
            // a little hack to prevent that which background creeps up during device orientation chang rotation
            let expandedDeviceSize: CGFloat = 1.5 * max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            iOSSize(brain: brain)
                .statusBar(hidden: true)
            //.background(Color.yellow)
                .background(Rectangle()
                                .frame(width: expandedDeviceSize, height: expandedDeviceSize, alignment: .center)
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

class AppDelegate: UIResponder, UIApplicationDelegate {
    //        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    //            return true
    //        }
        
    override func buildMenu(with builder: UIMenuBuilder) {
        super.buildMenu(with: builder)
        let copyShort = UIAction(title: "Copy short") { (_) in
        }
        let copyLong = UIAction(title: "Copy long") { (_) in
        }
        let paste = UIAction(title: "Paste") { (_) in
        }
        let copyPasteMenu = UIMenu(title: "Copy & Paste", children: [copyShort, copyLong, paste])

        builder.insertSibling(copyPasteMenu, beforeMenu: .file)
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
    
    @objc func copyShort() {}
    
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

#endif
