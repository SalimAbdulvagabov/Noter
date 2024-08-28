//
//  FoldersListRouterInput.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 13.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import Foundation

protocol FoldersListRouterInput {
    func dismissModule()
    func openNewFolderModule()
    func openEditFolderModule(folder: FolderModel)
}
