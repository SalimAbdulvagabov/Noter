//
//  NoutesListInteractor.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import Foundation
import UIKit

protocol NoutesListInteractorInput: NoutesListInteractorAnalyticsInput {

}

protocol NoutesListInteractorAnalyticsInput {
    func reportOpenScreen()
    func reportDeleteNote()
    func reportSheduleNotificationsSettings(_ settings: SettingsModel)
}

final class NoutesListInteractor {

    // MARK: - Properties

    weak var presenter: NoutesListInteractorOutput?

    private let analyticsService: AnalyticsService

    // MARK: - Init

    init(analyticsService: AnalyticsService) {
        self.analyticsService = analyticsService
    }

}

// MARK: - NoutesListInteractorInput
extension NoutesListInteractor: NoutesListInteractorInput {

    func obtainAccountInfo() {

    }
}

extension NoutesListInteractor: NoutesListInteractorAnalyticsInput {
    func reportOpenScreen() {
        analyticsService.reportEvent(Events.NotesList.notesList.rawValue)
    }

    func reportDeleteNote() {
        analyticsService.reportEvent(Events.NotesList.delete.rawValue)
    }

    func reportSheduleNotificationsSettings(_ settings: SettingsModel) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { [weak self] items in
            let params: [String: Any] =
                [
                    "repeatability": settings.repeatability.name,
                    "startTime": settings.startTime.timeDescription,
                    "endTime": settings.endTime.timeDescription,
                    "sheduleCount": items.count
                ]

            self?.analyticsService.reportEvent(Events.NotificationsSettings.sheduleSettings.rawValue, parameters: params)
        }
    }

}
