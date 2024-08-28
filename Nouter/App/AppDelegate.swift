//
//  AppDelegate.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 07.10.2022.
//  Copyright © 2022 Салим Абдулвагабов . All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import YandexMobileMetrica

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupDefaultUIStyles()
        FirebaseApp.configure()

        let configuration = YMMYandexMetricaConfiguration.init(apiKey: KeyConstants.appMetrice.rawValue)
        YMMYandexMetrica.activate(with: configuration!)
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    private func setupDefaultUIStyles() {
        let navigation = UINavigationBar.appearance()
        navigation.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigation.shadowImage = UIImage()

        let navigationFont = Fonts.interSemiBold(size: 18)
        let navigationLargeFont = Fonts.interSemiBold(size: 28)

        navigation.titleTextAttributes = [NSAttributedString.Key.font: navigationFont!]
        navigation.largeTitleTextAttributes =  [NSAttributedString.Key.font: navigationLargeFont!]
        UITextField.appearance().tintColor = Colors.text()
        UITextView.appearance().tintColor = Colors.text()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if url.scheme == "noterapp" {
            MainRouter.shared.openNoteScreen(with: url.host)
        }
        return true
    }

}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.banner, .list])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        guard let noteId = userInfo["noteId"] as? String else {
            return
        }
        MainRouter.shared.openNoteScreen(with: noteId)
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        DependecyContainer.shared.service.settings.synchronize()
    }
}
