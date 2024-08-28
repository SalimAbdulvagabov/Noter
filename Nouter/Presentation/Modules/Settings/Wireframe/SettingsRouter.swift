//
//  SettingsRouter.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit
import SafariServices

protocol SettingsRouterInput {
    func dissmissModule()
    func openNotifications()
    func openFeedbackForm()
    func openAppStore()
    func openApperanceModule()
    func openBlog()
    func openSiriCommands()
}

final class SettingsRouter: NSObject {

    // MARK: - Properties

    weak var transition: ModuleTransitionHandler?

    // MARK: - Init

    init(transition: ModuleTransitionHandler?) {
        self.transition = transition
    }

}

// MARK: - SettingsRouterInput
extension SettingsRouter: SettingsRouterInput {
    func openNotifications() {
        transition?.push(moduleType: NotificationsSettingsAssembly.self)
    }

    func dissmissModule() {
        transition?.closeModule()
    }

    func openFeedbackForm() {
        let urlString = "https://forms.yandex.ru/u/60571967fe49c071974761bf/"

        guard let url = URL(string: urlString) else {
            dissmissModule()
            return
        }
        let controller = SFSafariViewController(url: url)
        (transition as? UIViewController)?.present(controller, animated: true)
    }

    func openAppStore() {
        if let url = URL(string: "https://itunes.apple.com/in/app/myapp-test/id1536710535?mt=8") {
            UIApplication.shared.open(url)
            dissmissModule()
        }
    }

    func openApperanceModule() {
        transition?.push(moduleType: ApperanceSettingsAssembly.self)
    }

    func openBlog() {
        let urlString = "https://teletype.in/@noterapp/+whats-new"

        guard let url = URL(string: urlString) else {
            dissmissModule()
            return
        }
        let controller = SFSafariViewController(url: url)
        (transition as? UIViewController)?.present(controller, animated: true)
    }

    func openSiriCommands() {
        transition?.push(moduleType: SiriCommandsAssembly.self)
    }

}
