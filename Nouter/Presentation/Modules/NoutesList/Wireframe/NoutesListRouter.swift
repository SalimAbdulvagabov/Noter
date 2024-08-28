//
//  NoutesListRouter.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

protocol NoutesListRouterInput {
    func openCreateNouteModule()
    func openNouteModule(noute: NoteModel)
    func openSettingsModule()
    func openWeReturnModule()
    func openFoldersModule(foldersCount: Int)
}

final class NoutesListRouter {

    // MARK: - Properties

    weak var transition: ModuleTransitionHandler?

    // MARK: - Init

    init(transition: ModuleTransitionHandler?) {
        self.transition = transition
    }

}

// MARK: - NoutesListRouterInput
extension NoutesListRouter: NoutesListRouterInput {
    func openCreateNouteModule() {
        transition?.present(moduleType: CreateNouteAssembly.self)
    }

    func openSettingsModule() {
        transition?.showBottomSheet(moduleType: SettingsAssembly.self, sizes: [.fixed(PopUpsHeights.settings.value)])
    }

    func openNouteModule(noute: NoteModel) {
        transition?.present(with: CreateNouteAssembly.Model(noute: noute), openModuleType: CreateNouteAssembly.self)
    }

    func openWeReturnModule() {
        transition?.showBottomSheet(moduleType: WeReturnAssembly.self, sizes: [.fixed(PopUpsHeights.weReturn.value)])
    }

    func openFoldersModule(foldersCount: Int) {
        transition?.showBottomSheet(moduleType: FoldersListAssembly.self, sizes: [.fixed(PopUpsHeights.folders(count: foldersCount).value)])
    }
}
