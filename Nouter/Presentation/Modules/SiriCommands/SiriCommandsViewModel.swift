//
//  SiriCommandsViewModel.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 19.03.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Combine
import Intents

final class SiriCommandsViewModel {

    // MARK: - Public: Properties

    @Published var commands: [String] = []
    @Published var editShortcut: INVoiceShortcut?
    @Published var newShortcut: INShortcut?

    // MARK: - Private: Properties

    private let siriManager: SiriManager

    private var siriShortcuts: [SiriCommand] = []
    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Init

    init(siriManager: SiriManager) {
        self.siriManager = siriManager

        loadSaveCommands()
    }

    // MARK: - Public: Funcs

    func didSelectRow(_ row: Int) {
        guard let shortcutType = siriShortcuts[safe: row] else {
            return
        }

        switch shortcutType {
        case .add(let shortcut):
            newShortcut = shortcut
        case .edit(let shortcut):
            editShortcut = shortcut
        }
    }

    func shortcutsUpdate() {
        loadSaveCommands()
    }

    // MARK: - Private: Funcs

    private func loadSaveCommands() {
        siriManager.getCommands { [weak self] shortcuts in
            self?.siriShortcuts = shortcuts
            self?.commands = shortcuts.map { shortcut in
                switch shortcut {
                case .add(let shortcut):
                    return shortcut.intent?.suggestedInvocationPhrase ?? ""
                case .edit(let voiceShourtcut):
                    return voiceShourtcut.invocationPhrase
                }
            }
        }
    }

}
