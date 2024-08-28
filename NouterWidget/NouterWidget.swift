//
//  NouterWidget.swift
//  NouterWidgetExtension
//
//  Created by Салим Абдулвагабов on 17.12.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//
import WidgetKit
import SwiftUI
import Intents

@main
struct NouterWidget: Widget {
    let kind: String = "NouterWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: NouterWidgetProvider()) { entry in
            NouterWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Случайная заметка")
        .description("Каждый час, случайным образом, выводит одну из ваших заметок..")
        .supportedFamilies([.systemMedium])
    }
}
