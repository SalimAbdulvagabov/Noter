//
//  AnalyticsFactory.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 07.04.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Foundation

extension DependecyContainer {

    final class AnalyticsFactory: DependencyFactory {

        var events: AnalyticsService {

            return shared( factory: {
                return AnalyticsService()
            })
        }

    }
}
