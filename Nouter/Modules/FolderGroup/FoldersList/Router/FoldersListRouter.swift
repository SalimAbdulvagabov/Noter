//
//  FoldersListRouter.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 13.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import Foundation

final class FoldersListRouter {

    // MARK: - Properties

    weak var transition: ModuleTransitionHandler?

    // MARK: - Init

    init(transition: ModuleTransitionHandler?) {
        self.transition = transition
    }
}

// MARK: - oldersListRouterInput
extension FoldersListRouter: FoldersListRouterInput {
    func dismissModule() {
        transition?.closeModule()
    }

    func openNewFolderModule() {
        transition?.showBottomSheet(moduleType: NewFolderAssembly.self, sizes: [.fixed(PopUpsHeights.newFolder.value)])
    }

    func openEditFolderModule(folder: FolderModel) {
        transition?.showBottomSheet(with: NewFolderAssembly.Model(folder: folder), openModuleType: NewFolderAssembly.self, sizes: [.fixed(PopUpsHeights.newFolder.value)])
    }

}
