//
//  CoreFactory.swift
//  05.ru
//
//  Created by Рамазан on 16.05.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
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
