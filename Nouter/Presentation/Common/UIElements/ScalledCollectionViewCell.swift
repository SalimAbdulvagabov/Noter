//
//  ScalledCollectionViewCell.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 20.03.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

class ScalledCollectionViewCell: UICollectionViewCell {

    override var isHighlighted: Bool {

        didSet {

            if isHighlighted {

                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
                })
            } else {

                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            }

        }

    }

}
