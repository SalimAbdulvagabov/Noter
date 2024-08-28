//
//  Array + Compare.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 05.07.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {

    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }

}

extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            if !uniqueValues.contains(item) {
                uniqueValues += [item]
            }
        }
        return uniqueValues
    }
}
