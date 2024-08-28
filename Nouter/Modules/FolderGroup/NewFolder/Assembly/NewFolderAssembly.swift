//
//  NewFolderAssembly.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 27.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class NewFolderAssembly: Assembly {

    static func assembleModule() -> UIViewController {

        let view = NewFolderViewController()
        let router = NewFolderRouter(transition: view)
        let presenter = NewFolderPresenter()

        let analyticsService = DependecyContainer.shared.analytics.events
        let foldersService = DependecyContainer.shared.service.folders
        let interactor = NewFolderInteractor(analyticsService: analyticsService,
                                               foldersService: foldersService)

        view.output = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter

        return view.wrappedInNavigationController()

    }

    static func assembleModule(with model: TransitionModel) -> UIViewController {

        guard let model = model as? Model else { return assembleModule() }

        let view = NewFolderViewController()
        let router = NewFolderRouter(transition: view)
        let presenter = NewFolderPresenter(folder: model.folder)

        let analyticsService = DependecyContainer.shared.analytics.events
        let foldersService = DependecyContainer.shared.service.folders
        let interactor = NewFolderInteractor(analyticsService: analyticsService,
                                               foldersService: foldersService)

        view.output = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter

        return view.wrappedInNavigationController()
    }

}

extension NewFolderAssembly {
    struct Model: TransitionModel {
        let folder: FolderModel
    }
}
