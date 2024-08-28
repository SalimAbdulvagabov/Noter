//
//  LaunchSettingsAssembly.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 20.02.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class LaunchSettingsAssembly: Assembly {

    static func assembleModule() -> UIViewController {
        let settingsService = DependecyContainer.shared.service.settings

        let view = LaunchSettingsViewController()
        let presenter = NotificationsSettingsPresenter(settingsService: settingsService)

        view.presenter = presenter
        presenter.view = view

        return view

    }

}
