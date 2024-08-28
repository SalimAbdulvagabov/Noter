//
//  Encodable+Extension.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 10.02.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Foundation

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
