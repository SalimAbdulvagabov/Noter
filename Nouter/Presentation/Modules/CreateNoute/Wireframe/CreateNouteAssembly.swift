//
//  CreateNouteAssembly.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class CreateNouteAssembly: Assembly {

    static func assembleModule() -> UIViewController {

        let view = CreateNouteViewController()
        let router = CreateNouteRouter(transition: view)
        let notesService = DependecyContainer.shared.service.notes
        let foldersService = DependecyContainer.shared.service.folders

        let presenter = CreateNoutePresenter(notesService: notesService, foldersService: foldersService)

        let analyticsService = DependecyContainer.shared.analytics.events
        let interactor = CreateNouteInteractor(analyticsService: analyticsService)

        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter

        return view

    }

    static func assembleModule(with model: TransitionModel) -> UIViewController {

        guard let model = model as? Model else { return assembleModule() }

        let view = CreateNouteViewController()
        let router = CreateNouteRouter(transition: view)
        let notesService = DependecyContainer.shared.service.notes
        let foldersService = DependecyContainer.shared.service.folders

        let presenter = CreateNoutePresenter(noute: model.noute, notesService: notesService, foldersService: foldersService)
        let analyticsService = DependecyContainer.shared.analytics.events
        let interactor = CreateNouteInteractor(analyticsService: analyticsService)

        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter

        return view
    }

}

extension CreateNouteAssembly {
    struct Model: TransitionModel {
        let noute: NoteModel
    }
}
