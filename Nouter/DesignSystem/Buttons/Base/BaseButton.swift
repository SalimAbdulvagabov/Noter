//
//  BaseButton.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 13.02.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import UIKit

class BaseButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.adjustsImageWhenHighlighted = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.adjustsImageWhenHighlighted = false
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {

                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                    self?.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
                })
            } else {

                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                    self?.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            }
        }
    }
}
