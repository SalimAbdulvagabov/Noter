//
//  ThemeType.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 19.03.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import UIKit

enum ThemeType: Int, CaseIterable, Decodable {
    case system = 0
    case dark
    case light

    var text: String {
        switch self {
        case .dark: return "Темная"
        case .light: return "Светлая"
        case .system: return "Система"
        }
    }

    var decodeValue: String {
        switch self {
        case .system:
            return "system"
        case .dark:
            return "dark"
        case .light:
            return "light"
        }
    }

    var value: UIUserInterfaceStyle {
        switch self {
        case .dark: return .dark
        case .light: return .light
        case .system: return .unspecified
        }
    }

    var image: UIImage? {
        switch self {
        case .system: return Images.iosSettings()
        default: return nil
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .dark: return UIColor(rgb: 0x15181E)
        case .light: return .white
        case .system: return .clear
        }
    }

    var borderColor: UIColor? {
        switch self {
        case .dark:
            return Colors.darkBorder()
        case .light:
            return Colors.lightBorder()
        default:
            return .clear
        }
    }
}
