//
//  CustomTextView.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 23.11.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        autocorrectionType = .no
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        autocorrectionType = .no
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        var superRect = super.caretRect(for: position)
        guard let font = self.font else { return superRect }

        // "descender" is expressed as a negative value,
        // so to add its height you must subtract its value
        superRect.size.height = font.pointSize - font.descender
        return superRect
    }

}
