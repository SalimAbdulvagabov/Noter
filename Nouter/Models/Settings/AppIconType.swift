//
//  AppIconType.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 20.03.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import UIKit

enum AppIconType: Int, CaseIterable, Decodable {
    case bluewLightLines = 0,
         darkwLightLines,
         lightwBlueLines,
         lightwBlackLines

    var decodeValue: String {
        switch self {
        case .bluewLightLines:
            return "BluewLightLines"
        case .darkwLightLines:
            return "DarkwLightLines"
        case .lightwBlueLines:
            return "LightwBlueLines"
        case .lightwBlackLines:
            return "LightwBlackLines"
        }
    }

    var preview: UIImage {
        switch self {
        case .bluewLightLines:
            return #imageLiteral(resourceName: "BluewLightLines@2x.png")
        case .darkwLightLines:
            return #imageLiteral(resourceName: "DarkwLightLines@2x.png")
        case .lightwBlueLines:
            return #imageLiteral(resourceName: "LightwBlueLines@2x.png")
        case .lightwBlackLines:
            return #imageLiteral(resourceName: "LightwBlackLines@2x.png")
        }
    }

    var borderColor: UIColor {
        switch self {
        case .lightwBlueLines, .lightwBlackLines:
            return Colors.lightBorder()!
        case .darkwLightLines:
            return Colors.darkBorder()!
        default:
            return .clear
        }
    }

}
