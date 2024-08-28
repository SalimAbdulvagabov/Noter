//
//  ApperanceSettingsInteractor.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 11.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

protocol ApperanceSettingsInteractorInput: ApperanceSettingsInteractorAnalyticsInput {
}

protocol ApperanceSettingsInteractorAnalyticsInput {
    func reportOpenScreen()
    func reportChangeIcon()
    func reportChangeTheme()
}

final class ApperanceSettingsInteractor {

    // MARK: - Properties

    weak var presenter: ApperanceSettingsInteractorOutput?

    private let analyticsService: AnalyticsService

    // MARK: - Init

    init(analyticsService: AnalyticsService) {
        self.analyticsService = analyticsService
    }

}

// MARK: - CreateNouteInteractorInput
extension ApperanceSettingsInteractor: ApperanceSettingsInteractorInput {
}

extension ApperanceSettingsInteractor: ApperanceSettingsInteractorAnalyticsInput {
    func reportOpenScreen() {
        analyticsService.reportEvent(Events.Apperance.apperance.rawValue)
    }

    func reportChangeIcon() {
        analyticsService.reportEvent(Events.Apperance.changeIcon.rawValue)
    }

    func reportChangeTheme() {
        analyticsService.reportEvent(Events.Apperance.changeTheme.rawValue)
    }
}
