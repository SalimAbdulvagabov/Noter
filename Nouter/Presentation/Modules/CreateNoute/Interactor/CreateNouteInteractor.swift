//
//  CreateNouteInteractor.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

protocol CreateNouteInteractorInput: CreateNouteInteractorAnalyticsInput {
}

protocol CreateNouteInteractorAnalyticsInput {
    func reportOpenScreen()
    func reportDeleteNote()
    func reportCreateNote()
    func reportClearNote()
    func reportChangeNote()
}

final class CreateNouteInteractor {

    // MARK: - Properties

    weak var presenter: CreateNouteInteractorOutput?

    private let analyticsService: AnalyticsService

    // MARK: - Init

    init(analyticsService: AnalyticsService) {
        self.analyticsService = analyticsService
    }

}

// MARK: - CreateNouteInteractorInput
extension CreateNouteInteractor: CreateNouteInteractorInput {
}

extension CreateNouteInteractor: CreateNouteInteractorAnalyticsInput {
    func reportOpenScreen() {
        analyticsService.reportEvent(Events.SingleNote.singleNote.rawValue)
    }

    func reportDeleteNote() {
        analyticsService.reportEvent(Events.SingleNote.delete.rawValue)
    }

    func reportCreateNote() {
        analyticsService.reportEvent(Events.SingleNote.create.rawValue)
    }

    func reportClearNote() {
        analyticsService.reportEvent(Events.SingleNote.clear.rawValue)
    }

    func reportChangeNote() {
        analyticsService.reportEvent(Events.SingleNote.change.rawValue)
    }
}
