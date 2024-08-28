//
//  FoldersListAssembly.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 13.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class FoldersListAssembly: Assembly {

    static func assembleModule() -> UIViewController {

        let view = FoldersListViewController()
        let router = FoldersListRouter(transition: view)
        let presenter = FoldersListPresenter()

        let analyticsService = DependecyContainer.shared.analytics.events
        let foldersService = DependecyContainer.shared.service.folders
        let interactor = FoldersListInteractor(analyticsService: analyticsService,
                                               foldersService: foldersService)

        view.output = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter

        return view.wrappedInNavigationController()

    }

}
