//
//  CoreFactory.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 16.05.2023.
//  Copyright © 2023 Салим Абдулвагабов. All rights reserved.
//

import Foundation

extension CompositionFactory {

    final class CoreFactory: DependencyFactory {

        var folders: FolderService {

            return shared( factory: {
                return FolderService()
            })
        }

        var notes: NotesService {

            return shared( factory: {
                return NotesService()
            })
        }

        var coreData: CoreDataService {

            return shared(factory: {
                return CoreDataService()
            })
        }

        var notifications: NotificationsService {

            return shared( factory: {
                return NotificationsService()
            })
        }

        var settings: SettingsService {

            return weakShared( factory: {
                return SettingsService()
            })
        }

        var apperance: ApperanceManager {
            return weakShared( factory: {
                return ApperanceManager()
            })
        }

    }
}
