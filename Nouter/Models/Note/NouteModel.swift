//
//  NoteModel.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 22.10.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Foundation
import CoreData

struct NoteModel: Codable {
    let id: String
    let name: String?
    let text: String?
    let date: Date
    let folderID: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case text = "text"
        case date = "date"
        case folderID = "folderId"
    }

    init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: CodingKeys.self)
        id = try containter.decode(String.self, forKey: .id)
        name = try? containter.decode(String.self, forKey: .name)
        text = try? containter.decode(String.self, forKey: .text)
        folderID = try? containter.decode(String.self, forKey: .folderID)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = .dateFormat
        let dateText = try containter.decode(String.self, forKey: .date)
        date = dateFormatter.date(from: dateText) ?? Date()
    }

    func encode(to encoder: Encoder) throws {
        var containter = encoder.container(keyedBy: CodingKeys.self)

        try containter.encode(id, forKey: .id)
        try? containter.encode(name, forKey: .name)
        try? containter.encode(text, forKey: .text)
        try? containter.encode(folderID, forKey: .folderID)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = .dateFormat
        let dateText = dateFormatter.string(from: date)
        try containter.encode(dateText, forKey: .date)
    }

    init(id: String = UUID().uuidString, name: String?, text: String?, folderID: String? = nil, date: Date = Date()) {
        self.id = id.uppercased()
        self.name = name
        self.text = text
        self.date = date
        self.folderID = folderID?.uppercased()
    }

    func toDictionary() -> [String: Any] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = .dateFormat
        return [
            CodingKeys.id.rawValue: id,
            CodingKeys.name.rawValue: name ?? "",
            CodingKeys.text.rawValue: text ?? "",
            CodingKeys.folderID.rawValue: folderID ?? "",
            CodingKeys.date.rawValue: dateFormatter.string(from: date)
        ]
    }

}

extension NoteModel: Equatable {
    static func == (lhs: NoteModel, rhs: NoteModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.text == rhs.text &&
        lhs.date == rhs.date &&
        lhs.folderID == rhs.folderID
    }
}

private extension String {
    static let dateFormat = "yyyy-MM-dd HH:mm:ss"
}
