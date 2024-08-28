//
//  Optional.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 25.01.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Foundation

extension Optional {
    public var isNil: Bool {
        switch self {
        case .none: return true
        default: return false
        }
    }

    public var isNotNil: Bool {
        !isNil
    }
}
