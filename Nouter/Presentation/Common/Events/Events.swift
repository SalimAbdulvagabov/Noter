//
//  Events.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 07.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

struct Events {
    enum Launch: String {
        case launch = "Launch"
        case settings = "Launch.settings"
        case skip = "Launch.skip"
    }

    enum Apperance: String {
        case apperance = "ApperanceSettings"
        case changeIcon = "ApperanceSettings.change.icon"
        case changeTheme = "ApperanceSettings.change.theme"
    }

    enum Settings: String {
        case settings = "Settings"
        case feedback = "Feedback"
        case rateTheApp = "Rate.the.app"
    }

    enum NotificationsSettings: String {
        case settings = "NotificationsSettings"
        case changeSettings = "NotificationsSettings.change"
        case notChangeSettings = "NotificationsSettings.not.change"
        case disabled = "NotificationsSettings.disabled"
        case enabled = "NotificationsSettings.enabled"
        case sheduleSettings = "SheduleSettings"
    }

    enum SingleNote: String {
        case singleNote = "SingleNote"
        case create = "SingleNote.create"
        case delete = "SingleNote.delete"
        case clear = "SingleNote.clear"
        case change = "SingleNote.change"
    }

    enum NotesList: String {
        case notesList = "NotesList"
        case delete = "NotesList.delete"
    }

}
