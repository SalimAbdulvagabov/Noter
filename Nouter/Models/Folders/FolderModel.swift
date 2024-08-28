//
//  FolderModel.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 15.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import Foundation
import CoreData

struct FolderModel: Decodable {
    let id: String
    let name: String
    let position: Int
    let enable: Bool
    let count: Int

    enum CodingKeys: String, CodingKey {
        case id, name, position, enable, count
    }

    init(id: String, name: String, position: Int, enable: Bool, count: Int) {
        self.id = id
        self.name = name
        self.position = position
        self.enable = enable
        self.count = count
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        position = try values.decode(Int.self, forKey: .position)
        enable = try values.decode(Bool.self, forKey: .enable)
        count = (try? values.decode(Int.self, forKey: .count)) ?? 0
    }

    func toDictionary() -> [String: Any] {
        [
            CodingKeys.id.rawValue: id,
            CodingKeys.name.rawValue: name,
            CodingKeys.position.rawValue: position,
            CodingKeys.enable.rawValue: enable,
            CodingKeys.count.rawValue: count
        ]
    }
}

extension FolderModel: Equatable {
    static func == (lhs: FolderModel, rhs: FolderModel) -> Bool {
        lhs.id.uppercased() == rhs.id.uppercased()
    }
}
