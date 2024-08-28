//
//  SettingsViewModel.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit.UIView

struct SettingsViewModel {

    let rows: [Row]

    enum Row {

        case notifications(configurator: TableCellConfiguratorProtocol)
        case blog(configurator: TableCellConfiguratorProtocol)
        case apperance(configurator: TableCellConfiguratorProtocol)
        case reportProblem(configurator: TableCellConfiguratorProtocol)
        case rateApp(configurator: TableCellConfiguratorProtocol)
        case siriCommands(configurator: TableCellConfiguratorProtocol)
        case separator(configurator: TableCellConfiguratorProtocol)

        var configurator: TableCellConfiguratorProtocol {

            switch self {

            case let .notifications(configurator),
                let .blog(configurator),
                let .apperance(configurator),
                let .reportProblem(configurator),
                let .separator(configurator),
                let .siriCommands(configurator),
                let .rateApp(configurator):

                return configurator
            }
        }

        var reuseId: String {
            return type(of: configurator).reuseId
        }
    }
}
