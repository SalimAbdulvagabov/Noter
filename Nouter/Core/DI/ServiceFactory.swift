//
//  ServiceFactory.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 16.05.2022.
//  Copyright © 2022 Рамазан. All rights reserved.
//

extension DependecyContainer {

    final class ServiceFactory: DependencyFactory {
        var notes: NotesService {

            return shared( factory: {
                return NotesService(networkProvider: NetworkProvider(),
                                    dataBaseManager: DatabaseManager())
            })
        }

        var settings: SettingsService {

            return weakShared( factory: {
                return SettingsService(networkProvider: NetworkProvider())
            })
        }

        var folders: FoldersService {

            return shared( factory: {
                return FoldersService(networkProvider: NetworkProvider(),
                                      dataBaseManager: DatabaseManager())
            })
        }

    }
}
