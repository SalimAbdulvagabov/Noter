//
//  SettingsInteractor.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

protocol SettingsInteractorInput: SettingsInteractorAnalyticsInput {
}

protocol SettingsInteractorAnalyticsInput {
    func reportOpenScreen()
    func reportFeedback()
    func reportRateTheApp()
}

final class SettingsInteractor {

    // MARK: - Properties

    weak var presenter: SettingsInteractorOutput?

    private let analyticsService: AnalyticsService

    // MARK: - Init

    init(analyticsService: AnalyticsService) {
        self.analyticsService = analyticsService
    }

}

// MARK: - SettingsInteractorInput
extension SettingsInteractor: SettingsInteractorInput {
    func reportOpenScreen() {
        analyticsService.reportEvent(Events.Settings.settings.rawValue)
    }

    func reportFeedback() {
        analyticsService.reportEvent(Events.Settings.feedback.rawValue)
    }

    func reportRateTheApp() {
        analyticsService.reportEvent(Events.Settings.rateTheApp.rawValue)
    }

}
