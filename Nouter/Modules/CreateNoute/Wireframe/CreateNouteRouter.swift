//
//  CreateNouteRouter.swift
//  AppName
//
//  Created Рамазан Магомедов on 01.01.1945.
//  Copyright © 2020 Рамазан Магомедов. All rights reserved.
//

import UIKit

protocol CreateNouteRouterInput {
    func dismissModule()
}

final class CreateNouteRouter {

    // MARK: - Properties

    weak var transition: ModuleTransitionHandler?

    // MARK: - Init

    init(transition: ModuleTransitionHandler?) {
        self.transition = transition
    }

}

// MARK: - CreateNouteRouterInput
extension CreateNouteRouter: CreateNouteRouterInput {
    func dismissModule() {
        transition?.closeModule()
    }
}
