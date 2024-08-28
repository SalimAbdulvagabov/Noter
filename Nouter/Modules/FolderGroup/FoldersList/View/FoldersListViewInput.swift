//
//  FoldersListViewInput.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 13.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import Foundation

protocol FoldersListViewInput: AlertPresentable, Loadable {
    func setupInitialState(_ folders: [FolderModel], current: FolderModel)
    func removeRow(_ row: Int)
    func setDefaultFolder()
}
