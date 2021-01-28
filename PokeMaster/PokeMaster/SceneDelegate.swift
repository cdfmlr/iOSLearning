//
//  SceneDelegate.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/08/28.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
//        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
//        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//
//        // Create the SwiftUI view that provides the window contents.
//        let contentView = MainTab().environmentObject(Store())
//
//        // Use a UIHostingController as window root view controller.
//        if let windowScene = scene as? UIWindowScene {
//            let window = UIWindow(windowScene: windowScene)
//            window.rootViewController = UIHostingController(rootView: contentView)
//            self.window = window
//            window.makeKeyAndVisible()
//        }
        let store = createStore(connectionOptions.urlContexts)
        showMainTab(scene: scene, with: store)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let store = createStore(URLContexts)
        showMainTab(scene: scene, with: store)
    }

    private func showMainTab(scene: UIScene, with store: Store) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(
                rootView:
                MainTab().environmentObject(store)
            )
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    /// 从 URL Scheme 创建 Store
    ///
    /// 根据 URL 将 AppState 设置为所需要的值，
    /// 这样就构建合适的 Store，将它传递给 showMainTab，
    /// 就可以显示符合 需要的界面了。
    private func createStore(_ URLContexts: Set<UIOpenURLContext>) -> Store {
        let store = Store()

        guard let url = URLContexts.first?.url,
              let components = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false)
        else {
            return store
        }

        switch (components.scheme, components.host) {
        case ("pokemaster", "showPanel"):
            // pokemaster://showPanel?id={id}
            guard let idQuery = (components.queryItems?.first { $0.name == "id" }),
                  let idString = idQuery.value,
                  let id = Int(idString),
                  id > 0 && id <= 30
            else { break }
            store.appState.pokemonList.dynamic = .init(
                expandingIndex: id,
                panelIndex: id,
                panelPresented: true
            )
        default: break
        }

        return store
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
