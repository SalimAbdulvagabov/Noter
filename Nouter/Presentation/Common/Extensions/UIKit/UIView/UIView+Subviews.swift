//
//  UIView+Subviews.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 15.06.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

extension UIView {

    var allSubviews: [UIView] {

        var array = [self.subviews].flatMap {$0}

        array.forEach { array.append(contentsOf: $0.allSubviews) }

        return array
    }

    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach {
            addSubview($0)
        }
    }

}
