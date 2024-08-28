//
//  NotesService.swift
//  NouterIntentUI
//
//  Created by Салим Абдулвагабов on 16.03.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Foundation

struct NotesService {
    let dataBaseManager = DatabaseManager()

    func getRandonNote() -> NoteModel {

        if let userDefaults = UserDefaults(suiteName: "group.nouter.core.data"),
           let text = userDefaults.value(forKey: "savedText") as? String {
            userDefaults.removeObject(forKey: "savedText")
            let note = NoteModel(name: nil, text: text)
            userDefaults.set(note.id, forKey: "shortcutNoteID")
            userDefaults.synchronize()

            dataBaseManager.save(
                NoteDataBaseObject(note),
                shouldUpdate: false)

            return .init(name: nil, text: text)
        }

        let notes: [NoteDataBaseObject] = dataBaseManager.load(filter: nil)
        guard let randomElement = notes.randomElement() else {
            return emptyNotesState()
        }

        if let userDefaults = UserDefaults(suiteName: "group.nouter.core.data") {
            userDefaults.set(randomElement.uuid, forKey: "shortcutNoteID")
            userDefaults.synchronize()
        }

        return .init(
            id: randomElement.uuid,
            name: randomElement.name,
            text: randomElement.text,
            date: randomElement.date
        )
    }

    func emptyNotesState() -> NoteModel {
        .init(
            id: "zero",
            name: nil,
            text: "Мне пока не о чем вам напомнить. Нажмите, чтобы создать свою первую заметку",
            date: Date()
        )
    }
}
