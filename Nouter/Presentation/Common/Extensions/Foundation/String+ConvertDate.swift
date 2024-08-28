//
//  String+ConvertDate.swift
//  05.ru
//
//  Created by Айдин Абдурахманов on 27.08.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import Foundation

extension String {

    func convertToDate(currentFormat: String, finishFormat: String) -> String? {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = currentFormat

        guard let newdate = dateFormatter.date(from: self) else { return nil }
        dateFormatter.dateFormat = finishFormat

        return dateFormatter.string(from: newdate)
    }
}
