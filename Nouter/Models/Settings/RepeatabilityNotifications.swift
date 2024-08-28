//
//  RepeatabilityNotifications.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 12.12.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Foundation

enum RepeatabilityNotifications: Int, CaseIterable, Decodable {
    case fifteenMin = 0
    case thirtyMin
    case oneHour
    case twoHour
    case threeHour
    case fourHour

    var decodeValue: String {
        switch self {
        case .fifteenMin:   return "fifteenMin"
        case .thirtyMin:    return "thirtyMin"
        case .oneHour:      return "oneHour"
        case .twoHour:      return "twoHour"
        case .threeHour:    return "threeHour"
        case .fourHour:     return "fourHour"
        }
    }

    var name: String {
        switch self {
        case .fifteenMin:   return "Каждые 15 мин"
        case .thirtyMin:    return "Каждые 30 мин"
        case .oneHour:      return "Каждый час"
        case .twoHour:      return "Каждые 2 часа"
        case .threeHour:    return "Каждые 3 часа"
        case .fourHour:     return "Каждые 4 часа"
        }
    }

    var minutesValue: Int {
        switch self {
        case .fifteenMin:   return 15
        case .thirtyMin:    return 30
        case .oneHour:      return 60
        case .twoHour:      return 120
        case .threeHour:    return 180
        case .fourHour:     return 240
        }
    }

}
