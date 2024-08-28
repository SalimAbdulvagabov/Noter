//
//  UserApi.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 09.01.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Alamofire
import SwiftKeychainWrapper

enum UserApi: IEndpoint {

    case update(uuid: String, fcmToken: String, settings: SettingsModel)
    case settings

    var path: String {
        switch self {
        case .update:
            return "user"
        case .settings:
            return "user/settings"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .update:
            return .post
        case .settings:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .update(let uuid, let fcmToken, let settings):
            return [
                "uuid": uuid,
                "fcmToken": fcmToken,
                "notificationsEnabled": settings.notificationsEnabled,
                "settings": [
                    "repeat": settings.repeatability.decodeValue,
                    "endTime": [
                        "hour": settings.endTime.hour,
                        "minute": settings.endTime.minute
                    ],
                    "startTime": [
                        "hour": settings.startTime.hour,
                        "minute": settings.startTime.minute
                    ],
                    "apperance": settings.apperance.decodeValue,
                    "appIcon": settings.appIcon.decodeValue
                ]
            ]
        case .settings:
            return [
                "id": KeychainWrapper.standard.string(forKey: "userUuid") ?? ""
            ]
        }
    }

}
