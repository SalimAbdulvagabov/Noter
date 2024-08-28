//
//  IntentHandler.swift
//  NouterIntent
//
//  Created by Салим Абдулвагабов on 13.03.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Intents

class IntentHandler: INExtension {

    override func handler(for intent: INIntent) -> Any {
        switch intent {
        case is RandomNoteIntent:
            return RandomNoteHandler()
        case is CreateNoteIntent:
            return CreateNoteHandler()
        default:
            fatalError("Unhandled Intent error : \(intent)")
        }
    }
}
