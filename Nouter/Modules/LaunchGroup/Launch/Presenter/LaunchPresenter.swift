//
//  LaunchPresenter.swift
//  Nouter
//
//  Created by Рамазан Магомедов on 20.02.2021.
//  Copyright © 2021 Рамазан Магомедов. All rights reserved.
//

import Foundation

protocol LaunchViewOutput: ViewOutput {
    func skipButtonClick()
    func setupNotificationsButtonClick()
}

protocol LaunchInteractorOutput: AnyObject {

}

final class LaunchPresenter {

    weak var view: LaunchViewInput?
    var router: LaunchRouterInput?
    var interactor: LaunchInteractorInput?

    private var timer: Timer?
    private var notesLoaded = false
    private var skiped = false
    private var timerCount = 0

    private let settingsService: SettingsService
    private let notesService: NotesService
    private let apperanceManager: ApperanceManager

    init(settingsService: SettingsService, notesService: NotesService, apperanceManager: ApperanceManager) {
        self.settingsService = settingsService
        self.notesService = notesService
        self.apperanceManager = apperanceManager
    }

    @objc private func icloudNotification() {
        timerCount += 1
        if settingsService.getCountNotes() != 0 && notesService.getNoutes().isEmpty && timerCount < 10 {
            return
        }

        notesLoaded = true
        checkLoadingStatus()
        timer?.invalidate()
    }

    private func checkLoadingStatus() {
        if notesLoaded && skiped {
            view?.openNotesList()
        }
    }

    private func fakeNotes() -> [NouteModel] {
        var array: [NouteModel] = []
        array.append(.init(id: UUID().uuidString,
                           name: "Успех уникален, а ошибки типичны",
                           text: "Не нужно изучать чужой успех, а нужно изучать чужие ошибки."))
        array.append(.init(id: UUID().uuidString,
                           name: "Когда много свободного времени, мозг пытается его чем-то заполнить",
                           text: "Если я целенаправленно не занимаюсь приобретением нужных знаний, то я неосознанно занимаюсь приобретением знаний ненужных."))
        array.append(.init(id: UUID().uuidString,
                           name: "Не размениваться на мелочи, не имеющие никакого значения",
                           text: "Сосредоточиться на главной цели и довольствоваться самым необходимым. Тогда я обрету подлинную свободу и счастье."))
        return array
    }

}

extension LaunchPresenter: LaunchViewOutput {
    func viewIsReady() {
        interactor?.reportOpenScreen()
        apperanceManager.setupInitialState()
        guard settingsService.getCountNotes() != nil else {
            fakeNotes().forEach {
                notesService.saveNoute($0)
            }
            notesLoaded = true
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(icloudNotification),
                                     userInfo: nil,
                                     repeats: true)
    }

    func skipButtonClick() {
        interactor?.reportSkipClick()
        skiped = true
        checkLoadingStatus()
        view?.showLoading()
    }

    func setupNotificationsButtonClick() {
        interactor?.reportClickSettings()
        router?.openSettingsModule()
    }
}

extension LaunchPresenter: LaunchInteractorOutput {

}
