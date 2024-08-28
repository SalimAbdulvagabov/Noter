//
//  ApperanceSettingsPresenter.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import Foundation

protocol ApperanceSettingsViewOutput: ViewOutput {
    func themeSelect(theme: ThemeType)
    func iconSelect(icon: AppIconType)
    func closeButtonClick()
}

protocol ApperanceSettingsInteractorOutput: AnyObject {

}

final class ApperanceSettingsPresenter {

    // MARK: - Properties

    weak var view: ApperanceSettingsViewInput?

    var router: ApperanceSettingsRouterInput?
    var interactor: ApperanceSettingsInteractorInput?

    private let settingsService: SettingsService
    private let apperanceManager: ApperanceManager

    init(settingsService: SettingsService, apperanceManager: ApperanceManager) {
        self.settingsService = settingsService
        self.apperanceManager = apperanceManager
    }

}

// MARK: - ApperanceSettingsViewOutput
extension ApperanceSettingsPresenter: ApperanceSettingsViewOutput {

    // MARK: - BaseViewOutput

    func viewIsReady() {
        interactor?.reportOpenScreen()
        view?.setupInitialState(apperance: settingsService.getSettings().apperance,
                                icon: apperanceManager.currentIcon)
    }

    func themeSelect(theme: ThemeType) {
        interactor?.reportChangeTheme()
        let settingsModel = settingsService.getSettings()
        settingsModel.apperance = theme
        settingsService.saveSettings(settingsModel)
        apperanceManager.changeApperance(theme: theme)
    }

    func iconSelect(icon: AppIconType) {
        interactor?.reportChangeIcon()
        let settingsModel = settingsService.getSettings()
        settingsModel.appIcon = icon
        settingsService.saveSettings(settingsModel)
        apperanceManager.changeIcon(icon)
    }

    func closeButtonClick() {
        router?.dismissModule()
    }
}

// MARK: - ApperanceSettingsInteractorOutput
extension ApperanceSettingsPresenter: ApperanceSettingsInteractorOutput {

}
