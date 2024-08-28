//
//  FolderDataBaseObject.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 30.01.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Realm
import RealmSwift

class FolderDataBaseObject: Object {
    @objc dynamic var uuid: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var position: Int = 1
    @objc dynamic var enable: Bool = true
    @objc dynamic var count: Int = 0

    override class func primaryKey() -> String? {
        "uuid"
    }

    convenience init(_ model: FolderModel) {
        self.init()
        self.uuid = model.id
        self.name = model.name
        self.position = model.position
        self.enable = model.enable
        self.count = model.count
    }
}
