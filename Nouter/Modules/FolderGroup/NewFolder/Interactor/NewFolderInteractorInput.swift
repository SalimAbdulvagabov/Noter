//
//  NewFolderInteractorInput.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 27.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import Foundation

protocol NewFolderInteractorInput {
    func saveFolder(_ folder: FolderModel)
    func foldersCount() -> Int
}
