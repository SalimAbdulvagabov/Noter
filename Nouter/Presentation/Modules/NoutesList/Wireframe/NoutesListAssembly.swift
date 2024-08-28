//
//  NoutesListAssembly.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class NoutesListAssembly: Assembly {

    static func assembleModule() -> UIViewController {

        let view = NoutesListViewController()
        let router = NoutesListRouter(transition: view)
        let foldersService = DependecyContainer.shared.service.folders
        let settingsService = DependecyContainer.shared.service.settings
        let apperanceManager = DependecyContainer.shared.core.apperance
        let notesService = DependecyContainer.shared.service.notes

        let presenter = NoutesListPresenter(notesService: notesService,
                                            foldersService: foldersService,
                                            settingsService: settingsService,
                                            apperanceManager: apperanceManager)

        let analyticsService = DependecyContainer.shared.analytics.events

        let interactor = NoutesListInteractor(analyticsService: analyticsService)

        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter

        return view

    }

    static var text = "qwe"
}
