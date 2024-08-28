//
//  NotificationsSettingsPresenter.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import Foundation

protocol NotificationsSettingsViewOutput: ViewOutput {
    func closeButtonClick()
    func switchNotifications(isOn: Bool)
    func didDisappear(with settingsModel: SettingsModel)
}

protocol NotificationsSettingsInteractorOutput: AnyObject {

}

final class NotificationsSettingsPresenter {

    // MARK: - Properties

    weak var view: NotificationsSettingsViewInput?
    var router: NotificationsSettingsRouterInput?
    var interactor: NotificationsSettingsInteractorInput?

    private let settingsService: SettingsService

    init(settingsService: SettingsService) {
        self.settingsService = settingsService
    }

}

// MARK: - NotificationsSettingsViewOutput
extension NotificationsSettingsPresenter: NotificationsSettingsViewOutput {

    func viewIsReady() {
        interactor?.reportOpenScreen()
        let settings = settingsService.getSettings()
        view?.update(with: settings)
    }

    func closeButtonClick() {
        router?.dismissNavigationStack()
    }

    func didDisappear(with settingsModel: SettingsModel) {
        settingsService.getSettings() == settingsModel ? interactor?.reportNotChangeSettings() : interactor?.reportChangeSettings()
        settingsService.saveSettings(settingsModel)
        settingsService.synchronize()
    }

    func switchNotifications(isOn: Bool) {
        isOn ? interactor?.reportEnabled() : interactor?.reportDisabled()
    }

}

extension NotificationsSettingsPresenter: NotificationsDisabledViewDelegate {
    func openSettingsButtonClick() {
        router?.openAppSettings()
    }

}

// MARK: - NotificationsSettingsInteractorOutput
extension NotificationsSettingsPresenter: NotificationsSettingsInteractorOutput {

}
