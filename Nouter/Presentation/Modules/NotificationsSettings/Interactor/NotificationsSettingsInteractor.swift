//
//  NotificationsSettingsInteractor.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 11.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

protocol NotificationsSettingsInteractorInput: NotificationsSettingsInteractorAnalyticsInput {
}

protocol NotificationsSettingsInteractorAnalyticsInput {
    func reportOpenScreen()
    func reportChangeSettings()
    func reportNotChangeSettings()
    func reportDisabled()
    func reportEnabled()
}

final class NotificationsSettingsInteractor {

    // MARK: - Properties

    weak var presenter: NotificationsSettingsInteractorOutput?

    private let analyticsService: AnalyticsService

    // MARK: - Init

    init(analyticsService: AnalyticsService) {
        self.analyticsService = analyticsService
    }

}

// MARK: - CreateNouteInteractorInput
extension NotificationsSettingsInteractor: NotificationsSettingsInteractorInput {
}

extension NotificationsSettingsInteractor: NotificationsSettingsInteractorAnalyticsInput {
    func reportOpenScreen() {
        analyticsService.reportEvent(Events.NotificationsSettings.settings.rawValue)
    }

    func reportChangeSettings() {
        analyticsService.reportEvent(Events.NotificationsSettings.changeSettings.rawValue)
    }

    func reportNotChangeSettings() {
        analyticsService.reportEvent(Events.NotificationsSettings.notChangeSettings.rawValue)
    }

    func reportDisabled() {
        analyticsService.reportEvent(Events.NotificationsSettings.disabled.rawValue)
    }

    func reportEnabled() {
        analyticsService.reportEvent(Events.NotificationsSettings.enabled.rawValue)
    }
}
