//
//  RadnomNoteHandler.swift
//  NouterIntent
//
//  Created by Салим Абдулвагабов on 27.03.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Foundation

class RandomNoteHandler: NSObject, RandomNoteIntentHandling {
    func handle(intent: RandomNoteIntent, completion: @escaping (RandomNoteIntentResponse) -> Void) {
        if let userDefaults = UserDefaults(suiteName: "group.nouter.core.data") {
            userDefaults.set("RandomNoteHandler", forKey: "www")
            userDefaults.synchronize()
        }
        completion(RandomNoteIntentResponse(code: .success, userActivity: nil))
    }

}
