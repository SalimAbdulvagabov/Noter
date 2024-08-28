//
//  NewFolderRouter.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 27.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import Foundation

final class NewFolderRouter {

    // MARK: - Properties

    weak var transition: ModuleTransitionHandler?

    // MARK: - Init

    init(transition: ModuleTransitionHandler?) {
        self.transition = transition
    }
}

// MARK: - oldersListRouterInput
extension NewFolderRouter: NewFolderRouterInput {
    func dismissModule() {
        transition?.closeModule()
    }

}
