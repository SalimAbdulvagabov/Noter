//
//  UITextView+Extensions.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 23.11.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

extension UITextView {

    func setTextWithLineSpacing(text: String?, spacing: CGFloat) {
        let attributedString = NSMutableAttributedString(string: text ?? "")

        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = spacing

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

        attributedText = attributedString
    }

}
