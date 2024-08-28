//
//  RouterInput.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 16.05.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

protocol RouterInput {
    var transition: ModuleTransitionHandler? { get }
    func dismissModule()
}

extension RouterInput {

    func dismissModule() {
        transition?.closeModule()
    }
}
