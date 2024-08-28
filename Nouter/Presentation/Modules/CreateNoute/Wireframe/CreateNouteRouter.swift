//
//  CreateNouteRouter.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
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
