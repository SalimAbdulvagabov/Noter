//
//  FoldersListPresenter.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 13.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import Foundation

final class FoldersListPresenter {

    weak var view: FoldersListViewInput?
    var router: FoldersListRouterInput?
    var interactor: FoldersListInteractorInput?

    private var folders: [FolderModel] = []

    private func removeFolder(_ folder: FolderModel, withNotes: Bool, index: Int) {
        let currentFolder = interactor?.getCurrentFolder()

        folders.remove(at: index)
        interactor?.deleteFolder(folder, withNotes: withNotes)
        view?.removeRow(index)

        if folder == currentFolder {
            interactor?.changeCurrentFolder("all")
            view?.setDefaultFolder()
        }

        Notifications.post(name: .currentFolderChanged)
    }
}

extension FoldersListPresenter: FoldersListViewOutput {
    func viewIsReady() {
        guard let folders = interactor?.getFolders(),
              let current = interactor?.getCurrentFolder() else {
                  router?.dismissModule()
                  return
              }

        self.folders = folders
        view?.setupInitialState(folders, current: current)
    }

    func selectFolder(folder: FolderModel) {
        interactor?.changeCurrentFolder(folder.id)
        Notifications.post(name: .currentFolderChanged)
    }

    func changeFolder(index: Int) {
        guard let folder = folders[safe: index] else {
            return
        }

        router?.openEditFolderModule(folder: folder)
    }

    func deleteFolder(index: Int) {
        guard let folder = folders[safe: index] else { return }
        if folder.count > 0 {
            view?.showAlert(title: nil, message: nil, actions: [
                .init(title: "Удалить с заметками", style: .destructive, action: { [weak self] in
                    self?.removeFolder(folder, withNotes: true, index: index)
                }),
                .init(title: "Удалить только папку", style: .default, action: { [weak self] in
                    self?.removeFolder(folder, withNotes: false, index: index)
                }),
                .init(title: "Отменить", style: .cancel, action: nil)
            ], style: .actionSheet)
        } else {
            removeFolder(folder, withNotes: false, index: index)
        }
    }

    func viewWillDisappear(with folders: [FolderModel]) {
        interactor?.reSaveFolders(folders)
    }
}

extension FoldersListPresenter: FoldersListInteractorOutput {
    func closeButtonClick() {
        router?.dismissModule()
    }

    func plusButtonClick() {
        router?.openNewFolderModule()
    }
}
