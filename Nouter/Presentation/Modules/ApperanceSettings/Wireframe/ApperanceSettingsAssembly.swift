//
//  ApperanceSettingsAssembly.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class ApperanceSettingsAssembly: Assembly {

    static func assembleModule() -> UIViewController {

        let view = ApperanceSettingsViewController()
        let router = ApperanceSettingsRouter(transition: view)

        let settingsService = DependecyContainer.shared.service.settings
        let apperanceManager = DependecyContainer.shared.core.apperance

        let presenter = ApperanceSettingsPresenter(settingsService: settingsService,
                                                   apperanceManager: apperanceManager)

        let analyticsService = DependecyContainer.shared.analytics.events
        let interactor = ApperanceSettingsInteractor(analyticsService: analyticsService)

        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter

        return view

    }

}
