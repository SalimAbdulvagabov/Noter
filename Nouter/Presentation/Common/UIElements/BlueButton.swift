//
//  BlueButton.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 20.12.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class BlueButton: BaseButton {

    var title: String? {
        get {
            titleLabel?.text
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        cornerRadius = 10
        backgroundColor = Colors.blue()
        setTitleColor(.white, for: .normal)
        titleLabel?.font = Fonts.interSemiBold(size: 16)
    }
}
