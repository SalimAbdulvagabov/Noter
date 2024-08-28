//
//  NotesApi.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 09.01.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Alamofire

enum NotesApi: IEndpoint {

    case update(note: NoteModel)
    case delete(id: String)
    case load

    var path: String {
        "note"
    }

    var method: HTTPMethod {
        switch self {
        case .update:
            return .post
        case .delete:
            return .delete
        case .load:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .update(let note):
            var dict = note.toDictionary()
            dict["userUuid"] = DependecyContainer.shared.service.settings.userUuid()
            return dict

        case .delete(let id):
            return [
                "id": id
            ]

        case .load:
            return ["userUuid": DependecyContainer.shared.service.settings.userUuid()]
        }
    }

}
