//
//  NouteModel.swift
//  Nouter
//
//  Created by Рамазан Магомедов on 22.10.2020.
//  Copyright © 2020 Рамазан Магомедов. All rights reserved.
//

import Foundation
import CoreData

struct NouteModel {
    let id: String
    let name: String?
    let text: String?
    let date: Date
    var folderID: String?

    enum CoreDataKeys: String {
        case id, name, text, date, folderID
    }

    init(id: String, name: String?, text: String?, date: Date = Date(), folderID: String? = nil) {
        self.id = id
        self.name = name
        self.text = text
        self.date = date
        self.folderID = folderID
    }

    init(object: NSManagedObject) {
        let id = object.value(forKey: CoreDataKeys.id.rawValue) as? String ?? ""
        let name = object.value(forKey: CoreDataKeys.name.rawValue) as? String
        let text = object.value(forKey: CoreDataKeys.text.rawValue) as? String
        let date = object.value(forKey: CoreDataKeys.date.rawValue) as? Date ?? Date()
        let folderID = object.value(forKey: CoreDataKeys.folderID.rawValue) as? String
        self.init(id: id, name: name, text: text, date: date, folderID: folderID)
    }

    func covertToNSManagedObject(context: NSManagedObjectContext) -> NSManagedObject? {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return nil }
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(id, forKey: CoreDataKeys.id.rawValue)
        object.setValue(name, forKeyPath: CoreDataKeys.name.rawValue)
        object.setValue(text, forKeyPath: CoreDataKeys.text.rawValue)
        object.setValue(date, forKeyPath: CoreDataKeys.date.rawValue)
        object.setValue(folderID, forKeyPath: CoreDataKeys.folderID.rawValue)
        return object
    }

}

extension NouteModel: Equatable {
    static func == (lhs: NouteModel, rhs: NouteModel) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.text == rhs.text &&
            lhs.date == rhs.date &&
            lhs.folderID == rhs.folderID
    }
}

private let entityName = "Noute"
