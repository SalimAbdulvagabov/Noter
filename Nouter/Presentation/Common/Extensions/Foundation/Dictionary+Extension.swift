//
//  Dictionary+Extension.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 23.06.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import Foundation

extension Dictionary {

    mutating func merge(dict: [Key: Value]) {

        for (key, value) in dict {
            updateValue(value, forKey: key)
        }

    }

}
