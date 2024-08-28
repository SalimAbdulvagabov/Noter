//
//  SettingsService.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 09.12.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import Combine
import FirebaseMessaging
import SwiftKeychainWrapper

final class SettingsService {

    // MARK: - Private properties

    private let keyStore = NSUbiquitousKeyValueStore()
    private let networkProvider: INetworkProvider
    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Init

    init(networkProvider: INetworkProvider) {
        self.networkProvider = networkProvider
    }

    // MARK: - Public funcs

    func saveSettings(_ model: SettingsModel) {
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: .settingsKey)
        } catch let error {
            print("Save settings error \(error.localizedDescription)")
        }

    }

    func getSettings() -> SettingsModel {
        do {
            if let data = UserDefaults.standard.value(forKey: .settingsKey) as? Data,
               let settings = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? SettingsModel {

                return settings
            }

        } catch let error {
            print("UserDefaults settings error \(error.localizedDescription)")
        }

        return SettingsModel(repeatability: RepeatabilityNotifications(rawValue: 0) ?? .fifteenMin,
                             startTime: Time(10, 00),
                             endTime: Time(20, 00),
                             notificationsEnabled: true,
                             apperance: .system,
                             appIcon: .bluewLightLines)
    }

    func saveCountNotes(_ count: Int) {
        KeychainWrapper.standard.set(count, forKey: .notesCount)
    }

    func getCountNotes() -> Int? {
        KeychainWrapper.standard.integer(forKey: .notesCount)
    }

    func synchronize() {
        migrateSettings()

        let uuid: String
        let fcmToken = Messaging.messaging().fcmToken ?? ""
        if let userUuid = KeychainWrapper.standard.string(forKey: .userUuid) {
            uuid = userUuid
        } else {
            uuid = UUID().uuidString
            KeychainWrapper.standard.set(uuid, forKey: .userUuid)
        }

        let request = UserApi.update(uuid: uuid, fcmToken: fcmToken, settings: getSettings())
        networkProvider.request(ofType: StatusModel.self, to: request)
            .sink { _ in } receiveValue: { _ in }
            .store(in: &subscriptions)
    }

    func loadSettings() {
        let request = UserApi.settings
        networkProvider.request(ofType: SettingsModel.self, to: request)
            .sink { _ in } receiveValue: { [weak self] value in
                self?.saveSettings(value)
            }
            .store(in: &subscriptions)
    }

    func userUuid() -> String {
        KeychainWrapper.standard.string(forKey: .userUuid) ?? ""
    }

    func resetAll() {
        KeychainWrapper.standard.removeAllKeys()
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isFistVisit.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isNeedSynchronize.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isNeedShowReturnModule.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isMigratedDataBase.rawValue)
    }

    // MARK: - Private funcs

    private func migrateSettings() {
        do {

            if let data = keyStore.object(forKey: .settingsKey) as? Data,
               let settings = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? SettingsModel {
                keyStore.removeObject(forKey: .settingsKey)
                saveSettings(settings)
            }

        } catch let error {
            print("Migrate settings error \(error.localizedDescription)")
        }
    }

}
private extension String {
    static let settingsKey = "notificationsSettings"
    static let notesCount = "notesCount"
    static let userUuid = "userUuid"
}
