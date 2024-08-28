//
//  NoteDataBaseObject.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 24.01.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Realm
import RealmSwift

class NoteDataBaseObject: Object {
    @objc dynamic var uuid: String = UUID().uuidString
    @objc dynamic var name: String?
    @objc dynamic var text: String?
    @objc dynamic var folderID: String?
    @objc dynamic var date: Date = Date()

    override class func primaryKey() -> String? {
        "uuid"
    }

    convenience init(_ model: NoteModel) {
        self.init()
        self.uuid = model.id
        self.name = model.name
        self.text = model.text
        self.folderID = model.folderID
        self.date = model.date
    }
}

extension NoteDataBaseObject {
    func convertToNoute() -> NoteModel {
        .init(id: uuid, name: name, text: text, folderID: folderID, date: date)
    }
}
