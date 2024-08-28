//
//  LaunchPresenter.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 20.02.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
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

    private var notesLoaded = false
    private var skiped = false
    private var timerCount = 0

    private let settingsService: SettingsService
    private let notesService: NotesService
    private let foldersService: FoldersService
    private let apperanceManager: ApperanceManager

    init(settingsService: SettingsService,
         notesService: NotesService,
         foldersService: FoldersService,
         apperanceManager: ApperanceManager) {
        self.settingsService = settingsService
        self.notesService = notesService
        self.foldersService = foldersService
        self.apperanceManager = apperanceManager
    }

    private func checkLoadingStatus() {
        if notesLoaded && skiped {
            view?.openNotesList()
            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isFistVisit.rawValue)
        }
    }

}

extension LaunchPresenter: LaunchViewOutput {
    func viewIsReady() {
        interactor?.reportOpenScreen()
        apperanceManager.setupInitialState()
        settingsService.synchronize()
        loadFolders()
    }

    private func loadFolders() {
        foldersService.loadFolders { [weak self] foldersSuccess in
            if foldersSuccess {
                self?.loadNotes()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                    self?.settingsService.synchronize()
                    self?.loadFolders()
                }
            }
        }
    }

    private func loadNotes() {
        notesService.loadNotes {[weak self] notesSuccess in
            if notesSuccess {
                self?.notesLoaded = notesSuccess
                self?.checkLoadingStatus()
                self?.settingsService.loadSettings()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                    self?.settingsService.synchronize()
                    self?.loadNotes()
                }
            }
        }
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
