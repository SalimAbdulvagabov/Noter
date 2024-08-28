//
//  NotificationsSettingsAssembly.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class NotificationsSettingsAssembly: Assembly {

    static func assembleModule() -> UIViewController {

        let view = NotificationsSettingsViewController()
        let router = NotificationsSettingsRouter(transition: view)
        let settingsService = DependecyContainer.shared.service.settings

        let presenter = NotificationsSettingsPresenter(settingsService: settingsService)

        let analyticsService = DependecyContainer.shared.analytics.events
        let interactor = NotificationsSettingsInteractor(analyticsService: analyticsService)

        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter

        return view

    }

}
