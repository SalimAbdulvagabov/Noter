//
//  FoldersListInteractor.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 13.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import Foundation

final class FoldersListInteractor {

    // MARK: - Properties

    weak var output: FoldersListInteractorOutput?
    private let analyticsService: AnalyticsService
    private let foldersService: FoldersService

    // MARK: - Init

    init(analyticsService: AnalyticsService, foldersService: FoldersService) {
        self.analyticsService = analyticsService
        self.foldersService = foldersService
    }

}

extension FoldersListInteractor: FoldersListInteractorInput {
    func getFolders() -> [FolderModel] {
        foldersService.getFolders()
    }

    func reSaveFolders(_ folders: [FolderModel]) {
        DispatchQueue.global().async {[weak self] in
            self?.foldersService.saveFolders(folders)
        }
    }

    func changeCurrentFolder(_ folderID: String) {
        foldersService.saveCurrentFolder(folderID)
    }

    func getCurrentFolder() -> FolderModel {
        foldersService.getCurrentFolder()
    }

    func deleteFolder(_ folder: FolderModel, withNotes: Bool) {
        foldersService.deleteFolder(folder, withNotes: withNotes)
    }
}
