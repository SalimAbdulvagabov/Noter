//
//  SettingsPresenter.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import Foundation

protocol SettingsViewOutput: ViewOutput {
    func didSelectCell(_ type: SettingsViewModel.Row)
    func closeButtonClick()
}

protocol SettingsInteractorOutput: AnyObject {

}

final class SettingsPresenter {

    // MARK: - Properties

    weak var view: SettingsViewInput?

    var interactor: SettingsInteractorInput?
    var router: SettingsRouterInput?

    private let dataProvider: SettingsDataProviderInput

    // MARK: - Init

    init(dataProvider: SettingsDataProviderInput) {
        self.dataProvider = dataProvider
    }
}

// MARK: - SettingsViewOutput
extension SettingsPresenter: SettingsViewOutput {

    // MARK: - BaseViewOutput

    func viewIsReady() {
        interactor?.reportOpenScreen()
        view?.showLoading()
        let viewModel = dataProvider.createViewModel()
        view?.update(with: viewModel)
    }

    func didSelectCell(_ type: SettingsViewModel.Row) {
        switch type {
        case .notifications:
            router?.openNotifications()
        case .reportProblem:
            interactor?.reportFeedback()
            router?.openFeedbackForm()
        case .rateApp:
            interactor?.reportRateTheApp()
            router?.openAppStore()
        case .apperance:
            router?.openApperanceModule()
        case .blog:
            router?.openBlog()
        case .siriCommands:
            router?.openSiriCommands()
        default:
            break
        }
    }

    func closeButtonClick() {
        router?.dissmissModule()
    }

}

// MARK: - SettingsInteractorOutput
extension SettingsPresenter: SettingsInteractorOutput {

}
