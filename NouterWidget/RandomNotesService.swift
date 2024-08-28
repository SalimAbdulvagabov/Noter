//
//  RandomNotesService.swift
//  NouterWidgetExtension
//
//  Created by Ramazan on 17.12.2021.
//  Copyright © 2021 Рамазан Магомедов. All rights reserved.
//

final class RandomNotesService {

    private let coreDataService = NotesService()

    func getRandonNote() -> NouteModel? {
        return coreDataService.getNoutes().randomElement()
    }

}
