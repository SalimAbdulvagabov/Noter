//
//  NotesRandomService.swift
//  NouterWidgetExtension
//
//  Created by Салим Абдулвагабов on 17.12.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//
import Foundation

final class NotesRandomService {

    let dataBaseManager = DatabaseManager()

    func getRandonNote() -> NoteModel? {
        let notes: [NoteDataBaseObject] = dataBaseManager.load(filter: nil)
        guard let randomElement = notes.randomElement() else {
            return emptyNotesState()
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

    func snapshotState() -> NoteModel {
        .init(id: "zero",
              name: nil,
              text: "Пора отвлечься от работы! Встань, пройдись, разомнись",
              date: Date()
        )
    }

}
