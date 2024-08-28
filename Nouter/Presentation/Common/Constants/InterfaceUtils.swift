//
//  InterfaceUtils.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 17.05.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

struct InterfaceUtils {
    static let screenBounds = UIScreen.main.bounds
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let hasMatch = UIDevice.current.hasNotch
    static let osTheme = UIScreen.main.traitCollection.userInterfaceStyle
}
