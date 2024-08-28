//
//  SettingsAssembly.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class SettingsAssembly: Assembly {

    static func assembleModule() -> UIViewController {

        let view = SettingsViewController()
        let router = SettingsRouter(transition: view)

        let dataProvider = SettingsDataProvider()
        let presenter = SettingsPresenter(dataProvider: dataProvider)

        let analyticsService = DependecyContainer.shared.analytics.events
        let interactor = SettingsInteractor(analyticsService: analyticsService)

        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter
        return view.wrappedInNavigationController()

    }

}
