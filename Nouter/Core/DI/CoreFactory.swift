//
//  CoreFactory.swift
//  05.ru
//
//  Created by Cалим on 16.05.2022.
//  Copyright © 2022 Салим. All rights reserved.
//

import Foundation

extension DependecyContainer {

    final class CoreFactory: DependencyFactory {

        var dataBase: DatabaseManagerProtocol {
            return unshared( factory: {
                return DatabaseManager()
            })
        }

        var apperance: ApperanceManager {
            return unshared( factory: {
                return ApperanceManager()
            })
        }

        var siri: SiriManager {
            unshared( factory: {
                SiriManager()
            })
        }

    }
}
