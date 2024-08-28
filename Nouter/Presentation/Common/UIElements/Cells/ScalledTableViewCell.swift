//
//  ScalledTableViewCell.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 13.11.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

class ScalledTableViewCell: UITableViewCell {

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

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
