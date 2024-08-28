//
//  String+ChangeForPrice.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 16.06.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func strikeThrough() -> NSAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributeString.length))
        return attributeString
    }

}

extension Formatter {

    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()

}

extension BinaryInteger {

    var formattedWithSeparatorAndRub: String {
        return "\(Formatter.withSeparator.string(for: self) ?? "") ₽"
    }

    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }

}
