//
//  UIEdgeInsets.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 13.02.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import UIKit

public extension UIEdgeInsets {

    init(edges: CGFloat) {
        self.init(top: edges, left: edges, bottom: edges, right: edges)
    }

    init(top: CGFloat = 0, bottom: CGFloat = 0) {
        self.init(top: top, left: 0, bottom: bottom, right: 0)
    }

    init(left: CGFloat = 0, right: CGFloat = 0) {
        self.init(top: 0, left: left, bottom: 0, right: right)
    }

    init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    var horizontal: CGFloat {
        left + right
    }

    var vertical: CGFloat {
        top + bottom
    }
}
