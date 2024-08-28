//
//  UIButton+Extensions.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 22.01.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

extension UIButton {
    var font: UIFont? {
        get {
            titleLabel?.font
        } set {
            titleLabel?.font = newValue
        }
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside,
                   _ closure: @escaping() -> Void) {
        addAction(UIAction { (_: UIAction) in closure() }, for: controlEvents)
    }
}
