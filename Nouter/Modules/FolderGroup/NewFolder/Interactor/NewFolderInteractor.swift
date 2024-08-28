//
//  NewFolderInteractor.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 27.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import Foundation

final class NewFolderInteractor {

    // MARK: - Properties

    weak var output: NewFolderInteractorOutput?
    private let analyticsService: AnalyticsService
    private let foldersService: FoldersService

    // MARK: - Init

    init(analyticsService: AnalyticsService, foldersService: FoldersService) {
        self.analyticsService = analyticsService
        self.foldersService = foldersService
    }

}

extension NewFolderInteractor: NewFolderInteractorInput {
    func saveFolder(_ folder: FolderModel) {
        foldersService.saveFolder(folder)
    }

    func foldersCount() -> Int {
        return foldersService.getFolders().count + 1
    }
}
