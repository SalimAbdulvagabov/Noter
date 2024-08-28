//
//  AnalyticsService.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 07.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import YandexMobileMetrica
import FirebaseAnalytics

final class AnalyticsService {

    // MARK: - Public funcs

    func reportEvent(_ message: String) {
        Analytics.logEvent(message, parameters: nil)
        YMMYandexMetrica.reportEvent(message) { error in
            print("AppMetrica event error \(error.localizedDescription)")
        }
    }

    func reportEvent(_ message: String, parameters params: [String: Any]?) {
        Analytics.logEvent(message, parameters: params)
        YMMYandexMetrica.reportEvent(message, parameters: params) { error in
            print("AppMetrica event error \(error.localizedDescription)")
        }
    }

    func reportError(_ message: String, exception: NSException?) {
        Analytics.logEvent(message, parameters: nil)
        YMMYandexMetrica.reportError(message, exception: exception) { error in
            print("AppMetrica event error \(error.localizedDescription)")
        }
    }

}
