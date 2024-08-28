//
//  SettingsDataProvider.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

protocol SettingsDataProviderInput {
    func createViewModel() -> SettingsViewModel
}

final class SettingsDataProvider: SettingsDataProviderInput {

    // MARK: - Typealiases

    typealias SettingsCellConfig = TableCellConfigurator<SettingsCell, SettingsCell.Model>

    // MARK: - SettingsDataProviderInput

    func createViewModel() -> SettingsViewModel {
        var rows: [SettingsViewModel.Row] = []

        rows.append(.separator(configurator: SeparatorCellConfigurator(item: Colors.screenBackground(),
                                                                       cellHeight: 12)))
        rows.append(.notifications(configurator: SettingsCellConfig(item: SettingsCell.Model(icon: Images.notificationsIcon(),
                                                                                             name: Localized.notifications(),
                                                                                             showBottomSeparator: true))))

        rows.append(.separator(configurator: SeparatorCellConfigurator(item: Colors.screenBackground(),
                                                                       cellHeight: 8)))

        rows.append(.apperance(configurator: SettingsCellConfig(item: SettingsCell.Model(icon: Images.apperance(),
                                                                                             name: Localized.apperance(),
                                                                                             showBottomSeparator: false))))

        rows.append(.separator(configurator: SeparatorCellConfigurator(item: Colors.screenBackground(),
                                                                       cellHeight: 8)))

        rows.append(.separator(configurator: SeparatorCellConfigurator(item: Colors.separator(),
                                                                       cellHeight: 16)))

        rows.append(.separator(configurator: SeparatorCellConfigurator(item: Colors.screenBackground(),
                                                                       cellHeight: 8)))

        rows.append(.siriCommands(configurator: SettingsCellConfig(item:
                                                                    SettingsCell.Model(
                                                                        icon: Images.shortcutsMini(),
                                                                        name: Localized.siriCommands(),
                                                                        showBottomSeparator: true
                                                                    ))))

        rows.append(.reportProblem(configurator: SettingsCellConfig(item: SettingsCell.Model(icon: Images.reportProblemIcon(),
                                                                                             name: Localized.reportProblem(),
                                                                                             showBottomSeparator: true))))

        rows.append(.rateApp(configurator: SettingsCellConfig(item: SettingsCell.Model(icon: Images.rateAppIcon(),
                                                                                             name: Localized.rateApp(),
                                                                                             showBottomSeparator: true))))

        rows.append(.blog(configurator: SettingsCellConfig(item: SettingsCell.Model(icon: Images.blogIcon(),
                                                                                    name: Localized.blog(),
                                                                                    showBottomSeparator: false))))

        return SettingsViewModel(rows: rows)
    }
}
