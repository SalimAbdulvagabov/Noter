//
//  Foundation + Extension.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 16.05.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import Foundation

extension NSObject {

    static var className: String {
        return String(describing: self)
    }
    var className: String {
        return String(describing: type(of: self))
    }

}
