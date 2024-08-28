//
//  FoldersListInteractorInput.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 13.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import Foundation

protocol FoldersListInteractorInput {
    func getFolders() -> [FolderModel]
    func getCurrentFolder() -> FolderModel
    func reSaveFolders(_ folders: [FolderModel])
    func changeCurrentFolder(_ folderID: String)
    func deleteFolder(_ folder: FolderModel, withNotes: Bool)
}
