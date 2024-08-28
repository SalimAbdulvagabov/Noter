//
//  UILabel+Extensions.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 16.06.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

extension UILabel {

    // MARK: - Text With Color

    func setTextWithColor(text: String, color: UIColor) {
        self.text = text
        self.textColor = color
    }

    // MARK: - For line spacing

    func setTextWithLineSpacing(text: String?, spacing: CGFloat) {
        let attributedString = NSMutableAttributedString(string: text ?? "")

        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = spacing
        paragraphStyle.lineBreakMode = .byTruncatingTail

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

        attributedText = attributedString
    }

    func setLineSpacing(spacing: CGFloat) {
        let attributedString = NSMutableAttributedString(string: text ?? "")

        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = spacing
        paragraphStyle.lineBreakMode = .byTruncatingTail

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

        attributedText = attributedString
    }

}

extension UILabel {
    convenience init(text: String?) {
        self.init()
        self.text = text
    }
}
