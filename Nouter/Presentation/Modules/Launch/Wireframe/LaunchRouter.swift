//
//  LaunchRouter.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 20.02.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

protocol LaunchRouterInput {
    func showNouteListModule()
    func openSettingsModule()
}

final class LaunchRouter {

    // MARK: - Properties

    weak var transition: ModuleTransitionHandler?

    // MARK: - Init

    init(transition: ModuleTransitionHandler?) {
        self.transition = transition
    }

}

// MARK: - LaunchRouterInput
extension LaunchRouter: LaunchRouterInput {
    func showNouteListModule() {

    }

    func openSettingsModule() {
        transition?.showBottomSheet(moduleType: LaunchSettingsAssembly.self, sizes: [.fixed(PopUpsHeights.notificationsFromOnbording.value)])
    }

}
