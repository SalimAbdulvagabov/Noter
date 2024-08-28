//
//  ApperanceSettingsRouter.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

protocol ApperanceSettingsRouterInput {
    func dismissModule()
}

final class ApperanceSettingsRouter {

    // MARK: - Properties

    weak var transition: ModuleTransitionHandler?

    // MARK: - Init

    init(transition: ModuleTransitionHandler?) {
        self.transition = transition
    }

}

// MARK: - ApperanceSettingsRouterInput
extension ApperanceSettingsRouter: ApperanceSettingsRouterInput {
    func dismissModule() {
        transition?.closeNavigationStack()
    }
}
