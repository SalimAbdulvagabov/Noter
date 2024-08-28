//
//  Safe.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 16.05.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import Foundation

struct Safe<Base: Decodable>: Decodable {

    let value: Base?

    init(from decoder: Decoder) throws {

        do {
            let container = try decoder.singleValueContainer()
            self.value = try container.decode(Base.self)
        } catch {
            self.value = nil
        }
    }

}
