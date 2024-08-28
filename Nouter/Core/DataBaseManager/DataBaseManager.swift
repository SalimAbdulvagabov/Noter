//
//  DataBaseManager.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 23.01.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol DatabaseManagerProtocol {
    /// Сохранение одного объекта
    /// - Parameters:
    ///   - object: объект
    ///   - shouldUpdate: нужно ли обновлять существующий
    func save<T: Object>(_ object: T, shouldUpdate: Bool)
    /// Сохранение массива объектов
    /// - Parameters:
    ///   - collection: массив
    ///   - shouldUpdate: нужно ли обновлять существующий
    func save<T: Object>(_ collection: [T], shouldUpdate: Bool)
    /// Загрузить объекты определенного типа с опциональным фильтром
    /// - Parameters:
    ///   - filter: Фильтр
    func load<T: Object>(filter: ((T) -> Bool)?) -> [T]
    /// Удалить объекты из базы
    /// - Parameter objects: объекты для удаления
    func delete<T: Object>(_ objects: [T])
    /// Удалить базу
    func eraseAll()
    /// Миграция базы данных
    /// - Parameter schemaVersion: Новая версия базы данных
    func migrate(with schemaVersion: UInt64)
}

final class DatabaseManager: DatabaseManagerProtocol {

    /// Для доступа с разных потоков нужен новый инстанст реалма, поэтому свойство вычисляемое
    private var realm: Realm {
        do {
            let container = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: "group.nouter.core.data"
            )
            let realmURL = container?.appendingPathComponent("default.realm")
            let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 2)
            return try Realm(configuration: config)
        } catch {
            print(error)
            fatalError("Cannot instantiate Realm")
        }
    }

    func migrate(with schemaVersion: UInt64) {
        let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: { migration, _ in
            print("Successful migration to \(migration.newSchema)")
        }, deleteRealmIfMigrationNeeded: false)

        Realm.Configuration.defaultConfiguration = config
        print("Realm path: \(realm.configuration.fileURL?.absoluteString ?? "")")
    }

    func save<T: Object>(_ object: T, shouldUpdate: Bool) {
        do {
            try realm.write {
                if shouldUpdate {
                    realm.add(object, update: .modified)
                } else {
                    realm.add(object)
                }
            }
        } catch {
            print(error)
        }
    }

    func save<T: Object>(_ collection: [T], shouldUpdate: Bool) {
        guard !collection.isEmpty else {
            return
        }

        do {
            try realm.write {
                if shouldUpdate {
                    realm.add(collection, update: .modified)
                } else {
                    realm.add(collection)
                }
            }
        } catch {
            print(error)
        }
    }

    func load<T: Object>(filter: ((T) -> Bool)? = nil) -> [T] {
        let objects = realm.objects(T.self)
        var result: [T] = []
        if let filter = filter {
            result = objects.filter(filter)
            return result
        } else {
            return objects.map { object -> T in
                return object
            }
        }
    }

    func delete<T: Object>(_ objects: [T]) {
        guard !objects.isEmpty else {
            return
        }

        do {
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            print(error)
        }
    }

    func eraseAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
    }
}
