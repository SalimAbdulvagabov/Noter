//
//  NotificationsService.swift
//  Nouter
//
//  Created by Рамазан Магомедов on 05.12.2020.
//  Copyright © 2020 Рамазан Магомедов. All rights reserved.
//

import Foundation
import UserNotifications

final class NotificationsService: NSObject {

    // MARK: - Propertioes
    private let notificationCenter = UNUserNotificationCenter.current()

    private var notesService = CompositionFactory.shared.core.notes
    private var settingsService = CompositionFactory.shared.core.settings

    // MARK: - Public funcs

    func userRequest() {
        let options: UNAuthorizationOptions = [.alert]

        notificationCenter.requestAuthorization(options: options) { (didAllow, _) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }

    func addNotification(noute: NouteModel, time: Time, dayIncrement: Int) {
        let content = UNMutableNotificationContent()
        content.title = noute.name ?? ""
        content.body = noute.text ?? ""

        let calendar = Calendar.current

        guard dayIncrement == 0 && Time(time.hour, time.minute) > Time(Date()) else {
            return
        }

        guard let day = calendar.date(byAdding: .day, value: dayIncrement, to: Date()) else { return }
        var datComp = Calendar.current.dateComponents([.hour, .minute, .day], from: day)
        datComp.hour = time.hour
        datComp.minute = time.minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: datComp, repeats: false)
        let identifierPostfix = String((noute.name?.count ?? 0)) + String(time.hour) + String(time.minute)
        let request = UNNotificationRequest(identifier:
                                                [
                                                    noute.id,
                                                    identifierPostfix
                                                ].joined(separator: " |-| "),
                                            content: content,
                                            trigger: trigger)

//        notificationCenter.add(request) { (error) in
//            if let error = error {
//                print("Error \(error.localizedDescription)")
//            }
//        }
    }

    func removeAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }

    private func setupNotificationTimes(startTime: Time,
                                        endTime: Time,
                                        repeatability: RepeatabilityNotifications) -> [Time] {
        var result: [Time] = []
        var notificationTime: Time = startTime

        while notificationTime <= endTime {
            result.append(notificationTime)
            notificationTime = Time(notificationTime.hour, notificationTime.minute + repeatability.minutesValue)
        }
        return result
    }

}
