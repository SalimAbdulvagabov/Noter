//
//  ButtonWithStyle.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 03.12.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class LargeClickZoneButton: ScalledButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
 
}
