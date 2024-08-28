//
//  String+Url.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 18.05.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import Foundation

extension String {
    var toURL: URL? {
        return URL(string: self)
    }
}
