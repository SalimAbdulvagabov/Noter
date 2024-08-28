//
//  NoutesListPresenter.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import Foundation

protocol NoutesListViewOutput: ViewOutput {
    func didSelectCell(at indexPath: IndexPath)
    func deleteNouteClick(_ index: Int)
    func createNouteTap()
    func settingsTap()
    func foldersClick()
    func nouteChanged(nouteIndex: Int, newFolder: String?)
    func getFoldersForMove(for note: NoteModel) -> [FolderModel]
    func moveToFolder(_ folder: FolderModel, note: NoteModel, index: Int)
}

protocol NoutesListInteractorOutput: AnyObject {

}

final class NoutesListPresenter {

    // MARK: - Properties

    weak var view: NoutesListViewInput?

    var interactor: NoutesListInteractorInput?
    var router: NoutesListRouterInput?
    private let notesService: NotesService
    private let foldersService: FoldersService
    private let settingsService: SettingsService
    private let apperanceManager: ApperanceManager

    private var notes: [NoteModel] = []

    private var deleteNoute: NoteModel?
    private var currentFolder: FolderModel
    private var deleteIndex: Int?

    init(notesService: NotesService,
         foldersService: FoldersService,
         settingsService: SettingsService,
         apperanceManager: ApperanceManager) {
        self.notesService = notesService
        self.foldersService = foldersService
        self.settingsService = settingsService
        self.apperanceManager = apperanceManager
        self.currentFolder = foldersService.getCurrentFolder()
    }
}

// MARK: - NoutesListViewOutput
extension NoutesListPresenter: NoutesListViewOutput {

    // MARK: - BaseViewOutput
    func viewIsReady() {
        currentFolder = foldersService.getCurrentFolder()

        if currentFolder.id.uppercased() == "ALL" {
            notes = notesService.getNoutes()
        } else {
            notes = notesService.getNoutes().filter {$0.folderID?.uppercased() ?? "ALL" == currentFolder.id.uppercased() }
        }
        view?.changeFolderTitle(text: currentFolder.name)
        interactor?.reportOpenScreen()
        apperanceManager.setupInitialState()
        view?.update(noutes: notes, animateRow: 0)

        foldersService.synchronize()
        settingsService.synchronize()
        notesService.synchronize()
    }

    func viewWillDisappear() {
        timerEnd()
    }

    func viewDidAppear() {
        let key = UserDefaultsKeys.isNeedShowReturnModule.rawValue
        guard let isNeedShowReturn = UserDefaults
                .standard
                .value(forKey: key) as? Bool,
              isNeedShowReturn else {
                  return
              }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.router?.openWeReturnModule()
            UserDefaults.standard.set(false, forKey: key)
        }

    }

    func foldersClick() {
        foldersService.updateNotesCountInFolder()
        timerEnd()
        router?.openFoldersModule(foldersCount: foldersService.getFolders().count)
    }

    func didSelectCell(at indexPath: IndexPath) {
        timerEnd()
        guard let noute = notes[safe: indexPath.row] else {
            router?.openCreateNouteModule()
            return
        }
        router?.openNouteModule(noute: noute)
    }

    func createNouteTap() {
        timerEnd()
        router?.openCreateNouteModule()
    }

    func settingsTap() {
        timerEnd()
        router?.openSettingsModule()
    }

    func deleteNouteClick(_ index: Int) {
        interactor?.reportDeleteNote()
        timerEnd()
        guard let noute = notes[safe: index] else { return }
        view?.showBottomAlert(with: .init(text: Localized.noteIsDelete(), isCancelButtonShow: true))
        notes.remove(at: index)
        deleteNoute = noute
        deleteIndex = index
        view?.deleteRows(index)
    }

    func nouteChanged(nouteIndex: Int, newFolder: String?) {
        notes = notesService.getNoutes()
        if let newFolder = newFolder {
            view?.showBottomAlert(with: .init(text: "\(Localized.noteMoveInFolder()) «\(newFolder)»", isCancelButtonShow: false))
            if currentFolder.id != "all" {
                view?.deleteRows(nouteIndex)
            } else {
                view?.update(noutes: notes, animateRow: nil)
            }
        } else {
            view?.updateWithMove(noutes: notes, from: nouteIndex, there: 0)
        }
    }

    func getFoldersForMove(for note: NoteModel) -> [FolderModel] {
        return foldersService.getFolders().filter { folder in
            note.folderID?.uppercased() != folder.id.uppercased()
        }
    }

    func moveToFolder(_ folder: FolderModel, note: NoteModel, index: Int) {
        let newNote = NoteModel(id: note.id,
                                name: note.name,
                                text: note.text,
                                folderID: folder.id,
                                date: note.date)
        notesService.updateNote(newNote)

        nouteChanged(nouteIndex: index, newFolder: folder.name)
    }

}

// MARK: - NoutesListInteractorOutput
extension NoutesListPresenter: NoutesListInteractorOutput {

}

extension NoutesListPresenter: DeleteNouteStatusViewDelegate {
    func timerEnd() {
        view?.hideDeleteView()
        guard let noute = deleteNoute else { return }
        notesService.deleteNoute(noute)
        deleteNoute = nil
        deleteIndex = nil
    }

    func cancelButtonClick() {
        view?.hideDeleteView()
        guard let noute = deleteNoute, let index = deleteIndex else { return }
        notes.insert(noute, at: index)
        view?.update(noutes: notes, animateRow: index)
        deleteNoute = nil
        deleteIndex = nil
    }

}
