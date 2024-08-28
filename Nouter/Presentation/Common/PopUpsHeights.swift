//
//  PopUpsHeights.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 28.03.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import Foundation
import UIKit

enum PopUpsHeights {
    case settings
    case siriCommands
    case notificationsFromOnbording
    case notificationsFromSettings(append: CGFloat = 0)
    case apperance
    case weReturn
    case folders(count: Int)
    case newFolder

    var value: CGFloat {
        var value: CGFloat = 0

        switch self {
        case .settings:
            value = 512
        case .siriCommands:
            value = 407
        case .apperance:
            value = 441
        case .notificationsFromSettings(let append):
            value = 373 + append
        case .notificationsFromOnbording:
            value = 361
        case .weReturn:
            value = 526
        case .folders(let count):
            value = CGFloat(142 + count * 68)
        case .newFolder:
            value = 314
        }

        return InterfaceUtils.hasMatch ? value : value - 34
    }
}
