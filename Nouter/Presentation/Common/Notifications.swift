//
//  Notifications.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 18.11.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Foundation

final class Notifications: NSObject {
    static func post(name: NSNotification.Name) {
        Notifications.post(name: name, userInfo: nil)
    }

    static func post(name: NSNotification.Name, userInfo: [AnyHashable: Any]?) {
        print("Post Notification: \(name.rawValue)")
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }

    static func addObserver(_ observer: Any, selector: Selector, names: [NSNotification.Name]) {
        for name in names {
            NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: nil)
        }
    }

    static func removeObserver(_ observer: Any, names: [NSNotification.Name]) {
        for name in names {
            NotificationCenter.default.removeObserver(observer, name: name, object: nil)
        }
    }

    static func removeAllObservers(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer, name: nil, object: nil)
    }
}

extension String {
    public var toNotificationName: NSNotification.Name {
        return Notification.Name(self)
    }
}

extension Notification.Name {
    static let nouteCreated             = "nouteCreated".toNotificationName // Создана заметка
    static let nouteChanged             = "nouteChanged".toNotificationName // Изменена заметка
    static let deleteNoute              = "deleteNoute".toNotificationName // Удалена заметка
    static let launchSettingsEnded      = "launchSettingsEnded".toNotificationName // Закончено редактирование настроек на Launch-экране
    static let folderCreated            = "folderCreated".toNotificationName  // Папка создана
    static let currentFolderChanged     = "currentFolderChanged".toNotificationName  // Текущая папка изменена
}
