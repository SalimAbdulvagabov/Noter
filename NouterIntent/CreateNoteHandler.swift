//
//  CreateNoteHandler.swift
//  NouterIntent
//
//  Created by Салим Абдулвагабов on 27.03.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Intents

class CreateNoteHandler: NSObject, CreateNoteIntentHandling {
    func handle(intent: CreateNoteIntent, completion: @escaping (CreateNoteIntentResponse) -> Void) {
        let text = (intent.text ?? "")
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet.whitespaces)
        guard !text.isEmpty else {
            completion(CreateNoteIntentResponse(code: .failure, userActivity: nil))
            return
        }

        let response = CreateNoteIntentResponse(code: .success, userActivity: nil)
        response.text = text
        if let userDefaults = UserDefaults(suiteName: "group.nouter.core.data") {
            userDefaults.set(text, forKey: "savedText")
            userDefaults.synchronize()
        }
        completion(response)
    }

    func resolveText(for intent: CreateNoteIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        let text = (intent.text ?? "")
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet.whitespaces)
        guard !text.isEmpty else {
            completion(INStringResolutionResult.needsValue())
            return
        }
        completion(INStringResolutionResult.success(with: text))
    }

}
