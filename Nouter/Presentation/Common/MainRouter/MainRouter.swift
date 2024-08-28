//
//  MainRouter.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 16.05.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class MainRouter {

    // MARK: - Singleton

    static let shared = MainRouter()

    // MARK: - Properties

    var rootViewController: UIViewController? {
        guard let window = UIApplication.shared.windows.first else { return nil }
        return window.rootViewController
    }

    var window: UIWindow {
        guard let window = UIApplication.shared.windows.first else {

            let window = UIWindow(frame: UIScreen.main.bounds)
            window.makeKeyAndVisible()
            return window
        }

        return window
    }

    // MARK: - Init

    private init() { }

    // MARK: - Public methods

    func replaceRootController(on view: UIViewController) {
        window.rootViewController = view
    }

    func replaceRootController<ModuleType: Assembly>(moduleType: ModuleType.Type) {
        let view = moduleType.assembleModule()
        replaceRootController(on: view)
    }

    func presentOnRoot(view: UIViewController, animated: Bool, completion: (() -> Void)?) {
        window.rootViewController?.present(view, animated: animated, completion: completion)
    }

    func presentOnRoot<ModuleType: Assembly>(with model: TransitionModel, openModuleType: ModuleType.Type) {
        window.rootViewController?.present(with: model, openModuleType: openModuleType)
    }

    func presentOnRoot<ModuleType: Assembly>(moduleType: ModuleType.Type) {
        window.rootViewController?.present(moduleType: moduleType)
    }

    // MARK: - Deeplinks

    func openNoteScreen(with id: String?) {
        guard let isFirstVisit = UserDefaults.standard.value(forKey: UserDefaultsKeys.isFistVisit.rawValue) as? Bool,
              !isFirstVisit else { return }
        let notesService = DependecyContainer.shared.service.notes
        window.rootViewController = NoutesListAssembly.assembleModule()

        if let id = id, let note = notesService.getNoutes().first(where: {$0.id.uppercased() == id.uppercased()}) {
            window.rootViewController?.present(with: CreateNouteAssembly.Model(noute: note), openModuleType: CreateNouteAssembly.self)
        } else {
            window.rootViewController?.present(moduleType: CreateNouteAssembly.self)
        }
    }
}
