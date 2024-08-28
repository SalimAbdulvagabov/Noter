//
//  UIColor+Hex.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 17.05.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }

    convenience init?(hex: String?) {

        guard let hex = hex else {
            return nil
        }

        var value = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        value.removeAll(where: { $0 == "#" })

        guard value.count == 6,
              let rgb = Int(value, radix: 16)
        else {
            print("Invalid Hex")
            return nil
        }

        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
