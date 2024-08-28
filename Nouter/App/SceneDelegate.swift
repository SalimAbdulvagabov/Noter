//
//  SceneDelegate.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 07.10.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import UIKit
import Intents
import Foundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        if let isFirstVisit = UserDefaults.standard.value(forKey: UserDefaultsKeys.isFistVisit.rawValue) as? Bool, !isFirstVisit {

            donateIntents()
            if UserDefaults.standard.value(forKey: UserDefaultsKeys.isNeedShowReturnModule.rawValue) == nil {
                UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isNeedShowReturnModule.rawValue)
            }
            window.rootViewController = NoutesListAssembly.assembleModule()
            self.window = window
            window.makeKeyAndVisible()

            if let shortcutItem = connectionOptions.shortcutItem {
                handleShortcut(shortcutItem)
                return
            }

            if let userActivity = connectionOptions.userActivities.first {
                self.scene(scene, continue: userActivity)
                return
            }

        } else {
            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isNeedShowReturnModule.rawValue)
            window.rootViewController = LaunchAssembly.assembleModule()
            self.window = window
            window.makeKeyAndVisible()
        }

        self.scene(scene, openURLContexts: connectionOptions.urlContexts)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let id = URLContexts.first(where: { $0.url.scheme == "noterapp" })?.url.host {
            MainRouter.shared.openNoteScreen(with: id)
        }
    }

    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        handleShortcut(shortcutItem)
        completionHandler(true)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard let userDefaults = UserDefaults(suiteName: "group.nouter.core.data"),
              let id = userDefaults.value(forKey: "shortcutNoteID") as? String else {
                  return
        }

        userDefaults.removeObject(forKey: "shortcutNoteID")
        userDefaults.synchronize()

        MainRouter.shared.openNoteScreen(with: id)
    }

    private func handleShortcut(_ shortcut: UIApplicationShortcutItem) {
        if shortcut.type == "createNote" {
            MainRouter.shared.openNoteScreen(with: nil)
        }
    }

    private func donateIntents() {
        DependecyContainer.shared.core.siri.donatationIfNeeded()
    }
}
