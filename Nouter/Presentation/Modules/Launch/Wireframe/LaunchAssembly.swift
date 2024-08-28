//
//  LaunchAssembly.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class LaunchAssembly: Assembly {

    static func assembleModule() -> UIViewController {
        let settingsService = DependecyContainer.shared.service.settings
        let notesService = DependecyContainer.shared.service.notes
        let apperanceManager = DependecyContainer.shared.core.apperance
        let foldersService = DependecyContainer.shared.service.folders

        let view = LaunchViewController()
        let presenter = LaunchPresenter(settingsService: settingsService,
                                        notesService: notesService,
                                        foldersService: foldersService,
                                        apperanceManager: apperanceManager)
        let router = LaunchRouter(transition: view)

        let analyticsService = DependecyContainer.shared.analytics.events

        let interactor = LaunchInteractor(analyticsService: analyticsService)
        view.presenter = presenter
        presenter.view = view

        presenter.router = router

        interactor.presenter = presenter
        presenter.interactor = interactor

        return view

    }

}
