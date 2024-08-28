//
//  SettingsModel.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 09.12.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Foundation

final class SettingsModel: NSObject, NSCoding, Decodable {

    var repeatability: RepeatabilityNotifications
    var startTime: Time
    var endTime: Time
    var notificationsEnabled: Bool
    var apperance: ThemeType
    var appIcon: AppIconType

    enum CodingKeys: String, CodingKey {
        case repeatability = "repeat"
        case startTime
        case endTime
        case notificationsEnabled
        case apperance
        case appIcon
    }

    init(repeatability: RepeatabilityNotifications,
         startTime: Time,
         endTime: Time,
         notificationsEnabled: Bool,
         apperance: ThemeType,
         appIcon: AppIconType) {
        self.repeatability = repeatability
        self.startTime = startTime
        self.endTime = endTime
        self.notificationsEnabled = notificationsEnabled
        self.apperance = apperance
        self.appIcon = appIcon
    }

    func encode(with coder: NSCoder) {
        coder.encode(repeatability.rawValue, forKey: CodingKeys.repeatability.rawValue)
        coder.encode(startTime.date, forKey: CodingKeys.startTime.rawValue)
        coder.encode(endTime.date, forKey: CodingKeys.endTime.rawValue)
        coder.encode(notificationsEnabled, forKey: CodingKeys.notificationsEnabled.rawValue)
        coder.encode(apperance.rawValue, forKey: CodingKeys.apperance.rawValue)
        coder.encode(appIcon.rawValue, forKey: CodingKeys.appIcon.rawValue)
    }

    required init?(coder: NSCoder) {
        self.repeatability = RepeatabilityNotifications(rawValue: coder.decodeInteger(forKey: CodingKeys.repeatability.rawValue)) ?? .oneHour
        self.notificationsEnabled = coder.decodeBool(forKey: CodingKeys.notificationsEnabled.rawValue)
        self.apperance = ThemeType(rawValue: coder.decodeInteger(forKey: CodingKeys.apperance.rawValue))
            ?? .system
        self.appIcon = AppIconType(rawValue: coder.decodeInteger(forKey: CodingKeys.appIcon.rawValue))
            ?? .bluewLightLines

        if let startDate = coder.decodeObject(forKey: CodingKeys.startTime.rawValue) as? Date {
            self.startTime = Time(startDate)
        } else {
            self.startTime = Time(0, 0)
        }

        if let endDate = coder.decodeObject(forKey: CodingKeys.endTime.rawValue) as? Date {
            self.endTime = Time(endDate)
        } else {
            self.endTime = Time(0, 0)
        }

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        let repeatValue = try values.decode(String.self, forKey: .repeatability)
        repeatability = RepeatabilityNotifications.allCases.first { $0.decodeValue == repeatValue} ?? .oneHour
        notificationsEnabled = try values.decode(Bool.self, forKey: .notificationsEnabled)

        startTime = try values.decode(Time.self, forKey: .startTime)
        endTime = try values.decode(Time.self, forKey: .endTime)

        let apperanceValue = try values.decode(String.self, forKey: .apperance)
        apperance = ThemeType.allCases.first { $0.decodeValue == apperanceValue} ?? .system

        let appIconValue = try values.decode(String.self, forKey: .appIcon)
        appIcon = AppIconType.allCases.first { $0.decodeValue == appIconValue} ?? .bluewLightLines
    }

}
