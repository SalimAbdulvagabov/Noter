//
//  Assembly.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 16.05.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

protocol TransitionModel { }

protocol Assembly {
    static func assembleModule() -> UIViewController
    static func assembleModule(with model: TransitionModel) -> UIViewController
}

extension Assembly {

    static func assembleModule() -> UIViewController {
        fatalError("implement assembleModule() in ModuleAssembly")
    }

    static func assembleModule(with model: TransitionModel) -> UIViewController {
        fatalError("implement assembleModule(with model: TransitionModel) in ModuleAssembly")
    }
}
