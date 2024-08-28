//
//  FoldersListViewOutput.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 13.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

protocol FoldersListViewOutput: ViewOutput {
    func closeButtonClick()
    func plusButtonClick()
    func selectFolder(folder: FolderModel)
    func deleteFolder(index: Int)
    func changeFolder(index: Int)
    func viewWillDisappear(with folders: [FolderModel])
}
