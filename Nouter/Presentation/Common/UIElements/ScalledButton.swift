//
//  ScalledButton.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 10.02.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

class ScalledButton: UIButton {

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        adjustsImageWhenHighlighted = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        adjustsImageWhenHighlighted = false
    }

}
