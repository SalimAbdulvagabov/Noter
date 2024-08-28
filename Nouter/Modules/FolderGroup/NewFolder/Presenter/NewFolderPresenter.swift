//
//  NewFolderPresenter.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 27.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import Foundation

final class NewFolderPresenter {

    weak var view: NewFolderViewInput?
    var router: NewFolderRouterInput?
    var interactor: NewFolderInteractorInput?

    private var folder: FolderModel?

    convenience init(folder: FolderModel) {
        self.init()
        self.folder = folder
    }

}

extension NewFolderPresenter: NewFolderViewOutput {
    func closeButtonClick() {
        router?.dismissModule()
    }

    func viewIsReady() {
        guard let folder = folder else {
            return
        }

        view?.setupInitialState(name: folder.name, enabled: folder.enable)
    }

    func savebuttonClick(name: String, enabled: Bool) {
        defer {
            router?.dismissModule()
            Notifications.post(name: .folderCreated)
        }
        guard let folder = folder else {
            interactor?.saveFolder(.init(id: UUID().uuidString,
                                         name: name,
                                         position: interactor?.foldersCount() ?? 1,
                                         enable: enabled,
                                         count: 0))
            return
        }
        interactor?.saveFolder(.init(id: folder.id,
                                     name: name,
                                     position: folder.position,
                                     enable: enabled,
                                     count: folder.count))
    }
}

extension NewFolderPresenter: NewFolderInteractorOutput {
}
