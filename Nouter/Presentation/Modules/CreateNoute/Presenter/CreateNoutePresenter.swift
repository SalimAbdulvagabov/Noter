//
//  CreateNoutePresenter.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import Foundation

protocol CreateNouteViewOutput: ViewOutput {
    func closeButtonClick()
    func createNoteMoment(name: String?, text: String?)
    func deleteNouteClick()
    func getFoldersForActions() -> [FolderModel]
    func moveToFolder(_ id: String)
    func folderHasChanged() -> Bool
}

protocol CreateNouteInteractorOutput: AnyObject {

}

final class CreateNoutePresenter {

    // MARK: - Properties

    weak var view: CreateNouteViewInput?

    var interactor: CreateNouteInteractorInput?
    var router: CreateNouteRouterInput?
    private let notesService: NotesService
    private let foldersService: FoldersService
    private var currentFolder: FolderModel

    private var noute: NoteModel?

    convenience init(noute: NoteModel, notesService: NotesService, foldersService: FoldersService) {
        self.init(notesService: notesService, foldersService: foldersService)
        self.noute = noute
    }

    init(notesService: NotesService, foldersService: FoldersService) {
        self.notesService = notesService
        self.foldersService = foldersService

        currentFolder = foldersService.getCurrentFolder()
    }

}

// MARK: - CreateNouteViewOutput
extension CreateNoutePresenter: CreateNouteViewOutput {
    func deleteNouteClick() {
        guard let id = noute?.id else {
            return
        }
        interactor?.reportDeleteNote()
        Notifications.post(name: .deleteNoute, userInfo: ["id": id])
    }

    func closeButtonClick() {
        router?.dismissModule()
    }

    func viewIsReady() {
        interactor?.reportOpenScreen()
        view?.setupInitialState(noute: noute)
    }

    func createNoteMoment(name: String?, text: String?) {
        if (name == nil && text == nil) && noute != nil {
            interactor?.reportClearNote()
            deleteNouteClick()
            return
        }
        if (name == nil && text == nil) || (name == noute?.name && text == noute?.text && !folderHasChanged()) {
            return
        }
        guard let note = noute else {
            let result = NoteModel(name: name,
                                   text: text,
                                   folderID: currentFolder.id)
            notesService.saveNoute(result)

            interactor?.reportCreateNote()
            Notifications.post(name: .nouteCreated)
            return
        }

        let result = NoteModel(id: note.id,
                               name: name,
                               text: text,
                               folderID: currentFolder.id)
        notesService.updateNote(result)

        interactor?.reportChangeNote()
        let newFolderName: String? = folderHasChanged() ? currentFolder.name : nil
        var userInfo: [String: String] = ["id": note.id]
        if let folder = newFolderName {
            userInfo.merge(dict: ["newFolderName": folder])
        }

        Notifications.post(name: .nouteChanged, userInfo: userInfo)
    }

    func getFoldersForActions() -> [FolderModel] {
        foldersService.getFolders().filter {
            $0 != currentFolder
        }
    }

    func moveToFolder(_ id: String) {
        if let folder = foldersService.getFolders().first(where: { $0.id == id}) {
            currentFolder = folder
        }

        view?.updateFoldersActions()
    }

    func folderHasChanged() -> Bool {
        currentFolder != foldersService.getCurrentFolder()
    }

}

// MARK: - CreateNouteInteractorOutput
extension CreateNoutePresenter: CreateNouteInteractorOutput {

}
