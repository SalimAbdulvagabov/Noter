//
//  LaunchInteractor.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 11.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

protocol LaunchInteractorInput: LaunchInteractorAnalyticsInput {
}

protocol LaunchInteractorAnalyticsInput {
    func reportOpenScreen()
    func reportClickSettings()
    func reportSkipClick()
}

final class LaunchInteractor {

    // MARK: - Properties

    weak var presenter: LaunchInteractorOutput?

    private let analyticsService: AnalyticsService

    // MARK: - Init

    init(analyticsService: AnalyticsService) {
        self.analyticsService = analyticsService
    }

}

// MARK: - CreateNouteInteractorInput
extension LaunchInteractor: LaunchInteractorInput {
}

extension LaunchInteractor: LaunchInteractorAnalyticsInput {
    func reportOpenScreen() {
        analyticsService.reportEvent(Events.Launch.launch.rawValue)
    }

    func reportClickSettings() {
        analyticsService.reportEvent(Events.Launch.settings.rawValue)
    }

    func reportSkipClick() {
        analyticsService.reportEvent(Events.Launch.skip.rawValue)
    }

}
