//
//  Time.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 04.12.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//
import Foundation

struct Time: Comparable, Equatable {
    init(_ date: Date) {
        // get the current calender
        let calendar = Calendar.current

        // get just the minute and the hour of the day passed to it
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)

        // calculate the seconds since the beggining of the day for comparisions
        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60

        // set the varibles
        secondsSinceBeginningOfDay = dateSeconds
        hour = dateComponents.hour!
        minute = dateComponents.minute!
        timeDescription = [(hour < 10 ? "0\(hour)" : hour.description),
                           (minute < 10 ? "0\(minute)" : minute.description)].joined(separator: ":")
    }

    init(_ hour: Int, _ minute: Int) {
        // calculate the seconds since the beggining of the day for comparisions
        var correntHour = hour
        var correctMinute = minute
        if minute >= 60 {
            let diffHour = Int(floor(Double(correctMinute/60)))
            correntHour += diffHour
            correctMinute = minute - (diffHour*60)
        }
        let dateSeconds = correntHour * 3600 + correctMinute * 60

        // set the varibles
        secondsSinceBeginningOfDay = dateSeconds
        self.hour = correntHour
        self.minute = correctMinute
        timeDescription = [(correntHour < 10 ? "0\(correntHour)" : correntHour.description),
                           (correctMinute < 10 ? "0\(correctMinute)" : correctMinute.description)].joined(separator: ":")
    }

    var hour: Int
    var minute: Int

    /// the number or seconds since the beggining of the day, this is used for comparisions
    let secondsSinceBeginningOfDay: Int

    var timeDescription: String

    var date: Date {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm"
        guard let date = dateFormater.date(from: timeDescription) else {
            return Date()
        }
        return date
    }

    // comparisions so you can compare times
    static func == (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay == rhs.secondsSinceBeginningOfDay
    }

    static func < (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay < rhs.secondsSinceBeginningOfDay
    }

    static func <= (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay <= rhs.secondsSinceBeginningOfDay
    }

    static func >= (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay >= rhs.secondsSinceBeginningOfDay
    }

    static func > (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay > rhs.secondsSinceBeginningOfDay
    }
}

extension Time: Decodable {

    private enum CodingKeys: String, CodingKey {
        case hour, minute
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let hour = try values.decode(Int.self, forKey: .hour)
        let minute = try values.decode(Int.self, forKey: .minute)
        self.init(hour, minute)
    }
}
