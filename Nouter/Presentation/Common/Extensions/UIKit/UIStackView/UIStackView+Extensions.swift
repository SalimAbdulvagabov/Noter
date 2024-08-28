//
//  UIStackView+Extensions.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 13.09.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

public extension UIStackView {
    convenience init(
        axis: NSLayoutConstraint.Axis = .horizontal,
        spacing: CGFloat = 0.0,
        translatesAutoresizingMask: Bool = true,
        arrangedSubviews: [UIView] = [],
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        self.alignment = alignment
        self.distribution = distribution
    }

    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }

    func removeArrangedSubviews() {
        for view in arrangedSubviews {
            removeArrangedSubview(view)
        }
    }
}
