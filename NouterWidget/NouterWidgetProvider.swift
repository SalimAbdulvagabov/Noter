//
//  NouterWidgetProvider.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 15.12.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//
import WidgetKit
import SwiftUI
import Intents

struct NouterWidgetProvider: IntentTimelineProvider {
    typealias Entry = SimpleEntry

    private let notesService = NotesRandomService()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), note: notesService.emptyNotesState(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), note: notesService.snapshotState(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 24 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, note: notesService.getRandonNote(), configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let note: NoteModel?
    let configuration: ConfigurationIntent
}
