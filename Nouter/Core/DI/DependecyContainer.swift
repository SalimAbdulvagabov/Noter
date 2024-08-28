//
//  DependecyContainer.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 16.05.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Foundation

final class DependecyContainer: DependencyFactory {

    static let shared = DependecyContainer()

    private override init() {
        super.init()
    }

    var core: CoreFactory {

        return shared( factory: {
            return CoreFactory()
        })

    }

    var service: ServiceFactory {

        return shared( factory: {
            return ServiceFactory()
        })

    }

    var analytics: AnalyticsFactory {

        return shared( factory: {
            return AnalyticsFactory()
        })

    }

}
